`timescale 1ns / 1ps
//
// Create Date: 2022/10/06 14:19:41
// Design Name: 
// Module Name: uart_rx
// Revision 0.01 - File Created
// Additional Comments:
// 
//


module uart_rx(clk_16x,rst,rxd,data_rec,data_ready,data_error);//���������
input clk_16x;//16���Ĳ����ʲ���ʱ���ź�
input rst;//��λ�ź�
input rxd;//���մ�����������
output reg data_ready = 0;//����׼�����źţ���data_ready=1ʱ�����Ѻ��豸���Խ�����8λ����
output reg data_error = 0;//��żУ���
output[7:0] data_rec;

reg framing_error;
reg[7:0] data_out,data_out1;
reg rxd_buf;
reg[15:0] clk_16x_cnt = 0;
reg rxd1 = 1,rxd2 = 1;
reg start_flag = 0;

parameter width=8;
parameter idle=1,one=2,two=3,stop=4;//״̬����4��״̬

reg[width-1:0] present_state = idle;
reg[width-1:0] next_state = idle;//״̬����ǰ״̬����һ��״̬

assign data_rec=data_out1;

//����״̬����ǰ״̬
always@ (posedge clk_16x)
begin
    if(rst)
        present_state<=idle;
     else
        present_state<=next_state;
end

always@(clk_16x_cnt)//���ݵ�ǰ״̬����״̬���ж�����������״̬������һ��״̬
begin
    if(clk_16x_cnt<='d8)//У����ʼλ����
        next_state=idle;
    if(clk_16x_cnt>'d8 && clk_16x_cnt <= 'd136)//����8λ��������
        next_state=one;
    if(clk_16x_cnt>'d136 && clk_16x_cnt <= 'd152)//��żУ��λ����
        next_state=two;
    if(clk_16x_cnt>'d152 && clk_16x_cnt <= 'd168)//����ֹͣλ����
        next_state=stop;
    if(clk_16x_cnt > 'd168)
        next_state=idle;
end
always@(posedge clk_16x)//���ݵ�ǰ״̬����״̬���������
begin
    if(rst)
    begin
        rxd1<=1'd1;
        rxd2<=1'd1;
        data_ready<='d0;
        clk_16x_cnt<='d0;
        start_flag<=0;
    end
    else begin
        case(present_state)
        idle: begin //��⿪ʼλ
              rxd1<=rxd;
              rxd2<=rxd1;
              if((~rxd1)&&rxd2)//��⿪ʼλ����rxd�Ƿ��ɸߵ�ƽ���䵽�͵�ƽ
                    start_flag<='d1;//��rxd1=0,rxd2=1ʱ���ߵ�ƽ���䵽�͵�ƽ
              else if(start_flag==1)
                clk_16x_cnt<=clk_16x_cnt+'d1;
            end
         one: begin //����8λ����
                clk_16x_cnt<=clk_16x_cnt + 'd1;
                if(clk_16x_cnt=='d24)data_out[0]<=rxd;
                else if(clk_16x_cnt=='d40)data_out[1]<=rxd;
                else if(clk_16x_cnt=='d56)data_out[2]<=rxd;
                else if(clk_16x_cnt=='d72)data_out[3]<=rxd;
                else if(clk_16x_cnt=='d88)data_out[4]<=rxd;
                else if(clk_16x_cnt=='d104)data_out[5]<=rxd;
                else if(clk_16x_cnt=='d120)data_out[6]<=rxd;
                else if(clk_16x_cnt=='d136)data_out[7]<=rxd;
            end
         two: begin//��żУ��λ
                if(clk_16x_cnt=='d152)
                begin
                    if(rxd_buf==rxd) data_error<=1'd0;//�޴���
                    else data_error<=1'd1;//�д���
                end
                clk_16x_cnt <= clk_16x_cnt+'d1;
            end
         stop: begin //ֹͣλ
                if(clk_16x_cnt=='d168)
                begin
                    if(1'd1==rxd)
                    begin
                        data_error<=1'd0;//�޴���
                        data_ready<='d1;
                    end
                    else begin
                        data_error<=1'd1;//�д���
                        data_ready<='d0;
                    end
                end
                data_out1<=data_out;
                if(clk_16x_cnt>168)
                begin
                    clk_16x_cnt <= 0;
                    start_flag <= 0;
                end
                else
                    clk_16x_cnt <= clk_16x_cnt + 'd1;
            end
         endcase
    end
end
endmodule

