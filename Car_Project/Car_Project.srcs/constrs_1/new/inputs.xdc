#电源开关按钮       按键S2
set_property PACKAGE_PIN R15 [get_ports power_button]
set_property IOSTANDARD LVCMOS33 [get_ports power_button]

set_property PACKAGE_PIN R17 [get_ports power_off]
set_property IOSTANDARD LVCMOS33 [get_ports power_off]


#前进按钮       按键S4
set_property PACKAGE_PIN U4 [get_ports front_button]
set_property IOSTANDARD LVCMOS33 [get_ports front_button]

#左转按钮           按键S3
set_property PACKAGE_PIN V1 [get_ports left_button]
set_property IOSTANDARD LVCMOS33 [get_ports left_button]
#右转按钮           按键S0
set_property PACKAGE_PIN R11 [get_ports right_button]
set_property IOSTANDARD LVCMOS33 [get_ports right_button]
#离合开关           SW7
set_property PACKAGE_PIN P5 [get_ports clutch]
set_property IOSTANDARD LVCMOS33 [get_ports clutch]
#油门开关           SW6
set_property PACKAGE_PIN P4 [get_ports throttle]
set_property IOSTANDARD LVCMOS33 [get_ports throttle]
#刹车开关           SW5
set_property PACKAGE_PIN P3 [get_ports brake]
set_property IOSTANDARD LVCMOS33 [get_ports brake]
#倒挡开关           SW4
set_property PACKAGE_PIN P2 [get_ports reverse]
set_property IOSTANDARD LVCMOS33 [get_ports reverse]

#RST
set_property PACKAGE_PIN P15 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

