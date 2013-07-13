library ieee;
library work;
use ieee.std_logic_1164.all;
use work.display_driver_pkg.all;
use work.display_driver_altpll_pkg.all;

entity display_driver_top is
    generic
    (
        MEM_ADDR_N      : natural   := 20;      -- Memory address bus width
        MEM_IO_N        : natural   := 8;       -- Memory IO bus width
        LED_N           : natural   := 3;       -- Number of LEDs
        DATA_N          : natural   := 8;       -- Data bus width
        DISP_N          : natural   := 8;       -- Bits per pixel color
        DISP_DELAY      : integer   := 1200000; -- 50ms with 20MHz clock
        CYCLES          : integer   := 20000000;
        PWR_DELAY       : integer   := 200000;  -- 10ms with 20MHz clock
        DATA_DELAY      : integer   := 1180000;
        DEF_BRIGHTNESS  : integer   := 1023;
        DISP_CLK_DIV    : natural   := 10;      -- Disp clock divider
        PWM_DIVIDE      : integer   := 5;       -- Sets the PWM frequency
        PWM_MAX         : integer   := 1024;    -- Number of PWM steps
        COLUMNS         : integer   := 480;
        LINES           : integer   := 272
    );
    port
    (
        clk             : in std_logic;
        mem_addr        : out std_logic_vector(MEM_ADDR_N-1 downto 0);
        mem_io          : inout std_logic_vector(MEM_IO_N-1 downto 0);
        mem_ce          : out std_logic;        -- Memory chip enable
        mem_oe          : out std_logic;        -- Memory output enable
        mem_we          : out std_logic;        -- Memory write enable
        leds            : out std_logic_vector(LED_N-1 downto 0);
        data_in         : in std_logic_vector(DATA_N-1 downto 0);
        data_clk        : in std_logic;
        data_gpio       : in std_logic_vector(1 downto 0);
        disp_red        : out std_logic_vector(DISP_N-1 downto 0);
        disp_green      : out std_logic_vector(DISP_N-1 downto 0);
        disp_blue       : out std_logic_vector(DISP_N-1 downto 0);
        disp_clk        : out std_logic;
        disp_en         : out std_logic;
        disp_hsync      : out std_logic;
        disp_vsync      : out std_logic;
        disp_power      : out std_logic;
        backlight_en    : out std_logic;
        backlight_pwm   : out std_logic
    );
end entity;

architecture dd_top of display_driver_top is

    signal pll_clk          : std_logic := '0';
    signal reset            : std_logic := '1';

begin

    top: display_driver
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
    top_altpll: display_driver_altpll
    port map
    (
        inclk0      => clk,
        locked      => reset,
        c0          => pll_clk
    );

end;
