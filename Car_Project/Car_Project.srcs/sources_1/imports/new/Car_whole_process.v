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
    // output powerState,          //电源状态显示灯    LED灯D1_0
    // output[1:0] drivingMode,    //驾驶模式显示灯    LED灯D1_1、D1_2
    // output[1:0] carState,       //汽车状态显示灯    LED灯D1_3、D1_4
    // output clutchShow,          //离合显示灯        LED灯D2_7
    // output throttleShow,        //油门显示灯        LED灯D2_6
    // output breakShow,           //刹车显示灯        LED灯D2_5
    // output reverseShow,         //倒挡显示灯        LED灯D2_4
    // output reg [1:0] turnShow,       //转向显示灯        LED灯D1_5、LED灯D1_6
    // output reg [6:0] JourneyShow,     //行程显示灯        seg7(不知道如何表示)
    output reg [5:0] state           //状态机
    );
    wire[3:0] switchTotal = {clutch,throttle,break,reverse};//开关总状态
    //从左往右，分别代表离合开关、油门开关、刹车开关、倒档开关，1代表开关打开，0代表开关关闭。
    wire[3:0] buttonTotal = {powerButton,modeButton,leftButton,rightButton};//按键总状态
    //从左往右，第一位代表电源按键，二位代表驾驶模式选择按键，三四位代表左右转按键。
    //wire state = {powerState,drivingMode,carState,reverseShow,turnShow};//汽车总状态 
    //从左往右，第一位代表电源状态，二三位代表驾驶模式状态， 四五位代表汽车状态，六位代表汽车前后行驶状态，七八位代表汽车左右转向状态
    parameter   

    S0 = 6'b0XXXXX,   //关机状态 该状态下除检测到的电源按钮输入外的所有检测到的输入无效
    S1 = 6'b11001X,   //开机默认模式 手动驾驶模式未启动状态为默认状态 开机&手动&non-starting
    S2 = 6'b11010X,   //开机&手动&starting
    S3 = 6'b11011X,   //开机&手动&moving,
    S10 = 6'b101XXX,   //开机&半自动
    S20 = 6'b111XXX;   //开机&自动

    
always @(posedge sys_clk, negedge rst) 
begin
    if(~rst)
    state<=S0;
    else
    case(state)
    S0:
    if(powerButton) state<=S1;                                  //这里没有写完，应该用clk判断
    else state<=S0;
    S1: //开机&手动&non-starting
    if(switchTotal == 4'b01XX|buttonTotal == 4'b1XXX) state<=S0;    //开关总状态01XX/按钮总状态1XXX  -->  汽车总状态0XXXXX
    else if(switchTotal==4'b110X)state<=S2;                         //开关总状态110X  -->  汽车总状态11010X
    else if(buttonTotal==4'b01XX)state<=S10;                        //按钮总状态01XX  -->  汽车总状态101XXX
    else state<=S1;                                                 //其他情况不变
    S2:
    if(switchTotal == 4'b010X) state<=S3;                           //开关总状态010X  -->  汽车总状态11011X
    else if(switchTotal==4'bXX1X)state<=S1;                         //开关总状态XX1X  -->  汽车总状态11001X
    else if(~state[2]==switchTotal[0]&switchTotal==4'b1XXX)begin 
    state[2] = ~state[2];
    state<=S2;
    end//倒挡开关切换
    else if(buttonTotal == 4'b1XXX)state<=0;                        //按钮总状态1XXX  -->  汽车总状态0XXXXXXX
    else state<=S2;                                                 //其他情况不变
    S3:
    if((switchTotal == 4'b0000&state[2]==0)|(switchTotal==4'b1XX0&state[2]==0)|
    (switchTotal==4'b0001&state[2]==1)|(switchTotal==4'b1XX1&state[2]==1)) state<=S2;   //汽车状态变成S2（starting）的全部情况
    else if(switchTotal==4'b0X1X&state[2]==0|switchTotal==4'b0X1X&state[2]==1)state<=S1;//汽车状态变成S1（non-starting）的全部情况
    else if(switchTotal==4'b0XX1&state[2]==0|switchTotal==4'b0XX0&state[2]==1|buttonTotal==4'b1XXX)state<=S0;//汽车状态变成S0（poweroff）的全部情况
    else state<=S3;
    S10:
    if(buttonTotal==4'b1XXX)state<=S0;          //按电源按钮关机
    else if(buttonTotal == 4'b01XX)state<=S20;  //按切换状态按钮切换状态
    else state<=S10;                            //其他不变
    S20:
    if(buttonTotal==4'b1XXX)state<=S0;          //按电源按钮关机
    else if(buttonTotal == 4'b01XX)state<=S1;   //按切换状态按钮切换状态
    else state<=S20;
    endcase
end
endmodule
