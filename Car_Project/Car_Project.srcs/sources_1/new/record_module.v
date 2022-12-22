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


module record_module(
    input clk,
    input reset,
    input [4:0] state,
    input move_forward_signal,
    input move_backward_signal,
    output reg [7:0] seg_en, // enables of 8 lights
    output [7:0] seg_out0,   // output of first 4 lights
    output [7:0] seg_out1);
    
    
    reg [3:0] num0, num1, num2, num3, num4, num5, num6; // num6 is MSB
    reg [3:0] current_num0, current_num1;
    reg [23:0] record;
    reg [3:0] seg_state;
    parameter power_off = 5'b0XXXX;
    parameter manual_non_staring  = 5'b11001;
    parameter manual_starting = 5'b11010;
    parameter manual_moving = 5'b11011;
    wire clk_2hz, clk_100hz, car_moving;
    assign car_moving = (move_forward_signal || move_backward_signal);
    number_translator_module u_number_translator0(.number(current_num0), .reset(reset), .seg_out(seg_out0));
    number_translator_module u_number_translator1(.number(current_num1), .reset(reset), .seg_out(seg_out1));
    blink_module seg_refresh(
        .clk(clk),
        .enable(car_moving),
        .blink(1),
        .clk_out(clk_2hz)
    );
    
    clk_module #(.period(100_000)) clk_div(
        .clk(clk), 
        .reset(reset),
        .enable(1),
        .clk_out(clk_100hz)
    );
    
    
    always@(negedge clk_2hz or posedge reset or negedge state[4]) begin
        if (reset | ~state[4]) begin
             record <= 0;
        end
        else begin
             record = record + 1;
        end
    end
    
    //seg driver
    always@(posedge clk_100hz) begin
        if (reset) begin
            seg_state <= 4'b1000;
        end
        else begin
            if (seg_state != 4'b0001)
                seg_state <= seg_state >> 1;
            else
                seg_state <= 4'b1000;
        end
    end
    

    always@(posedge clk) begin
        if (reset) begin
            num0  <= 0;
            num1  <= 0;
            num2  <= 0;
            num3  <= 0;
            num4  <= 0;
            num5  <= 0;
            num6  <= 0;
        end
        else begin
            num6 <= record/1_000_000%10;
            num5 <= record/1_000_00%10;
            num4 <= record/1_000_0%10;
            num3 <= record/1_000%10;
            num2 <= record/1_00%10;
            num1 <= record/1_0%10;
            num0 <= record%10;
        end
        
        if (~state[4]) begin
            seg_en       <= 8'b0000_0000;
            current_num0 <= 4'b1111; // show something different to be distinguished from 0
            current_num1 <= 4'b1111;
        end
        else begin
            case(seg_state)
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
            endcase
        end
    end
endmodule