# ArtyZ7 xdc
# LED [3:0]
############################
# On-board led             #
############################
#set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {led_pins[0]}]
#set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {led_pins[1]}]
#set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports {led_pins[2]}]
#set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {led_pins[3]}]
#set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {led_o}]

# CLK source 50 MHz
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk_i]
create_clock -period 8.000 -name clk_pin -waveform {0.000 4.000} [get_ports clk_i]

# Rst Switch[0]
set_property -dict { PACKAGE_PIN M20  IOSTANDARD LVCMOS33 } [get_ports { resetn_i }]; #IO_L7N_T1_AD2N_35 Sch=SW0

#set_property -dict { PACKAGE_PIN M19  IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #IO_L7P_T1_AD2P_35 Sch=SW1

set_property -dict { PACKAGE_PIN D19    IOSTANDARD LVCMOS33 } [get_ports { btn_i[0] }]; #IO_L4P_T0_35 Sch=BTN0
set_property -dict { PACKAGE_PIN D20    IOSTANDARD LVCMOS33 } [get_ports { btn_i[1] }]; #IO_L4N_T0_35 Sch=BTN1
set_property -dict { PACKAGE_PIN L20    IOSTANDARD LVCMOS33 } [get_ports { btn_i[2] }]; #IO_L9N_T1_DQS_AD3N_35 Sch=BTN2
set_property -dict { PACKAGE_PIN L19    IOSTANDARD LVCMOS33 } [get_ports { btn_i[3] }]; #IO_L9P_T1_DQS_AD3P_35 Sch=BTN3




