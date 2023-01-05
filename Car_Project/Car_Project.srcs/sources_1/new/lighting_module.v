`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mark455
// 
// Create Date: 2022/12/14 18:47:34
// Design Name: 
// Module Name: lighting_module
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
// inputs: 
//      clk -------     System clock
//      reset -----     Reset
// outputs:
//      clk_out ---     clk generate by clk module 
//
//////////////////////////////////////////////////////////////////////////////////

module lighting_module (
    input clk,  // 100MHz system clock
    input [4:0] state,  // Car state
    input [3:0] switch_total,  // Total switch inputs 
    input [5:0] button_total,  // Total button inputs 
    output power_state,  // Power state light
    output [1:0] driving_mode,  // Driving mode lights
    output [1:0] car_state,  // Car state lights
    output clutch_show,  // Clutch show light
    output throttle_show,  // Throttle show light
    output break_show,  // Break show light
    output reverse_show,  // Reverse show light
    output [1:0] turning_show  // Turning show lights
);
  parameter power_off = 5'b0XXXX;
  parameter manual_non_staring = 5'b11001;
  parameter manual_starting = 5'b11010;
  parameter manual_moving = 5'b11011;
  reg enable_left, enable_right, blink;

  assign power_state = state[4];
  assign driving_mode = state[3:2];
  assign car_state = state[1:0];

  assign clutch_show = switch_total[3] & power_state;
  assign throttle_show = switch_total[2] & power_state;
  assign break_show = switch_total[1] & power_state;
  assign reverse_show = switch_total[0] & power_state;

  blink_module left_light (
      .clk(clk),
      .enable(enable_left),
      .blink(blink),
      .clk_out(turning_show[0])
  );

  blink_module right_light (
      .clk(clk),
      .enable(enable_right),
      .blink(blink),
      .clk_out(turning_show[1])
  );

  wire clutch = switch_total[3];
  wire throttle = switch_total[2];
  wire brake = switch_total[1];
  wire reverse = switch_total[0];
  wire leftButton = button_total[1];
  wire rightButton = button_total[0];

  always @(posedge clk) begin
    casex (state)
      manual_non_staring: begin
        enable_left  <= 1;
        enable_right <= 1;
        blink = 0;
      end
      //----------------------------------------------------
      manual_starting: begin
        if (leftButton & ~rightButton) begin
          enable_left  <= 1;
          enable_right <= 0;
          blink = 1;
        end else if (~leftButton & rightButton) begin
          enable_left  <= 0;
          enable_right <= 1;
          blink = 1;
        end else begin
          enable_left  <= 0;
          enable_right <= 0;
          blink = 0;
        end
      end
      //----------------------------------------------------
      manual_moving: begin
        if (leftButton & ~rightButton) begin
          enable_left  <= 1;
          enable_right <= 0;
          blink = 1;
        end else if (~leftButton & rightButton) begin
          enable_left  <= 0;
          enable_right <= 1;
          blink = 1;
        end else begin
          enable_left  <= 0;
          enable_right <= 0;
          blink = 0;
        end
      end
      //----------------------------------------------------
      default: begin
        enable_left  <= 0;
        enable_right <= 0;
        blink = 0;
      end
    endcase
  end
endmodule
