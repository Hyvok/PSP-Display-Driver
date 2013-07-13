onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /display_driver_tb/clk
add wave -noupdate /display_driver_tb/reset
add wave -noupdate /display_driver_tb/mem_addr
add wave -noupdate /display_driver_tb/mem_io
add wave -noupdate /display_driver_tb/mem_ce
add wave -noupdate /display_driver_tb/mem_oe
add wave -noupdate /display_driver_tb/mem_we
add wave -noupdate /display_driver_tb/leds
add wave -noupdate /display_driver_tb/data_in
add wave -noupdate /display_driver_tb/data_clk
add wave -noupdate /display_driver_tb/data_gpio
add wave -noupdate /display_driver_tb/disp_red
add wave -noupdate /display_driver_tb/disp_green
add wave -noupdate /display_driver_tb/disp_blue
add wave -noupdate /display_driver_tb/disp_clk
add wave -noupdate /display_driver_tb/disp_en
add wave -noupdate /display_driver_tb/disp_hsync
add wave -noupdate /display_driver_tb/disp_vsync
add wave -noupdate /display_driver_tb/disp_power
add wave -noupdate /display_driver_tb/backlight_en
add wave -noupdate /display_driver_tb/backlight_pwm
add wave -noupdate -divider Init
add wave -noupdate /display_driver_tb/dut_inst/init/delay_cnt
add wave -noupdate /display_driver_tb/dut_inst/init/disp_on
add wave -noupdate /display_driver_tb/dut_inst/init/disp_en_on
add wave -noupdate -divider PWM
add wave -noupdate /display_driver_tb/dut_inst/pwm/pwm_cycle_cnt
add wave -noupdate /display_driver_tb/dut_inst/pwm/pwm_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3160668925 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 100000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {100 ms}
