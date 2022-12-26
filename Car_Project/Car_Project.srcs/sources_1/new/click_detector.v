`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/20 00:43:51
// Design Name: 
// Module Name: click_detector
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

module click_detector( input clk, input button, output reg button_click);
        reg  tmp = 0;
        reg  [31:0] protect = 0;
        parameter cool_sec = 32'd2_000_000 ;
        always@(posedge clk) begin
          if (protect == 0) begin
              if (~tmp&button) begin
                tmp <= 1;
              end
              else  if (tmp&~button) begin
                button_click <= 1;
                tmp <= 0;
                protect = cool_sec;
              end
              else begin
                button_click <= 0;
              end
          end
          else begin 
            protect = protect - 1;
            button_click <= 0;
          end
        end
endmodule
