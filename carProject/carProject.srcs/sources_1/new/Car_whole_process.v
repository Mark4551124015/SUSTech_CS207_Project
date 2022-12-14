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


module Car_whole_process(
    input sys_clk,              //bind to P17 pin (100MHz system clock)
    input rst,                  //reset button
    input powerButton,          //电源开关按钮      按键S2
    input modeButton,           //模式切换按钮      按键S4
    input leftButton,           //左转按钮          按键S3
    input rightButton,          //右转按钮          按键S0
    input clutch,               //离合开关          SW7
    input throttle,             //油门开关          SW6
    input break,                //刹车开关          SW5
    input reverse,              //倒挡开关          SW4
    output powerState,          //电源状态显示灯    LED灯D1_0
    output[1:0] drivingMode,    //驾驶模式显示灯    LED灯D1_1、D1_2
    output[1:0] carState,       //汽车状态显示灯    LED灯D1_3、D1_4
    output clutchShow,          //离合显示灯        LED灯D2_7
    output throttleShow,        //油门显示灯        LED灯D2_6
    output breakShow,           //刹车显示灯        LED灯D2_5
    output reverseShow,         //倒挡显示灯        LED灯D2_4
    output[1:0] turnShow,       //转向显示灯        LED灯D1_5、LED灯D1_6
    output[6:0] JourneyShow     //行程显示灯        seg7(不知道如何表示)
    );
    wire[3:0] switchTotal = {clutch,throttle,break,reverse};//开关总状态
    wire[3:0] buttonTotal = {powerButton,modeButton,leftButton,rightButton};//按键总状态
    wire[7:0] carStateTotal = {powerState,drivingMode,carState,reverseShow,turnShow};//汽车总状态
    parameter   
    S0 = 8'b00000000,   //关机状态
    S1 = 8'b110XXXXX,   //开机
    S2 = 
    
    
always @(posedge sys_clk,negedge rst) 
begin
        if(rst)
            carStateTotal <= 8'b10000000; ;
        else 
        begin
            case(FSM)
            S0:
            begin
                Out_0;          //输出
                if(condition1)        FSM<= S1;//状态转移
                else if (condition2)  FSM<= S2;//状态转移
                …
                end
            S1:begin
                Out_1;          //输出
                if(condition3)       FSM<= S3;//状态转移
                else if (condition4) FSM <=S4; 
                …
                end
                ……
            default: begin
                Out_0;          //输出
                if(condition0) FSM<= S0;//状态转移
                       end
            endcase
            end
        end

    
    
endmodule
