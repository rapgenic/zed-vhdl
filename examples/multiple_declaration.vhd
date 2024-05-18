library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

package multiple_declaration is
end package multiple_declaration;

package body multiple_declaration is
    function f return Integer is
        variable x : Integer;
        variable a, b : Integer;
        variable y : unsigned(3 downto 0);
    begin

    end function f;
end;
