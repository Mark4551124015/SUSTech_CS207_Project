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

module car (
    input sys_clk,  // 100MHz system clock
    input rx,  // FPGA serial port sender
    output tx,  // FPGA serial port receiver
    input rst,  // Not reset button, but driving mode selection button
    // Button
    input power_button,  // Power on button
    // input power_off,  // Power off button
    input front_button,  // Move front button
    input left_button,  // Turn left button
    input right_button,  // Turn right button
    input back_button,  // Move back button
    input mode,
    // Switch
    input clutch,  // Clutch switch
    input throttle,  // Throttle switch
    input brake,  // Brake switch
    input reverse,  // Reverse switch
    // Light
    output power_state,  // Power state light
    output [1:0] driving_mode,  // Driving mode lights
    output [1:0] car_state,  // Car state lights
    output clutch_show,  // Clutch show light
    output throttle_show,  // Throttle show light
    output break_show,  // Break show light
    output reverse_show,  // Reverse show light
    output reverse_mode,  // Another reverse show light since sometimes circuit problem
    output [1:0] turning_show,  // Turning show lights
    output [7:0] seg_en,  // Rnables of eight seven segment digital tubes
    output [7:0] seg_out0,  // Outputs of first 4 lights
    output [7:0] seg_out1,  // Outputs of last 4 lights
    output [3:0] detector_show,  // Detector show lights
    // VGA
    output [11:0] rgb,  // Red, green and blue color signals
    output hsync,  // Line synchronization signal
    output vsync  // Field synchronization signal
);
  wire clk;
  wire [3:0] switch_total = {clutch, throttle, brake, reverse};
  wire [4:0] state;

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
  wire power_off = ~rst;        // Power off button
  wire stay;

  wire [5:0] button_total = {back_button, power_button, power_off, front_button, left_button, right_button};

  wire [23:0] record;
  wire auto_enable = state[3] & state[2];
  wire [3:0] detector = {front_detector, back_detector, left_detector, right_detector};
  assign reverse_mode = reverse_show;
  assign clk = sys_clk;
  assign detector_show = auto_state;

  // State Machine
  state_machine state_machine (
      .clk(clk),
      .mode(mode),
      .stay(stay),
      .detector(detector),
      .switch_total(switch_total),
      .button_total(button_total),
      .state(state)
  );

  auto_module auto_module (
      .clk(clk),
      .enable(auto_enable),
      .detector(detector),
      .auto_move(auto_move),
      .placeBarrier(place_barrier_signal),
      .destroyBarrier(destroy_barrier_signal),
      .auto_state_out(auto_state)
  );

  moving_module moving_module (
      .clk(clk),
      .state(state),
      .auto_move(auto_move),
      .stay(stay),
      .switch_total(switch_total),
      .button_total(button_total),
      .move_forward_signal(move_forward_signal),
      .move_backward_signal(move_backward_signal),
      .turn_left_signal(turn_left_signal),
      .turn_right_signal(turn_right_signal)
  );

  lighting_module lighting_module (
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

  record_module record_module (
      .clk(clk),
      .state(state),
      .record(record),
      .seg_en(seg_en),
      .seg_out0(seg_out0),
      .seg_out1(seg_out1),
      .move_forward_signal(move_forward_signal),
      .move_backward_signal(move_backward_signal)
  );


  // VGA Showing Module
  vga_module vga_module (
      .clk(sys_clk),
      .state(state),
      .record(record),
      .rgb(rgb),
      .hsync(hsync),
      .vsync(vsync)
  );

  SimulatedDevice uart_device(
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
