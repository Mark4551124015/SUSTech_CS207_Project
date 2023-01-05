`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mark455
// 
// Create Date: 2022/12/14 18:47:34
// Design Name: clock module
// Module Name: clk_module
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

module clk_module (
    input clk,  // 100MHz system clock
    input enable,  // The signal of whether to enable clock divider
    output reg clk_out  // Output clock
);
  parameter frequency = 2;
  parameter period = 100_000_000 / frequency;
  reg [31:0] cnt;
  always @(posedge clk) begin
    if (enable) begin
      if (cnt == (period >> 1) - 1) begin
        clk_out = ~clk_out;
        cnt     = 0;
      end else begin
        cnt = cnt + 1;
      end
    end else begin
      clk_out = 1;
    end
  end
endmodule




