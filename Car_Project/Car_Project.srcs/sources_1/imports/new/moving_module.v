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

module moving_module(input [5:0] state, [3:0] switchTotal, [3:0] buttonTotal, output reg forward, reg backward, reg left, reg right);
    parameter manul_non_staring  = 6'b11001X;
    parameter manul_starting = 6'b11010X;
    parameter manul_moving = 6'b11011X;
    reg clutch,throttle,brake,reverse,leftButton,rightButton;
    always@(*) begin
        clutch <= switchTotal[3];
        throttle <= switchTotal[2];
        brake <= switchTotal[1];
        reverse <= switchTotal[0];
        leftButton <= buttonTotal[1];
        rightButton <= buttonTotal[0];
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




