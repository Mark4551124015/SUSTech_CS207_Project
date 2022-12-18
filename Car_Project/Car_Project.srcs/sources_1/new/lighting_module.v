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

module lighting_module(
   input clk,
    input rst,
    input [3:0] switch_total,
    input [3:0] button_total,
    input [5:0] state
);
    parameter manul_non_staring  = 6'b11001X;
    parameter manul_starting = 6'b11010X;
    parameter manul_moving = 6'b11011X;
    reg clutch,throttle,brake,reverse,leftButton,rightButton;
    always@(posedge clk) begin
        clutch = switch_total[3];
        throttle = switch_total[2];
        brake = switch_total[1];
        reverse = switch_total[0];
        leftButton = button_total[1];
        rightButton = button_total[0];
        casex (state)
            manul_moving: begin
                if (throttle & ~reverse) begin
                    move_forward_signal = 1;
                end
                else if (throttle & reverse) begin
                    move_backward_signal = 1;
                end else begin
                    move_forward_signal    = 0;
                    move_backward_signal = 0;
                end
                if (leftButton & ~rightButton) begin
                    turn_left_signal    = 1;
                    turn_right_signal   = 0;
                end else if (~leftButton & rightButton) begin
                    turn_left_signal    = 0;
                    turn_right_signal   = 1;
                end else begin
                    turn_left_signal    = 0;
                    turn_right_signal   = 0;
                end
            end
            manul_non_staring: begin
                if (leftButton & ~rightButton) begin
                    turn_left_signal    = 1;
                    turn_right_signal   = 0;
                end else if (~leftButton & rightButton) begin
                    turn_left_signal    = 0;
                    turn_right_signal   = 1;
                end else begin
                    turn_left_signal    = 0;
                    turn_right_signal   = 0;
                end
            end
            default: begin
                move_forward_signal     = 0;
                move_backward_signal    = 0;
                turn_left_signal        = 0;
                turn_right_signal       = 0;
            end
        endcase
    end
endmodule
