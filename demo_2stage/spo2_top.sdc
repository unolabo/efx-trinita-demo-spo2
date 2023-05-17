# PLL Constraints
#################
create_clock -period 40.0 -waveform { 0.0 20.0} io_systemClk2
create_clock -period 40.0 -waveform {15.0 35.0} io_systemClk
create_clock -period 10.0 io_systemClk3
create_clock -period 100 jtagCtrl_tck

# False Path
#################
set_false_path -setup -hold -from apb3_to_lcddata/slaveReg* -to lcddrive/r_val_stb*
set_false_path -setup -hold -from apb3_to_lcddata/slaveReg* -to lcddrive/r_val_spo2*
set_false_path -setup -hold -from apb3_to_lcddata/slaveReg* -to lcddrive/r_val_heartrate*
set_false_path -setup -hold -from apb3_to_lcddata/slaveReg* -to lcddrive/r_val_watt*
#set_false_path -setup -hold -from [get_pins {*test_cnt*~FF|Q}]

set_false_path -setup -hold io_asyncResetn
set_false_path -setup -hold soc_inst/io_systemReset
set_clock_groups -exclusive  -group {io_systemClk io_systemClk2} -group {jtagCtrl_tck}
set_clock_groups -asynchronous -group {io_systemClk io_systemClk2} -group {jtagCtrl_tck}
set_clock_groups -asynchronous -group {io_systemClk io_systemClk2} -group {io_systemClk3}

#SPI Constraints
#################
set_output_delay -clock io_systemClk -max -4.700 [get_ports {system_spi_0_io_sclk_write}]
set_output_delay -clock io_systemClk -min -2.571 [get_ports {system_spi_0_io_sclk_write}]
set_output_delay -clock io_systemClk -max -4.700 [get_ports {system_spi_0_io_ss}]
set_output_delay -clock io_systemClk -min -2.571 [get_ports {system_spi_0_io_ss}]
set_input_delay -clock io_systemClk -max 6.168 [get_ports {system_spi_0_io_data_0_read}]
set_input_delay -clock io_systemClk -min 3.084 [get_ports {system_spi_0_io_data_0_read}]
set_output_delay -clock io_systemClk -max -4.700 [get_ports {system_spi_0_io_data_0_write}]
set_output_delay -clock io_systemClk -min -2.571 [get_ports {system_spi_0_io_data_0_write}]
set_output_delay -clock io_systemClk -max -4.707 [get_ports {system_spi_0_io_data_0_writeEnable}]
set_output_delay -clock io_systemClk -min -2.567 [get_ports {system_spi_0_io_data_0_writeEnable}]
set_input_delay -clock io_systemClk -max 6.168 [get_ports {system_spi_0_io_data_1_read}]
set_input_delay -clock io_systemClk -min 3.084 [get_ports {system_spi_0_io_data_1_read}]
set_output_delay -clock io_systemClk -max -4.700 [get_ports {system_spi_0_io_data_1_write}]
set_output_delay -clock io_systemClk -min -2.571 [get_ports {system_spi_0_io_data_1_write}]
set_output_delay -clock io_systemClk -max -4.707 [get_ports {system_spi_0_io_data_1_writeEnable}]
set_output_delay -clock io_systemClk -min -2.567 [get_ports {system_spi_0_io_data_1_writeEnable}]

# JTAG Constraints
####################
set_output_delay -clock jtagCtrl_tck -max 0.111 [get_ports {jtag_inst1_TDO}]
set_output_delay -clock jtagCtrl_tck -min 0.053 [get_ports {jtag_inst1_TDO}]
set_input_delay -clock_fall -clock jtagCtrl_tck -max 0.267 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtagCtrl_tck -min 0.134 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtagCtrl_tck -max 0.267 [get_ports {jtag_inst1_RESET}]
set_input_delay -clock_fall -clock jtagCtrl_tck -min 0.134 [get_ports {jtag_inst1_RESET}]
set_input_delay -clock_fall -clock jtagCtrl_tck -max 0.231 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtagCtrl_tck -min 0.116 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtagCtrl_tck -max 0.267 [get_ports {jtag_inst1_UPDATE}]
set_input_delay -clock_fall -clock jtagCtrl_tck -min 0.134 [get_ports {jtag_inst1_UPDATE}]
set_input_delay -clock_fall -clock jtagCtrl_tck -max 0.321 [get_ports {jtag_inst1_SHIFT}]
set_input_delay -clock_fall -clock jtagCtrl_tck -min 0.161 [get_ports {jtag_inst1_SHIFT}]

