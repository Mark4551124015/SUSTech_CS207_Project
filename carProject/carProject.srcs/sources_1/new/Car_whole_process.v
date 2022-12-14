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
    input powerButton,          //��Դ���ذ�ť      ����S2
    input modeButton,           //ģʽ�л���ť      ����S4
    input leftButton,           //��ת��ť          ����S3
    input rightButton,          //��ת��ť          ����S0
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
    output[6:0] JourneyShow,     //�г���ʾ��        seg7(��֪����α�ʾ)
    output[7:0] state           //״̬��
    );
    wire[3:0] switchTotal = {clutch,throttle,break,reverse};//������״̬
    //�������ң��ֱ������Ͽ��ء����ſ��ء�ɲ�����ء��������أ�1�����ش򿪣�0�����عرա�
    wire[3:0] buttonTotal = {powerButton,modeButton,leftButton,rightButton};//������״̬
    //�������ң���һλ�����Դ��������λ�����ʻģʽѡ�񰴼�������λ��������ת������
//    wire state = {powerState,drivingMode,carState,reverseShow,turnShow};//������״̬ 
    //�������ң���һλ�����Դ״̬������λ�����ʻģʽ״̬�� ����λ��������״̬����λ��������ǰ����ʻ״̬���߰�λ������������ת��״̬
    reg[7:0] state;
    parameter   

    S0 = 8'b0XXXXXXX,   //�ػ�״̬ ��״̬�³���⵽�ĵ�Դ��ť����������м�⵽��������Ч
    S1 = 8'b11001XXX,   //����Ĭ��ģʽ �ֶ���ʻģʽδ����״̬ΪĬ��״̬ ����&�ֶ�&non-starting
    S2 = 8'b11010XXX,   //����&�ֶ�&starting
    S3 = 8'b11011XXX,   //����&�ֶ�&moving,
    S10 = 8'b101XXXXX,   //����&���Զ�
    S20 = 8'b111XXXXX;   //����&�Զ�

    
always @(posedge sys_clk, negedge rst) 
begin
    if(~rst)
    state<=S0;
    else
    case(state)
    S0:
    if(powerButton) state<=S1;//����û��д�꣬Ӧ����clk�ж�
    else state<=S0;
    S1: //����&�ֶ�&non-starting
    if(switchTotal == 4'b01XX|buttonTotal == 4'b1XXX) state<=S0;    //������״̬01XX/��ť��״̬1XXX  -->  ������״̬0XXXXXXX
    else if(switchTotal==4'b110X)state<=S2;                         //������״̬110X  -->  ������״̬11010XXX
    else if(buttonTotal==4'b01XX)state<=S10;                        //��ť��״̬01XX  -->  ������״̬101XXXXX
    else state<=S1;                                                 //�����������
    S2:
    if(switchTotal == 4'b010X) state<=S3;   //������״̬010X  -->  ������״̬11011XXX
    else if(switchTotal==4'bXX1X)state<=S1; //������״̬XX1X  -->  ������״̬11001XXX
    else if(~state[2]==switchTotal[0]&switchTotal==4'b1XXX)begin 
    state[2] = ~state[2];
    state<=S2;
    end//���������л�
    else if(buttonTotal == 4'b1XXX)state<=0;//��ť��״̬1XXX  -->  ������״̬0XXXXXXX
    else state<=S2;//�����������
    S3:
    if((switchTotal == 4'b0000&state[2]==0)|(switchTotal==4'b1XX0&state[2]==0)|
    (switchTotal==4'b0001&state[2]==1)|(switchTotal==4'b1XX1&state[2]==1)) state<=S2;   //����״̬���S2��starting����ȫ�����
    else if(switchTotal==4'b0X1X&state[2]==0|switchTotal==4'b0X1X&state[2]==1)state<=S1;//����״̬���S1��non-starting����ȫ�����
    else if(switchTotal==4'b0XX1&state[2]==0|switchTotal==4'b0XX0&state[2]==1|buttonTotal==4'b1XXX)state<=S0;//����״̬���S0��poweroff����ȫ�����
    else state<=S3;
    S10:
    if(buttonTotal==4'b1XXX)state<=S0;
    else if(buttonTotal == 4'b01XX)state<=S20;
    else state<=S10;
    S20:
    if(buttonTotal==4'b1XXX)state<=S0;
    else if(buttonTotal == 4'b01XX)state<=S1;
    else state<=S20;
    endcase
end

    
    
endmodule
