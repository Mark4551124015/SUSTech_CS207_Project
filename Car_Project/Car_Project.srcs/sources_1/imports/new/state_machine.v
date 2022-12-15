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
    output [5:0] state
    );

    parameter
        S0 = 6'b0XXXXX,   //关机状态 该状态下除检测到的电源按钮输入外的所有检测到的输入无效
        S1 = 6'b11001X,   //开机默认模式 手动驾驶模式未启动状态为默认状态 开机&手动&non-starting
        S2 = 6'b11010X,   //开机&手动&starting
        S3 = 6'b11011X,   //开机&手动&moving,
        S10 = 6'b101XXX,   //开机&半自动
        S20 = 6'b111XXX;   //开机&自动
always @(posedge clk, rst)
begin
    if(~rst)
        state<=S0;
    else
        case(state)
            S0://这里没有写完，应该用clk判断
                if(powerButton) state<=S1;
                else state<=S0;
            S1: //开机&手动&non-starting
                if(switch_total == 4'b01XX|button_total == 4'b1XXX) state<=S0;    //开关总状态01XX/按钮总状态1XXX  -->  汽车总状态0XXXXXXX
                else if(switch_total==4'b110X) state<=S2;                         //开关总状态110X  -->  汽车总状态11010XXX
                else if(button_total==4'b01XX) state<=S10;                        //按钮总状态01XX  -->  汽车总状态101XXXXX
                else state<=S1;                                                 //其他情况不变
            S2:
                if(switch_total == 4'b010X) state<=S3;   //开关总状态010X  -->  汽车总状态11011XXX
                else if(switch_total==4'bXX1X)state<=S1; //开关总状态XX1X  -->  汽车总状态11001XXX
                else if(~state[0]==switch_total[0]&switch_total==4'b1XXX)
                    begin 
                    state[0] = ~state[0];
                    state<=S2;
                    end//倒挡开关切换
                else if(button_total == 4'b1XXX)state<=0;//按钮总状态1XXX  -->  汽车总状态0XXXXXXX
                else state<=S2;//其他情况不变
            S3:
                if((switch_total == 4'b0000&state[0]==0)|(switch_total==4'b1XX0&state[0]==0)|
                (switch_total==4'b0001&state[0]==1)|(switch_total==4'b1XX1&state[0]==1)) state<=S2;   //汽车状态变成S2（starting）的全部情况
                else if(switch_total==4'b0X1X&state[0]==0|switch_total==4'b0X1X&state[0]==1)state<=S1;//汽车状态变成S1（non-starting）的全部情况
                else if(switch_total==4'b0XX1&state[0]==0|switch_total==4'b0XX0&state[0]==1|button_total==4'b1XXX)state<=S0;//汽车状态变成S0（poweroff）的全部情况
                else state<=S3;
            S10:
                if(button_total==4'b1XXX)state<=S0;          //按电源按钮关机
                else if(button_total == 4'b01XX)state<=S20;  //按切换状态按钮切换状态
                else state<=S10;                            //其他不变
            S20:
                if(button_total==4'b1XXX)state<=S0;          //按电源按钮关机
                else if(button_total == 4'b01XX)state<=S1;   //按切换状态按钮切换状态
                else state<=S20;
    endcase
end
endmodule
