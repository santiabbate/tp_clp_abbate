

# CLK source 125 MHz
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk_i]
create_clock -period 8.000 -name clk_pin -waveform {0.000 4.000} [get_ports clk_i]

# Rst Switch[0]
set_property -dict { PACKAGE_PIN M20  IOSTANDARD LVCMOS33 } [get_ports { resetn_i }]; #IO_L7N_T1_AD2N_35 Sch=SW0

# Botones
set_property -dict { PACKAGE_PIN D19    IOSTANDARD LVCMOS33 } [get_ports { btn_i[0] }]; #IO_L4P_T0_35 Sch=BTN0
set_property -dict { PACKAGE_PIN D20    IOSTANDARD LVCMOS33 } [get_ports { btn_i[1] }]; #IO_L4N_T0_35 Sch=BTN1
set_property -dict { PACKAGE_PIN L20    IOSTANDARD LVCMOS33 } [get_ports { btn_i[2] }]; #IO_L9N_T1_DQS_AD3N_35 Sch=BTN2
set_property -dict { PACKAGE_PIN L19    IOSTANDARD LVCMOS33 } [get_ports { btn_i[3] }]; #IO_L9P_T1_DQS_AD3P_35 Sch=BTN3




