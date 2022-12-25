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
    // Button
    input power_button,          
    input power_off,                

    input front_button,           
    input left_button,           
    input right_button,          
    // Switch
    input clutch,                
    input throttle,              
    input brake,                 
    input reverse,               
    // Light
    output power_state,           
    output[1:0] driving_mode,     
    output[1:0] car_state,        
    output clutch_show,         
    output throttle_show,         
    output break_show,           
    output reverse_show,         
    output reverse_mode,          
    output [1:0] turning_show,     

    output [7:0] seg_en,
    output [7:0] seg_out0,
    output [7:0] seg_out1,
    output [3:0] detector_show

    // VGA
    output [2:0] r,
    output [2:0] g,
    output [1:0] b,
    output hs,
    output vs
);
wire clk;
wire[3:0] switch_total = {clutch,throttle,brake,reverse};
wire[4:0] button_total = {power_button,power_off,front_button,left_button,right_button};
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
wire [23:0] record;
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
    .record(record),
    .seg_en(seg_en),    
    .seg_out0(seg_out0),  
    .seg_out1(seg_out1),
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal)
);

vga_module vga_module(
    .clk(clk),
    .state(state),
    .record(record),
    .r(r),
    .g(g),
    .b(b),
    .hs(hs),
    .vs(vs)
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
