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

module click_detector (
    input clk,  // 100MHz system clock
    input button,  // Input button signal
    output reg button_click  // Output button signal
);
  reg tmp = 0;
  reg [31:0] protect_press = 0;
  reg [31:0] protect_release = 0;
  parameter cool_sec = 32'd2_000_000;
  always @(posedge clk) begin
      if (~tmp & button) begin
        if (protect_press < cool_sec) begin
          protect_press = protect_press + 1; 
        end
        else begin
          tmp = 1;
          protect_release = 0;
        end
      end else if (tmp & ~button) begin
        if (protect_release < cool_sec) begin
          protect_release = protect_release + 1; 
        end
        else begin
          tmp = 0;
          protect_press = 0;
          button_click = 1;
        end
      end else begin
        button_click = 0;
      end
  end
endmodule
