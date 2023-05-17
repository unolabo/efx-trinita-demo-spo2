onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_lcddrive/CLK
add wave -noupdate -radix hexadecimal /tb_lcddrive/XRST
add wave -noupdate -radix hexadecimal /tb_lcddrive/VAL_SPO2
add wave -noupdate -radix hexadecimal /tb_lcddrive/VAL_HEARTRATE
add wave -noupdate -radix hexadecimal /tb_lcddrive/VAL_WATT
add wave -noupdate -radix hexadecimal /tb_lcddrive/VAL_STB
add wave -noupdate -radix hexadecimal /tb_lcddrive/STATE
add wave -noupdate -radix hexadecimal /tb_lcddrive/CTRL
add wave -noupdate -divider DRIVER
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/CLK
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/XRST
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/VAL_SPO2
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/VAL_HEARTRATE
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/VAL_WATT
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/VAL_STB
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/STATE
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/CTRL
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/state_main
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/c_transmit
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/n_transmit_clear
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/n_transmit_enable
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/n_transmit_done
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/r_transmit_request
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/r_set_instruction
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/c_set_position
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/n_set_position_enable
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/r_ctrl_regsel
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/r_ctrl_xwrite
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/r_ctrl_enble
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/r_ctrl_data
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/r_val_stb
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/r_val_spo2
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/r_val_heartrate
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/r_val_watt
add wave -noupdate -radix hexadecimal /tb_lcddrive/lcddrive/n_stb_trigger
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {159045062700 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 240
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {210 ms}
