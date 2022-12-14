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
    input powerButton,                //��Դ���ذ�ť      ����S2
    input modeButton,         //ģʽ�л���ť      ����S4
    input leftButton,         //��ת��ť          ����S3
    input rightButton,        //��ת��ť          ����S0
    input clutch,               //��Ͽ���          SW7
    input throttle,             //���ſ���          SW6
    input break,                //ɲ������          SW5
    input reverse,              //��������          SW4
    output powerState,          //��Դ״̬��ʾ��    LED��D1_0
    output[1:0] drivingMode,    //��ʻģʽ��ʾ��    LED��D1_1��D1_2
    output[1:0] carState,       //����״̬��ʾ��    LED��D1_3��D1_4
    output clutchShow,          //�����ʾ��        LED��D2_7
    output throttleShow,        //������ʾ��        LED��D2_6
    output breakShow,           //ɲ����ʾ��        LED��D2_5
    output reverseShow,         //������ʾ��        LED��D2_4
    output[1:0] turnShow,       //ת����ʾ��        LED��D1_5��LED��D1_6
    output[6:0] JourneyShow     //�г���ʾ��        seg7(��֪����α�ʾ)
    );
    wire[3:0] switchTotal = {clutch,throttle,break,reverse};//������״̬
    wire[3:0] buttonTotal = {powerButton,modeButton,leftButton,rightButton};//������״̬
    wire[7:0] carStateTotal = {powerState,drivingMode,carState,reverseShow,turnShow};//������״̬
    

    
    
endmodule
