`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/01/04 21:11:52
// Design Name:
// Module Name: auto_counter
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


module auto_counter (
    input init, // Initialization signal
    input clk, // 100MHz system clock
    input [1:0] init_cnt, // Initial value
    input count_down, // Count down signal
    output reg all_set // Finish count signal
);

  reg lastCD;
  reg inited;
  reg [1:0] counter;
  always @(posedge clk) begin
    if (~inited & init) begin
      counter=init_cnt;
      inited =1;
      all_set=0;
    end
    if (count_down & ~lastCD) begin
      if (counter > 0) begin
        counter=counter - 1;
      end else begin
        all_set=1;
        inited =0;
      end
    end
    lastCD=count_down;
  end
endmodule
