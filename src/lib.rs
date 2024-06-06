use lazy_static::lazy_static;
use regex::Regex;
use std::fs;
use zed_extension_api::{self as zed, CodeLabel, CodeLabelSpan, Result};

// This code was adapted from the csharp extension that is built into Zed.
// That code carried an Apache 2.0 license.

struct VHDLExtension {
    cached_binary_path: Option<String>,
}

impl VHDLExtension {
    fn language_server_binary_path(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<String> {
        if let Some(path) = worktree.which("vhdl_ls") {
            return Ok(path);
        }

        if let Some(path) = &self.cached_binary_path {
            if fs::metadata(path).map_or(false, |stat| stat.is_file()) {
                return Ok(path.clone());
            }
        }

        zed::set_language_server_installation_status(
            &language_server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );
        let release = zed::latest_github_release(
            "VHDL-LS/rust_hdl",
            zed::GithubReleaseOptions {
                require_assets: true,
                pre_release: false,
            },
        )?;

        let (platform, arch) = zed::current_platform();
        let build_string = format!(
            "vhdl_ls-{arch}-{os}",
            os = match platform {
                zed::Os::Mac => "apple-darwin",
                zed::Os::Linux => "unknown-linux-musl",
                zed::Os::Windows => "pc-windows-msvc",
            },
            arch = match arch {
                zed::Architecture::Aarch64 => "aarch64", // NB: Only apple
                zed::Architecture::X8664 => "x86_64",
                zed::Architecture::X86 => "x86", // NB: Missing
            }
        );
        let asset_name = format!("{build_string}.zip");

        let asset = release
            .assets
            .iter()
            .find(|asset| asset.name == asset_name)
            .ok_or_else(|| format!("no asset found matching {:?}", asset_name))?;

        let version_dir = format!("vhdl_ls-{}", release.version);
        let binary_path = format!("{version_dir}/{build_string}/bin/vhdl_ls");

        if !fs::metadata(&binary_path).map_or(false, |stat| stat.is_file()) {
            zed::set_language_server_installation_status(
                &language_server_id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );

            zed::download_file(
                &asset.download_url,
                &version_dir,
                zed::DownloadedFileType::Zip,
            )
            .map_err(|e| format!("failed to download file: {e}"))?;

            let entries =
                fs::read_dir(".").map_err(|e| format!("failed to list working directory {e}"))?;
            for entry in entries {
                let entry = entry.map_err(|e| format!("failed to load directory entry {e}"))?;
                if entry.file_name().to_str() != Some(&version_dir) {
                    fs::remove_dir_all(&entry.path()).ok();
                }
            }
        }

        self.cached_binary_path = Some(binary_path.clone());
        Ok(binary_path)
    }
}

impl zed::Extension for VHDLExtension {
    fn new() -> Self {
        Self {
            cached_binary_path: None,
        }
    }

    fn language_server_command(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        println!("HelloOOoooO!");

        Ok(zed::Command {
            command: self.language_server_binary_path(language_server_id, worktree)?,
            args: Default::default(),
            env: Default::default(),
        })
    }

    fn label_for_completion(
        &self,
        _language_server_id: &zed_extension_api::LanguageServerId,
        completion: zed::lsp::Completion,
    ) -> Option<zed_extension_api::CodeLabel> {
        lazy_static! {
            static ref SIGNAL_CONSTANT_VARIABLE_REGEX: Regex = Regex::new(
                r"^(?<kind>\w+) '(?<identifier>[\w\d_]+|\\.*\\)'( : (?<direction>\w+))?$"
            )
            .unwrap();
        }

        match completion.kind? {
            zed_extension_api::lsp::CompletionKind::Event
            | zed_extension_api::lsp::CompletionKind::Constant => {
                let detail = completion.detail.as_ref()?;
                let captures = SIGNAL_CONSTANT_VARIABLE_REGEX.captures(&detail)?;
                let kind = &captures["kind"];
                let identifier = &captures["identifier"];

                match kind {
                    "signal" | "constant" => {
                        return label_for_signal_constant_variable(kind, identifier)
                    }
                    "port" => return label_for_port(kind, identifier, &captures["direction"]),
                    _ => None,
                }
            }
            _ => None,
        }
    }
}

fn label_for_signal_constant_variable(kind: &str, identifier: &str) -> Option<CodeLabel> {
    let pre = "architecture A of B is\n";
    let space = " ";
    let colon = ": ";
    let post = "T;\nbegin end architecture;";

    let code = format!("{pre}{kind}{space}{identifier}{colon}{post}");

    Some(CodeLabel {
        code,
        spans: vec![
            CodeLabelSpan::code_range({
                let start = pre.len() + kind.len() + space.len();
                start..start + identifier.len()
            }),
            CodeLabelSpan::code_range({
                let start = pre.len() + kind.len() + space.len() + identifier.len();
                start..start + colon.len()
            }),
            CodeLabelSpan::code_range({
                let start = pre.len();
                start..start + kind.len()
            }),
        ],
        filter_range: (0..identifier.len()).into(),
    })
}

fn label_for_port(kind: &str, identifier: &str, direction: &str) -> Option<CodeLabel> {
    let pre = "entity A is ";
    let paren = "(";
    let colon = ": ";
    let post = " T) end entity";

    let code = format!("{pre}{kind}{paren}{identifier}{colon}{direction}{post}");

    Some(CodeLabel {
        code,
        spans: vec![
            CodeLabelSpan::code_range({
                let start = pre.len() + kind.len() + paren.len();
                start..start + identifier.len()
            }),
            CodeLabelSpan::code_range({
                let start = pre.len() + kind.len() + paren.len() + identifier.len();
                start..start + colon.len()
            }),
            CodeLabelSpan::code_range({
                let start = pre.len();
                start..start + kind.len()
            }),
            CodeLabelSpan::literal(" ", None),
            CodeLabelSpan::code_range({
                let start = pre.len() + kind.len() + paren.len() + identifier.len() + colon.len();
                start..start + direction.len()
            }),
        ],
        filter_range: (0..identifier.len()).into(),
    })
}

zed::register_extension!(VHDLExtension);
