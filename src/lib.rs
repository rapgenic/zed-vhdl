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

            zed::make_file_executable(&binary_path)?;
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

        match &completion.kind? {
            zed_extension_api::lsp::CompletionKind::Event
            | zed_extension_api::lsp::CompletionKind::Constant => {
                let detail = completion.detail.as_ref()?;
                let captures = SIGNAL_CONSTANT_VARIABLE_REGEX.captures(&detail)?;
                let kind = &captures["kind"];
                let identifier = &captures["identifier"];

                match kind {
                    "signal" | "constant" => {
                        Some(label_for_signal_constant_variable(kind, identifier))
                    }
                    "port" => Some(label_for_port(kind, identifier, &captures["direction"])),
                    _ => None,
                }
            }
            zed_extension_api::lsp::CompletionKind::Function
            | zed_extension_api::lsp::CompletionKind::Operator => Some(label_for_function2(
                &completion.label,
                completion.detail?.as_str(),
            )),
            zed_extension_api::lsp::CompletionKind::Field => {
                if completion.detail.as_ref()?.contains("function")
                    || completion.detail.as_ref()?.contains("procedure")
                {
                    Some(label_for_function2(
                        &completion.label,
                        completion.detail?.as_str(),
                    ))
                } else {
                    None
                }
            }
            zed_extension_api::lsp::CompletionKind::TypeParameter => {
                Some(label_for_type(completion.label.as_str()))
            }
            zed_extension_api::lsp::CompletionKind::EnumMember => {
                Some(label_for_enum_member(completion.detail?.as_str()))
            }
            _ => None,
        }
    }

    fn label_for_symbol(
        &self,
        _language_server_id: &zed_extension_api::LanguageServerId,
        symbol: zed::lsp::Symbol,
    ) -> Option<CodeLabel> {
        lazy_static! {
            static ref SIGNAL_CONSTANT_VARIABLE_REGEX: Regex = Regex::new(
                r"^(?<kind>\w+) '(?<identifier>[\w\d_]+|\\.*\\)'( : (?<direction>\w+))?$"
            )
            .unwrap();
        }

        match &symbol.kind {
            zed_extension_api::lsp::SymbolKind::Event
            | zed_extension_api::lsp::SymbolKind::Constant => {
                let detail = &symbol.name;
                let captures = SIGNAL_CONSTANT_VARIABLE_REGEX.captures(&detail)?;
                let kind = &captures["kind"];
                let identifier = &captures["identifier"];

                match kind {
                    "signal" | "constant" => {
                        Some(label_for_signal_constant_variable(kind, identifier))
                    }
                    "port" => Some(label_for_port(kind, identifier, &captures["direction"])),
                    _ => None,
                }
            }
            zed_extension_api::lsp::SymbolKind::Function
            | zed_extension_api::lsp::SymbolKind::Operator => {
                Some(label_for_function2("dummy", &symbol.name))
            }
            zed_extension_api::lsp::SymbolKind::Field => {
                if symbol.name.contains("function") || symbol.name.contains("procedure") {
                    Some(label_for_function2("dummy", &symbol.name))
                } else {
                    None
                }
            }
            zed_extension_api::lsp::SymbolKind::TypeParameter => Some(label_for_type(&symbol.name)),
            zed_extension_api::lsp::SymbolKind::EnumMember => {
                Some(label_for_enum_member(&symbol.name))
            }
            _ => None,
        }
    }
}

fn label_for_signal_constant_variable(kind: &str, identifier: &str) -> CodeLabel {
    let pre = "architecture A of B is\n";
    let space = " ";
    let colon = ": ";
    let post = "T;\nbegin end architecture;";

    let code = format!("{pre}{kind}{space}{identifier}{colon}{post}");

    CodeLabel {
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
    }
}

fn label_for_port(kind: &str, identifier: &str, direction: &str) -> CodeLabel {
    let pre = "entity A is ";
    let paren = "(";
    let colon = ": ";
    let post = " T) end entity;";

    let code = format!("{pre}{kind}{paren}{identifier}{colon}{direction}{post}");

    CodeLabel {
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
    }
}

fn label_for_function2(label: &str, detail: &str) -> CodeLabel {
    lazy_static! {
        static ref FUNCTION_SIGNATURE_REGEX: Regex = Regex::new(
            r#"^(?<kind>procedure|function|operator) (?<identifier>[\w\d_]+|\\.*\\|".*")\[(?<parameters>(([\w\d_]+|\\.*\\)(,\s)?)+)?(\s?return (?<return>[\w\d_]+|\\.*\\))?\]$"#
        )
        .unwrap();
    }

    if detail.contains("overloaded") {
        label_for_function("function", label, None, None, true)
    } else {
        let captures = FUNCTION_SIGNATURE_REGEX.captures(&detail).expect(detail);
        let kind = {
            let kind = &captures["kind"];
            if kind == "operator" {
                "function"
            } else {
                kind
            }
        };
        let identifier = &captures["identifier"];
        let parameters = captures.name("parameters").map(|parameters| {
            parameters
                .as_str()
                .split(",")
                .map(|parameter| parameter.trim())
                .collect()
        });
        let ret = captures.name("return").map(|s| s.as_str());
        label_for_function(kind, identifier, parameters, ret, false)
    }
}

fn label_for_function(
    kind: &str,
    identifier: &str,
    parameters: Option<Vec<&str>>,
    ret: Option<&str>,
    overloaded: bool,
) -> CodeLabel {
    let sp = " ";
    let param_begin = "(";
    let param = "p:";
    let param_sep = "; ";
    let params = parameters
        .as_ref()
        .map(|parameters| {
            parameters
                .iter()
                .map(|parameter| format!("{param}{parameter}"))
                .collect::<Vec<_>>()
                .join(param_sep)
        })
        .unwrap_or("".to_string());
    let param_end = ")";
    let mid = " return ";
    let ret2 = ret.unwrap_or("dummy");
    let post = " is begin end function;";

    let code =
        format!("{kind}{sp}{identifier}{sp}{param_begin}{params}{param_end}{mid}{ret2}{post}");

    CodeLabel {
        code,
        spans: {
            let mut spans = Vec::new();

            spans.push(CodeLabelSpan::code_range({
                let start = kind.len() + sp.len();
                start..start + identifier.len()
            }));

            spans.push(CodeLabelSpan::literal(" ", None));
            spans.push(CodeLabelSpan::code_range({
                let start = kind.len() + sp.len() + identifier.len() + sp.len();
                start..start + param_begin.len()
            }));

            if overloaded {
                spans.push(CodeLabelSpan::literal("…", None));
            } else if let Some(parameters) = parameters {
                let mut start =
                    kind.len() + sp.len() + identifier.len() + sp.len() + param_begin.len();

                let mut it = parameters.iter().peekable();
                while let Some(parameter) = it.next() {
                    start += param.len();
                    spans.push(CodeLabelSpan::code_range(start..start + parameter.len()));
                    start += parameter.len();

                    if !it.peek().is_none() {
                        spans.push(CodeLabelSpan::code_range(start..start + param_sep.len()));
                        start += param_sep.len();
                    }
                }
            }

            spans.push(CodeLabelSpan::code_range({
                let start = kind.len()
                    + sp.len()
                    + identifier.len()
                    + sp.len()
                    + param_begin.len()
                    + params.len();
                start..start + param_end.len()
            }));

            if ret.is_some() {
                spans.push(CodeLabelSpan::code_range({
                    let start = kind.len()
                        + sp.len()
                        + identifier.len()
                        + sp.len()
                        + param_begin.len()
                        + params.len()
                        + param_end.len();
                    start..start + mid.len()
                }));
                spans.push(CodeLabelSpan::code_range({
                    let start = kind.len()
                        + sp.len()
                        + identifier.len()
                        + sp.len()
                        + param_begin.len()
                        + params.len()
                        + param_end.len()
                        + mid.len();
                    start..start + ret2.len()
                }));
            }

            spans
        },
        filter_range: (0..identifier.len()).into(),
    }
}

fn label_for_type(identifier: &str) -> CodeLabel {
    let pre = "type ";
    let post = " is record end record;";

    let code = format!("{pre}{identifier}{post}");

    CodeLabel {
        code,
        spans: vec![CodeLabelSpan::code_range({
            let start = pre.len();
            start..start + identifier.len()
        })],
        filter_range: (0..identifier.len()).into(),
    }
}

fn label_for_enum_member(detail: &str) -> CodeLabel {
    lazy_static! {
        static ref ENUM_REGEX: Regex = Regex::new(
            r#"^(?<identifier>[\w\d_]+|\\.*\\|'.*')\[return (?<return>[\w\d_]+|\\.*\\)\]$"#
        )
        .unwrap();
    }

    let captures = ENUM_REGEX.captures(&detail).expect(detail);

    let identifier = &captures["identifier"];
    let kind = &captures["return"];

    let pre = "type ";
    let mid = " is (";
    let post = ");";

    let code = format!("{pre}{kind}{mid}{identifier}{post}");

    CodeLabel {
        code,
        spans: vec![
            CodeLabelSpan::code_range({
                let start = pre.len() + kind.len() + mid.len();
                start..start + identifier.len()
            }),
            CodeLabelSpan::literal(": ", None),
            CodeLabelSpan::code_range({
                let start = pre.len();
                start..start + kind.len()
            }),
        ],
        filter_range: (0..identifier.len()).into(),
    }
}

zed::register_extension!(VHDLExtension);
