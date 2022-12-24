`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 20:29:56
// Design Name: 
// Module Name: car
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module car(
    input sys_clk, //bind to P17 pin (100MHz system clock)
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin
    input rst, //reset button
    // 按键
    input power_button,          //电源开关按钮       按键S2
    input power_off,                //电源开关按钮       按键S2

    input front_button,           //前进按钮       
    input left_button,           //左转按钮           按键S3
    input right_button,          //右转按钮           按键S0
    // 开关
    input clutch,                //离合开关           SW7
    input throttle,              //油门开关           SW6
    input brake,                 //刹车开关           SW5
    input reverse,               //倒挡开关           SW4
    // 显示灯
    output power_state,           //电源状态显示灯      LED灯D1_0
    output[1:0] driving_mode,     //驾驶模式显示灯      LED灯D1_1、D1_2
    output[1:0] car_state,        //汽车状态显示灯      LED灯D1_3、D1_4
    output clutch_show,           //离合显示灯         LED灯D2_7
    output throttle_show,         //油门显示灯         LED灯D2_6
    output break_show,            //刹车显示灯         LED灯D2_5
    output reverse_show,          //倒挡显示灯         LED灯D2_4
    output reverse_mode,          //倒挡显示灯         LED灯D2_4
    output [1:0] turning_show,      //转向显示灯         LED灯D1_5、LED灯D1_6
//    output[6:0] journey_show       //行程显示
    output [7:0] seg_en,        // 8 个流水灯开关 
    output [7:0] seg_out0,      // 前 4 个流水灯输出
    output [7:0] seg_out1,       // 后 4 个流水灯输出
    output [3:0] detector_show
);
wire clk;
//从左往右，分别代表离合开关、油门开关、刹车开关、倒档开关，1代表开关打开，0代表开关关闭。
wire[3:0] switch_total = {clutch,throttle,brake,reverse};//开关总状态
//从左往右，第一位代表电源按键，二位代表驾驶模式选择按键，三四位代表左右转按键。
wire[4:0] button_total = {power_button,power_off,front_button,left_button,right_button};//按键总状态
wire[4:0] state;


wire move_forward_signal;
wire move_backward_signal;
wire turn_left_signal;
wire turn_right_signal;
wire place_barrier_signal;
wire destroy_barrier_signal;
wire [3:0] auto_state;
wire [3:0] auto_move;
wire front_detector;
wire back_detector;
wire left_detector;
wire right_detector;
wire reset;
wire mode = ~rst;
wire [31:0] cool;
wire auto_enable = state[3]&state[2];
wire [3:0] detector = {front_detector,back_detector,left_detector,right_detector};
assign reverse_mode = reverse_show;
assign clk = sys_clk;
assign detector_show  = auto_state;


state_machine state_machine(
    .clk(clk),
    .mode(mode),
    .cool(cool),
    .detector(detector),
    .switch_total(switch_total),
    .button_total(button_total),
    .state(state)
);

auto_module auto_module(
    .clk(clk),
    .enable(auto_enable),
    .detector(detector),
    .auto_move(auto_move),
    .placeBarrier(place_barrier_signal),
    .destroyBarrier(destroy_barrier_signal),
    .auto_state_out(auto_state)
);

moving_module moving_module(
    .clk(clk),
    .state(state),
    .auto_move(auto_move),
    .cool(cool),
    .switch_total(switch_total),
    .button_total(button_total), 
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal),
    .turn_left_signal(turn_left_signal),
    .turn_right_signal(turn_right_signal)
);

lighting_module lighting_module(
    .clk(clk),
    .state(state),
    .switch_total(switch_total),
    .button_total(button_total),
    .power_state(power_state),
    .driving_mode(driving_mode),
    .car_state(car_state),
    .clutch_show(clutch_show),
    .throttle_show(throttle_show),
    .break_show(break_show),
    .reverse_show(reverse_show),
    .turning_show(turning_show)
);

record_module record_module(
    .clk(clk),
    .state(state),
    .seg_en(seg_en),    
    .seg_out0(seg_out0),  
    .seg_out1(seg_out1),
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal)
);


SimulatedDevice simulated_device(
    .sys_clk(sys_clk),
    .rx(rx),
    .tx(tx),
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal),
    .turn_left_signal(turn_left_signal),
    .turn_right_signal(turn_right_signal),
    .place_barrier_signal(place_barrier_signal),
    .destroy_barrier_signal(destroy_barrier_signal),
    .front_detector(front_detector),
    .back_detector(left_detector),
    .left_detector(right_detector),
    .right_detector(back_detector)
);


endmodule
