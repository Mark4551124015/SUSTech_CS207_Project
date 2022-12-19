`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 16:47:34
// Design Name: 
// Module Name: Car_whole_process
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


module state_machine(
    input clk,
    input rst,
    input [3:0] switch_total,
    input [3:0] button_total,
    output reg [4:0] state
    );
    wire clutch,throttle,brake,reverse;
    wire power_click, mode_click, reset_click;
    wire power, mode;
    reg [28:0] init = 0;
    wire clk_100hz;
    reg last_reverse;
    
    parameter
        rest = 5'b00000,
        power_off = 5'b0XXXX,   //关机状态 该状态下除检测到的电源按钮输入外的所有检测到的输入无效
        manual_nonstarting = 5'b11001,   //开机默认模式 手动驾驶模式未启动状态为默认状态 开机&手动&non-starting
        manual_starting = 5'b11010,   //开机&手动&starting
        manual_moving = 5'b11011;   //开机&手动&moving

    assign clutch = switch_total[3];
    assign throttle = switch_total[2];
    assign brake = switch_total[1];
    assign reverse = switch_total[0];
    wire [3:0] click;
    click_detector button_click(
            .clk(clk),
            .button(rst),
            .button_click(reset_click)
    );
    
    assign power_click = click[3];
    assign mode_click = click[2];
    assign power = button_total[3];
    assign mode = button_total[2];
    
    always @(posedge clk) begin
        if (reset_click) begin
            state <= rest;  
        end
        else begin
            casex(state)
                power_off:
                begin
                    if(power) begin
                        if (init == 29'o2170321400) begin
                            state <= manual_nonstarting;
                            init <=0;
                        end else begin
                            init = init + 1;
                        end
                    end
                    else begin
                        state <= state;
                        init <=0;
                    end
                end
                //----------------------------------------------------
                manual_nonstarting:
                begin
                    if (~clutch & (brake|(last_reverse != reverse ))) begin
                       state <= rest;
                   end
                   else if (clutch&(last_reverse!=reverse)) begin
                       last_reverse<=reverse;
                   end
                   else if (clutch & throttle) begin
                        state <= manual_starting;
                    end
                    else begin
                        state <= manual_nonstarting;
                    end
                end
                 //----------------------------------------------------
                manual_starting:
                begin
                    if (~clutch &  (brake|(last_reverse != reverse ))) begin
                       state <= rest;
                    end
                    else if (clutch&(last_reverse!=reverse)) begin
                        last_reverse<=reverse;
                    end
                    else if (clutch&brake) begin
                        state <= manual_nonstarting;
                    end
                    else if (~clutch & throttle) begin
                        state <= manual_moving;
                    end
                    else begin
                        state <= manual_starting;
                    end
                end
                 //----------------------------------------------------
                manual_moving:
                begin
                    if (~clutch &  (brake|(last_reverse != reverse ))) begin
                        state <= rest;
                    end
                    else if (clutch | ~throttle) begin
                        state<= manual_starting;
                    end
                    else begin
                        state <= manual_moving;
                    end
                end
                 //----------------------------------------------------
                default: 
                begin
                    init <= init;
                    state <= state;
                end
            endcase                                                                 //其他情况不变
        end
    end
endmodule
