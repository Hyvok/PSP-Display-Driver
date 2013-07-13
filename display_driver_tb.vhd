--
-- testbench template
--
-- 2013-06-09 by JTA
--

library ieee;
library work;
use ieee.std_logic_1164.all;
use work.display_driver_pkg.all;

entity display_driver_tb is
    end entity;

architecture TB of display_driver_tb is

    constant PERIOD         : time := 1 sec/20e6;
    constant PLL_PERIOD     : time := 1 sec/90e6;

    signal clk              : std_logic := '0';
    signal pll_clk          : std_logic := '0';
    signal reset            : std_logic := '1';

    signal mem_addr         : std_logic_vector(19 downto 0);
    signal mem_io           : std_logic_vector(7 downto 0);
    signal mem_ce           : std_logic;
    signal mem_oe           : std_logic;
    signal mem_we           : std_logic;
    signal leds             : std_logic_vector(2 downto 0);
    signal data_in          : std_logic_vector(7 downto 0);
    signal data_clk         : std_logic;
    signal data_gpio        : std_logic_vector(1 downto 0);
    signal disp_red         : std_logic_vector(7 downto 0);
    signal disp_green       : std_logic_vector(7 downto 0);
    signal disp_blue        : std_logic_vector(7 downto 0);
    signal disp_clk         : std_logic;
    signal disp_en          : std_logic;
    signal disp_hsync       : std_logic;
    signal disp_vsync       : std_logic;
    signal disp_power       : std_logic := '0';
    signal backlight_en     : std_logic := '0';
    signal backlight_pwm    : std_logic;

begin

    DUT_inst: display_driver
    generic map
    (
        MEM_ADDR_N      => mem_addr'length,
        MEM_IO_N        => mem_io'length, 
        LED_N           => leds'length,     
        DATA_N          => data_in'length,
        DISP_N          => disp_red'length,
        DISP_DELAY      => 12000,
        CYCLES          => 20000,
        PWR_DELAY       => 2000,
        DATA_DELAY      => 11800,
        DEF_BRIGHTNESS  => 512,
        PWM_DIVIDE      => 5,    
        PWM_MAX         => 1024 
    )
    port map
    (
        clk           => clk,   
        pll_clk       => pll_clk,   
        reset         => reset,
        mem_addr      => mem_addr,
        mem_io        => mem_io,
        mem_ce        => mem_ce,
        mem_oe        => mem_oe,
        mem_we        => mem_we,
        leds          => leds,
        data_in       => data_in,
        data_clk      => data_clk,
        data_gpio     => data_gpio,
        disp_red      => disp_red,
        disp_green    => disp_green,
        disp_blue     => disp_blue,
        disp_clk      => disp_clk,
        disp_en       => disp_en,
        disp_hsync    => disp_hsync,
        disp_vsync    => disp_vsync,
        disp_power    => disp_power,
        backlight_en  => backlight_en,
        backlight_pwm => backlight_pwm
    );

    clk_gen: process(clk)

    begin
        clk <= not clk after PERIOD/2;
    end process;

    pll_clk_gen: process(pll_clk)

    begin
        pll_clk <= not pll_clk after PLL_PERIOD/2;
    end process;

    reset <= '1', '0' after 500 ns;

    tester: process
    begin
        wait until reset = '0';
        wait for 100 ns;
        backlight_en <= '1';
        wait;
    end process;

end;
