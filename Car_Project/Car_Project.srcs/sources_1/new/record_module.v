`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/21 23:55:04
// Design Name: 
// Module Name: record_module
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


module record_module (
    input clk,  // 100MHz system clock
    input [4:0] state,  // Car state
    input move_forward_signal,  // Move forward signal
    input move_backward_signal,  // Move backward signal
    output reg [23:0] record,  // Record data
    output reg [7:0] seg_en,  // Rnables of eight seven segment digital tubes
    output [7:0] seg_out0,  // Outputs of first 4 lights
    output [7:0] seg_out1  // Outputs of last 4 lights
);
  reg [3:0] num0, num1, num2, num3, num4, num5, num6;  // num6 is MSB
  reg [3:0] current_num0, current_num1;
  reg [3:0] seg_state;
  parameter power_off = 5'b0XXXX;
  parameter manual_non_staring = 5'b11001;
  parameter manual_starting = 5'b11010;
  parameter manual_moving = 5'b11011;
  wire clk_2hz, clk_200hz, car_moving;
  assign car_moving = (move_forward_signal || move_backward_signal);
  number_to_seg_module number_to_seg0 (
      .number (current_num0),
      .seg_out(seg_out0)
  );
  number_to_seg_module number_to_seg1 (
      .number (current_num1),
      .seg_out(seg_out1)
  );

  clk_module #(
      .frequency(2)
  ) record_clk (
      .clk(clk),
      .enable(car_moving),
      .clk_out(clk_2hz)
  );


  clk_module #(
      .frequency(200)
  ) clk_div (
      .clk(clk),
      .enable(1),
      .clk_out(clk_200hz)
  );

  always @(negedge clk_2hz or negedge state[4]) begin
    if (~state[4]) begin
      record <= 0;
    end else begin
      record <= record + 1;
    end
  end

  //seg driver
  always @(posedge clk_200hz) begin
    if (seg_state != 4'b0001) seg_state <= seg_state >> 1;
    else seg_state <= 4'b1000;
  end

  always @(posedge clk) begin
    num6 <= record / 1_000_000 % 10;
    num5 <= record / 1_000_00 % 10;
    num4 <= record / 1_000_0 % 10;
    num3 <= record / 1_000 % 10;
    num2 <= record / 1_00 % 10;
    num1 <= record / 1_0 % 10;
    num0 <= record % 10;

    if (~state[4]) begin
      seg_en       <= 8'b0000_0000;
      current_num0 <= 4'b1111;  // show something different to be distinguished from 0
      current_num1 <= 4'b1111;
    end else begin
      case (seg_state)
        4'b1000: begin
          current_num0 <= num6;
          current_num1 <= num2;
          seg_en       <= 8'b1000_1000;
        end
        4'b0100: begin
          current_num0 <= num5;
          current_num1 <= num1;
          seg_en       <= 8'b0100_0100;
        end
        4'b0010: begin
          current_num0 <= num4;
          current_num1 <= num0;
          seg_en       <= 8'b0010_0010;
        end
        4'b0001: begin
          current_num0 <= num3;
          seg_en       <= 8'b0001_0000;
        end
        default: begin
        end
      endcase
    end
  end
endmodule
