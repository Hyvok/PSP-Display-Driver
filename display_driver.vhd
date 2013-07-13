LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- TODO: change all delays to be based on a single clock

entity display_driver is
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
        DEF_BRIGHTNESS  : integer   := 300;
        DISP_CLK_DIV    : natural   := 10;      -- Disp clock divider
        PWM_DIVIDE      : integer   := 5;       -- Sets the PWM frequency
        PWM_MAX         : integer   := 1024;    -- Number of PWM steps
        COLUMNS         : integer   := 525; --480+45;
        LINES           : integer   := 286 --272+14;
    );
    port
    (
        clk             : in std_logic;
        pll_clk         : in std_logic;
        reset           : in std_logic;
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

architecture dd of display_driver is

    signal led_states   : std_logic_vector(LED_N-1 downto 0) := "100";
    signal init_done    : boolean := false;
    signal disp_clk_on  : boolean := false;
    signal disp_clk_sig : std_logic := '0';
    signal brightness   : integer := DEF_BRIGHTNESS;
    signal data_on      : boolean := false;
    signal hsync_sig    : std_logic := '0';
    signal vsync_sig    : std_logic := '0';
    signal pos_x        : integer range 0 to COLUMNS-1;
    signal pos_y        : integer range 0 to LINES-1;

    signal spr1_x       : integer range 0 to 511;
    signal spr1_y       : integer range 0 to 511;
begin

-- Init routine which makes sure the display AVdd is powered on after +2.5V
-- and then DISP goes high after 40ms

    init: process(clk, reset)

        variable delay_cnt  : integer range 0 to DISP_DELAY;
        variable disp_on    : boolean := false;

    begin
        if reset = '0' then
            disp_power <= '0';
            disp_on := false;
            init_done <= false;
            delay_cnt := 0;
        elsif rising_edge(clk) then
            if delay_cnt = PWR_DELAY and not disp_on then
                disp_power <= '1';
                disp_on := true;
            elsif delay_cnt = DATA_DELAY and not disp_clk_on then
                disp_clk_on <= true;
            elsif delay_cnt = DISP_DELAY and not init_done then
                init_done <= true;
            elsif delay_cnt < DISP_DELAY then
                delay_cnt := delay_cnt + 1;
            end if;
        end if;
    end process;

-- Generate clock for the display

    disp_clk_gen: process(pll_clk, reset)

        variable clk_cnt    : integer range 0 to DISP_CLK_DIV-1;

    begin
        if reset = '0' then
            disp_clk <= '0';
            disp_clk_sig <= '0';
        elsif rising_edge(pll_clk) then
            if disp_clk_on then
                if clk_cnt < DISP_CLK_DIV-1 then
                    clk_cnt := clk_cnt + 1;
                else
                    disp_clk_sig <= not disp_clk_sig;
                    disp_clk <= disp_clk_sig;
                    clk_cnt := 0;
                end if;
            end if;
        end if;
    end process;

-- Raster generator

    raster_gen: process(disp_clk_sig, reset)

        -- As stated by the datasheets timing diagram
        variable hsync_cnt  : integer range 0 to COLUMNS-1;
        variable vsync_cnt  : integer range 0 to LINES-1;

    begin
        if reset = '0' then
            disp_hsync <= '1';
            disp_vsync <= '1';
            vsync_cnt := 0;
            vsync_sig <= '0';
            hsync_cnt := 0;
            hsync_sig <= '0';
            disp_en <= '0';
        -- Falling edge because disp_clk_sig is inverted compared to disp_clk
        elsif falling_edge(disp_clk_sig) then
            if disp_clk_on then

                if hsync_cnt = 0 then
                    disp_hsync <= '0';
                    hsync_sig <= '0';
                elsif hsync_cnt = 41 then
                    disp_hsync <= '1';
                    hsync_sig <= '1';
                elsif hsync_cnt = 43 then
                    data_on <= true;
                elsif hsync_cnt = 523 then
                    data_on <= false;
                end if;

                if hsync_cnt = COLUMNS-1 then
                    hsync_cnt := 0;
                else
                    hsync_cnt := hsync_cnt + 1;
                end if;

                if hsync_cnt = 0 then
                    if vsync_cnt = 0 then
                        disp_vsync <= '0';
                        vsync_sig <= '0';
                        disp_en <= '1';
                    elsif vsync_cnt = 10 then
                        disp_vsync <= '1';
                        vsync_sig <= '1';
                    end if;

                    if vsync_cnt = 282 then
                        vsync_cnt := 0;
                    else
                        vsync_cnt := vsync_cnt + 1;
                    end if;
                end if;

            end if;
        pos_x <= hsync_cnt - 43;
        pos_y <= vsync_cnt - 12;
        end if;

    end process;

-- Put some data on the display

    data_gen: process(disp_clk_sig, reset)

        -- variable every_second   : integer range 0 to 2-1;
        variable sprite_v_seq  : integer range 0 to 63;
        variable sprite_h_seq  : integer range 0 to 63;
        variable color : std_logic_vector(DISP_N-1 downto 0);
        variable green : integer range 0 to 255;
        variable blue  : integer range 0 to 255;

    begin
        if reset = '0' then
            disp_red <= (others => '0');
            disp_green <= (others => '0');
            disp_blue <= (others => '0');
            sprite_v_seq := 0;
            sprite_h_seq := 0;
            -- every_second := 0;
        elsif falling_edge(disp_clk_sig) then

            disp_red <= (others => '0');
            disp_green <= (others => '0');
            disp_blue <= (others => '0');

            
            if pos_x < 255 then 
                green := pos_x;
            end if;
            if pos_y < 255 then
                blue := pos_y;
            end if;
            disp_green <= std_logic_vector(to_unsigned(green, 8));
            disp_blue <= std_logic_vector(to_unsigned(blue, 8));

            if pos_y = spr1_y then
               sprite_v_seq := 63;
            end if;

            if sprite_v_seq > 0 then
                if pos_x = spr1_x then
                    sprite_h_seq := 63;
                end if;
                
                if pos_x = 0 then
                    sprite_v_seq := sprite_v_seq - 1;
                end if;
            end if;

            if sprite_h_seq > 0 then
                color := std_logic_vector(to_unsigned(sprite_v_seq, 8) rol 3);
                color := color xor std_logic_vector(to_unsigned(sprite_h_seq, 8) rol 3);
                color := color;
                disp_red <= color;
                disp_green <= (others => '0');
                disp_blue <= (others => '0');
                sprite_h_seq := sprite_h_seq - 1;
            end if;

        end if;
    end process;

-- PWM routine for the backlight 

    backlight_pwm_gen: process(clk, reset)

      variable pwm_cycle_cnt   : integer range 0 to PWM_DIVIDE-1;
      variable pwm_val         : integer range 0 to PWM_MAX-1;

  begin
      if reset = '0' then
          backlight_en <= '0';
          backlight_pwm <= '0';
          pwm_cycle_cnt := 0;
          pwm_val := 0;
      elsif rising_edge(clk) then
          backlight_pwm <= '0';
          backlight_en <= '1';

          if brightness = 0 then
              backlight_pwm <= '0';
          elsif pwm_val <= brightness then
              backlight_pwm <= '1';
          end if;
            
      -- PWM reference counter

      if pwm_cycle_cnt < PWM_DIVIDE-1 then
          pwm_cycle_cnt := pwm_cycle_cnt + 1;
      else
          pwm_cycle_cnt := 0;
          if pwm_val < PWM_MAX-1 then
              pwm_val := pwm_val + 1;
          else
              pwm_val := 0;
          end if;
      end if;

      -- Quiet if not init yet
      
      if not init_done then
          backlight_pwm <= '0';
          backlight_en <= '0';
          pwm_cycle_cnt := 0;
          pwm_val := 0;
      end if;  

  end if;
  end process;

-- Scrolling LED lights, poorly done :)

  leds_gen: process(pll_clk, reset)

      variable cnt : integer range 0 to CYCLES-1;

  begin

      if reset = '0' then
          cnt := 0;
          led_states <= "100";
      elsif rising_edge(pll_clk) then
          if cnt >= CYCLES-1 then
              led_states(2) <= led_states(1);
              led_states(1) <= led_states(0);
              led_states(0) <= led_states(2);
              leds <= led_states;
              cnt := 0;
          else
              cnt := cnt + 1;
          end if;
      end if;
  end process;

  animator: process(pll_clk, reset)
      variable i_spr_x : integer range -32768 to 32767;
      variable i_spr_vx : integer range -32768 to 32767;
      variable i_spr_y : integer range -32768 to 32767;
      variable i_spr_vy : integer range -32768 to 32767;
  begin
      if reset = '0' then
          i_spr_x := 100;
          i_spr_vx := 8;
          i_spr_y := 50;
          i_spr_vy := 8;
      elsif rising_edge(vsync_sig) then
          i_spr_x := i_spr_x + i_spr_vx;
          if i_spr_x >= (480-64-1) then
              i_spr_vx := -8;
              i_spr_x := (480-64-1);
          elsif i_spr_x <= 0 then
              i_spr_vx := 8;
              i_spr_x := 0;
          end if;

          i_spr_y := i_spr_y + i_spr_vy;
          if i_spr_y >= (272-64-1) then
              i_spr_vy := -3;
              i_spr_y := (272-64-1);
          elsif i_spr_y <= 0 then
              i_spr_vy := 8;
              i_spr_y := 0;
          end if;
      spr1_x <= i_spr_x;
      spr1_y <= i_spr_y;
      end if;

  end process;
end;
