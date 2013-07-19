LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

package display_driver_altpll_pkg is

    component display_driver_altpll is
        port
        (
            inclk0  : IN STD_LOGIC  := '0';
            c0      : OUT STD_LOGIC;
            locked  : OUT STD_LOGIC 
        );
    end component;
end package;
