`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/21 22:59:00
// Design Name: 
// Module Name: blink_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  2hz
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module blink_module(input clk, enable, blink, output reg clk_out);
    parameter period = 100_000_000;
    reg [31:0] cnt;
    always@(posedge clk) begin
        if (~enable) begin
            clk_out                 <= 0;
            cnt                      <= 0;
        end
        else begin
            if (blink) begin
                if (cnt == (period >> 1 ) - 1) begin
                    clk_out     <= ~clk_out;
                    cnt         <= 0;
                end
                else begin 
                    cnt         <= cnt + 1;
                end    
            end
            else begin
                clk_out <= 1;
            end
        end
    end
endmodule
