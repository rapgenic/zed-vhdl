library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

package if_example is
end package if_example;

package body if_example is
    function f return Integer is
    begin
	    if true then

	    end if;

	    if true then

	    else

	    end if;

	    if true then

	    elsif false then

	    else

	    end if;

	    if true then

	    elsif false then

	    elsif true then

	    else

	    end if;
    end function f;
end;
