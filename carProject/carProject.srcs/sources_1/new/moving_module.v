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

module moving_module(input [7:0] state, [3:0] switchTotal, [3:0] buttonTotal, output reg forward, reg backward, reg left, reg right);
    parameter manul_non_staring  = 8'b11001;
    parameter manul_starting = 8'b11010;
    parameter manul_moving = 8'b11011;
    reg clutch <= switchTotal[3];
    reg throttle <= switchTotal[2];
    reg brake <= switchTotal[1];
    reg reverse <= switchTotal[0];
    reg leftButton <= buttonTotal[1];
    reg rightButton <= buttonTotal[0];

    always@(*) begin
        case (state)
            manul_moving: begin
                if (throttle & ~reverse) begin
                    forward <= 1;
                end
                else if (throttle & reverse) begin
                    backward <= 1;
                end else begin
                    forward    <= 0;
                    backward <= 0;
                end

                if (leftButton & ~rightButton) begin
                    left    <= 1;
                    right   <= 0;
                end else if (~leftButton & rightButton) begin
                    left    <= 0;
                    right   <= 1;
                end else begin
                    left    <= 0;
                    right   <= 0;
                end
            end
            manul_non_staring: begin
                if (leftButton & ~rightButton) begin
                    left    <= 1;
                    right   <= 0;
                end else if (~leftButton & rightButton) begin
                    left    <= 0;
                    right   <= 1;
                end else begin
                    left    <= 0;
                    right   <= 0;
                end
            end
            default: begin
                forward     <= 0;
                backward    <= 0;
                left        <= 0;
                right       <= 0;
            end
        endcase
    end
endmodule




