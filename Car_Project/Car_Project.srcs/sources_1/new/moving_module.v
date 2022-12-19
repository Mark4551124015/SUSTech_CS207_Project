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

module moving_module(
    input clk,
    input [4:0] state,
    input [3:0] switch_total,
    input [3:0] button_total,
    output reg move_forward_signal,
    output reg move_backward_signal,
    output reg turn_left_signal,
    output reg turn_right_signal
);
    parameter power_off = 5'b0XXXX;
    parameter manual_non_staring  = 5'b11001;
    parameter manual_starting = 5'b11010;
    parameter manual_moving = 5'b11011;
    wire clutch,throttle,brake,reverse,leftButton,rightButton;
    assign clutch = switch_total[3];
    assign throttle = switch_total[2];
    assign brake = switch_total[1];
    assign reverse = switch_total[0];
    
    assign leftButton = button_total[1];
    assign rightButton = button_total[0];
    
    always@(posedge clk) begin
        casex (state)
            manual_non_staring: 
            begin
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
            manual_starting: 
                begin
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
                    move_forward_signal    = 0;
                    move_backward_signal = 0;
                end

            manual_moving: 
            begin
                if (throttle & ~reverse) begin
                    move_forward_signal = 1;
                    move_backward_signal = 0;
                end
                else if (throttle & reverse) begin
                    move_forward_signal = 0;
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
            default: 
            begin
                move_forward_signal       = 0;
                move_backward_signal    = 0;
                turn_left_signal                = 0;
                turn_right_signal               = 0;
            end
        endcase
    end
    
endmodule



