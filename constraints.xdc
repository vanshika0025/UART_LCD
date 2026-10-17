############################
# Clock (Configured for 50 MHz period = 20.00ns)
############################

set_property PACKAGE_PIN H11 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

create_clock -period 20.000 -name sys_clk [get_ports clk]


############################
# UART Inputs
############################

# UART Receive Input (Replace with your board's exact physical RX pin)
set_property PACKAGE_PIN G1 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]


############################
# LCD Display Outputs
############################

set_property PACKAGE_PIN M4 [get_ports {data[0]}]
set_property PACKAGE_PIN L5 [get_ports {data[1]}]
set_property PACKAGE_PIN P11 [get_ports {data[2]}]
set_property PACKAGE_PIN N11 [get_ports {data[3]}]
set_property PACKAGE_PIN P13 [get_ports {data[4]}]
set_property PACKAGE_PIN M14 [get_ports {data[5]}]
set_property PACKAGE_PIN M12 [get_ports {data[6]}]
set_property PACKAGE_PIN K12 [get_ports {data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports data[*]]

set_property PACKAGE_PIN P5 [get_ports lcd_e]
set_property IOSTANDARD LVCMOS33 [get_ports lcd_e]

set_property PACKAGE_PIN M5 [get_ports lcd_rs]
set_property IOSTANDARD LVCMOS33 [get_ports lcd_rs]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]