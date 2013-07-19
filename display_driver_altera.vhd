-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

library ieee;
use ieee.std_logic_1164.all;
library altera;
use altera.altera_syn_attributes.all;

entity display_driver_top is
	port
	(
-- {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!

		backlight_en : out std_logic;
		backlight_pwm : out std_logic;
		clk1 : in std_logic;
		data_clk : in std_logic;
		data_gpio : in std_logic_vector(1 downto 0);
		data_in : in std_logic_vector(7 downto 0);
		disp_blue : out std_logic_vector(7 downto 0);
		disp_clk : out std_logic;
		disp_en : out std_logic;
		disp_green : out std_logic_vector(7 downto 0);
		disp_hsync : out std_logic;
		disp_power : out std_logic;
		disp_red : out std_logic_vector(7 downto 0);
		disp_vsync : out std_logic;
		leds : out std_logic_vector(2 downto 0);
		mem_addr : out std_logic_vector(19 downto 0);
		mem_ce : out std_logic;
		mem_io : inout std_logic_vector(7 downto 0);
		mem_oe : out std_logic;
		mem_we : out std_logic
-- {ALTERA_IO_END} DO NOT REMOVE THIS LINE!

	);

-- {ALTERA_ATTRIBUTE_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_ATTRIBUTE_END} DO NOT REMOVE THIS LINE!
end display_driver_top;

architecture ppl_type of display_driver_top is

-- {ALTERA_COMPONENTS_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_COMPONENTS_END} DO NOT REMOVE THIS LINE!
begin
-- {ALTERA_INSTANTIATION_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_INSTANTIATION_END} DO NOT REMOVE THIS LINE!

end;







