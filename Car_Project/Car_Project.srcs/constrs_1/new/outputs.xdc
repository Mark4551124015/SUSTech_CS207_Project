#电源状态显示灯      LED灯D1_0
set_property PACKAGE_PIN K3 [get_ports power_state]
set_property IOSTANDARD LVCMOS33 [get_ports power_state]
#驾驶模式显示灯      LED灯D1_1、D1_2
set_property PACKAGE_PIN M1 [get_ports {driving_mode[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {driving_mode[1]}]
set_property PACKAGE_PIN L1 [get_ports {driving_mode[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {driving_mode[0]}]
#汽车状态显示灯      LED灯D1_3、D1_4
set_property PACKAGE_PIN K6 [get_ports {car_state[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {car_state[1]}]
set_property PACKAGE_PIN J5 [get_ports {car_state[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {car_state[0]}]
#离合显示灯         LED灯D2_7
set_property PACKAGE_PIN F6 [get_ports clutch_show]
set_property IOSTANDARD LVCMOS33 [get_ports clutch_show]
#油门显示灯         LED灯D2_6
set_property PACKAGE_PIN G4 [get_ports throttle_show]
set_property IOSTANDARD LVCMOS33 [get_ports throttle_show]
#刹车显示灯         LED灯D2_5
set_property PACKAGE_PIN G3 [get_ports break_show]
set_property IOSTANDARD LVCMOS33 [get_ports break_show]
#倒挡显示灯         LED灯D2_4
set_property PACKAGE_PIN J4 [get_ports reverse_show]
set_property IOSTANDARD LVCMOS33 [get_ports reverse_show]
set_property PACKAGE_PIN K1 [get_ports reverse_mode]
set_property IOSTANDARD LVCMOS33 [get_ports reverse_mode]
#转向显示灯         LED灯D1_5、LED灯D1_6
set_property PACKAGE_PIN H5 [get_ports {turning_show[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {turning_show[1]}]
set_property PACKAGE_PIN H6 [get_ports {turning_show[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {turning_show[0]}]
#debug
set_property PACKAGE_PIN K2 [get_ports {detector_show[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {detector_show[0]}]
set_property PACKAGE_PIN J2 [get_ports {detector_show[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {detector_show[1]}]
set_property PACKAGE_PIN J3 [get_ports {detector_show[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {detector_show[2]}]
set_property PACKAGE_PIN H4 [get_ports {detector_show[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {detector_show[3]}]