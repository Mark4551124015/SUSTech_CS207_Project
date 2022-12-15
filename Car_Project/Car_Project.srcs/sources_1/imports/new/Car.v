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
    input power_button,          //电源�?关按�?       按键S2
    input mode_button,           //模式切换按钮       按键S4
    input left_button,           //左转按钮           按键S3
    input right_button,          //右转按钮           按键S0
    // �?�?
    input clutch,                //离合�?�?           SW7
    input throttle,              //油门�?�?           SW6
    input brake,                 //刹车�?�?           SW5
    input reverse,               //倒挡�?�?           SW4
    // 显示�?
    output power_state,           //电源状�?�显示灯      LED灯D1_0
    output[1:0] driving_mode,     //驾驶模式显示�?      LED灯D1_1、D1_2
    output[1:0] car_state,        //汽车状�?�显示灯      LED灯D1_3、D1_4
    output clutch_show,           //离合显示�?         LED灯D2_7
    output throttle_show,         //油门显示�?         LED灯D2_6
    output break_show,            //刹车显示�?         LED灯D2_5
    output reverse_show,          //倒挡显示�?         LED灯D2_4
    output[1:0] turning_show,      //转向显示�?         LED灯D1_5、LED灯D1_6
    output[6:0] journey_show       //行程显示
);



wire reset,enable,clk;
//从左�?右，分别代表离合�?关�?�油门开关�?�刹车开关�?��?�档�?关，1代表�?关打�?�?0代表�?关关闭�??
wire[3:0] switch_total = {clutch,throttle,brake,reverse};//�?关�?�状�?
//从左�?右，第一位代表电源按键，二位代表驾驶模式选择按键，三四位代表左右转按键�??
wire[3:0] button_total = {powerButton,modeButton,leftButton,rightButton};//按键总状�?

reg[5:0] state;
parameter   
    S0 = 6'b0XXXXX,   //关机状�?�（该状态下除检测到的电源按钮输入外的所有检测到的输入无效）
    S1 = 6'b11001X,   //�?机默认模�?(手动驾驶模式未启动状态为默认状�??)�?�?&手动&non-starting
    S2 = 6'b11010X,   //�?�?&手动&starting
    S3 = 6'b11011X,   //�?�?&手动&moving,
    S10 = 6'b101XXX,   //�?�?&半自�?
    S20 = 6'b111XXX;   //�?�?&自动


wire move_forward_signal;
wire move_backward_signal;
wire turn_left_signal;
wire turn_right_signal;

wire place_barrier_signal;
wire destroy_barrier_signal;

wire front_detector;
wire back_detector;
wire left_detector;
wire right_detector;

clk_module clk_module(
    sys_clk, reset, enable, clk
);

state_machine state_machine(

);
moving_module moving_module(

);

Lighting_module lighting_module(

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
    .back_detector(back_detector),
    .left_detector(left_detector),
    .right_detector(right_detector)
);


endmodule
