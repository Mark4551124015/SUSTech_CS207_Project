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


module state_machine_old(
    input clk,
    input [3:0] switch_total,
    input [3:0] button_total,
    output reg [5:0] state
    );
    wire power_button;
    reg startingCnt = 0;
    reg init = 0;
    parameter
        S0 = 6'b0XXXXX,   //�ػ�״̬ ��״̬�³���⵽�ĵ�Դ��ť����������м�⵽��������Ч
        S1 = 6'b11001X,   //����Ĭ��ģʽ �ֶ���ʻģʽδ����״̬ΪĬ��״̬ ����&�ֶ�&non-starting
        S2 = 6'b11010X,   //����&�ֶ�&starting
        S3 = 6'b11011X,   //����&�ֶ�&moving,
        S10 = 6'b101XXX,   //����&���Զ�
        S20 = 6'b111XXX;   //����&�Զ�
    assign power_button = button_total[3];
always @(posedge clk)
begin  
    if (~init) begin
        init <= 1;
        state[0] <= 0;
    end
    else
        casex(state) 
            S0://����û��д�꣬Ӧ����clk�ж�
//                if(power_button) begin
//                    if (startingCnt < 1) begin
//                        startingCnt = startingCnt + 1;
//                    end
//                    else begin
//                        startingCnt = 0;
//                        state <= S1;
//                    end
//                end
                state <= S1;
            S1: //����&�ֶ�&non-starting
                if(switch_total == 4'b01XX|button_total == 4'b1XXX) state<=S0;    //������״̬01XX/��ť��״̬1XXX  -->  ������״̬0XXXXXXX
                else if(switch_total==4'b110X) state<=S2;                         //������״̬110X  -->  ������״̬11010XXX
                else if(button_total==4'b01XX) state<=S10;                        //��ť��״̬01XX  -->  ������״̬101XXXXX
                else state<=S1;                                                 //�����������
            S2:
                if(switch_total == 4'b010X) state<=S3;   //������״̬010X  -->  ������״̬11011XXX
                else if(switch_total==4'bXX1X)state<=S1; //������״̬XX1X  -->  ������״̬11001XXX
                else if(~state[0]==switch_total[0]&switch_total==4'b1XXX)
                    begin 
                    state[0] = ~state[0];
                    state<=S2;
                    end//���������л�
                else if(button_total == 4'b1XXX)state<=0;//��ť��״̬1XXX  -->  ������״̬0XXXXXXX
                else state<=S2;//�����������
            S3:
                if((switch_total == 4'b0000&state[0]==0)|(switch_total==4'b1XX0&state[0]==0)|
                (switch_total==4'b0001&state[0]==1)|(switch_total==4'b1XX1&state[0]==1)) state<=S2;   //����״̬���S2��starting����ȫ�����
                else if(switch_total==4'b0X1X&state[0]==0|switch_total==4'b0X1X&state[0]==1)state<=S1;//����״̬���S1��non-starting����ȫ�����
                else if(switch_total==4'b0XX1&state[0]==0|switch_total==4'b0XX0&state[0]==1|button_total==4'b1XXX)state<=S0;//����״̬���S0��poweroff����ȫ�����
                else state<=S3;
            S10:
                if(button_total==4'b1XXX)state<=S0;          //����Դ��ť�ػ�
                else if(button_total == 4'b01XX)state<=S20;  //���л�״̬��ť�л�״̬
                else state<=S10;                            //��������
            S20:
                if(button_total==4'b1XXX)state<=S0;          //����Դ��ť�ػ�
                else if(button_total == 4'b01XX)state<=S1;   //���л�״̬��ť�л�״̬
                else state<=S20;
            defaultmanual_nonstarting
    endcase
end
endmodule
