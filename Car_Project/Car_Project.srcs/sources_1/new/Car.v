`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 20:29:56
// Design Name: 
// Module Name: car
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

module car(
    input sys_clk, //bind to P17 pin (100MHz system clock)
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin
    input rst, //reset button
    input front_detector,
    input back_detector,
    input left_detector,
    input right_detector,
    // ����
    input power_button,          //��Դ���ذ�ť       ����S2
    input mode_button,           //ģʽ�л���ť       ����S4
    input left_button,           //��ת��ť           ����S3
    input right_button,          //��ת��ť           ����S0
    // ����
    input clutch,                //��Ͽ���           SW7
    input throttle,              //���ſ���           SW6
    input brake,                 //ɲ������           SW5
    input reverse,               //��������           SW4
    // ��ʾ��
    output power_state,           //��Դ״̬��ʾ��      LED��D1_0
    output[1:0] driving_mode,     //��ʻģʽ��ʾ��      LED��D1_1��D1_2
//    output[1:0] car_state,        //����״̬��ʾ��      LED��D1_3��D1_4
    output clutch_show,           //�����ʾ��         LED��D2_7
    output throttle_show,         //������ʾ��         LED��D2_6
    output break_show,            //ɲ����ʾ��         LED��D2_5
    output reverse_show,          //������ʾ��         LED��D2_4
    output[1:0] turning_show      //ת����ʾ��         LED��D1_5��LED��D1_6
//    output[6:0] journey_show       //�г���ʾ
);
wire clk;
//�������ң��ֱ������Ͽ��ء����ſ��ء�ɲ�����ء��������أ�1�����ش򿪣�0�����عرա�
wire[3:0] switch_total = {clutch,throttle,brake,reverse};//������״̬
//�������ң���һλ�����Դ��������λ�����ʻģʽѡ�񰴼�������λ��������ת������
wire[3:0] button_total = {power_button,mode_button,left_button,right_button};//������״̬
wire[5:0] state;

wire move_forward_signal;
wire move_backward_signal;
wire turn_left_signal;
wire turn_right_signal;
wire place_barrier_signal;
wire destroy_barrier_signal;


clk_module clk_module(
    .clk(sys_clk),
    .reset(rst),
    .enable(1),
    .clk_out(clk)
);

state_machine state_machine(
    .clk(clk),
    .state(state),
    .switch_total(switch_total),
    .button_total(button_total)
);

moving_module moving_module(
   .clk(clk),
    .state(state),
    .switch_total(switch_total),
    .button_total(button_total), 
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal),
    .turn_left_signal(turn_left_signal),
    .turn_right_signal(turn_right_signal)
    
);

//Lighting_module lighting_module(

//);


SimulatedDevice simulated_device(
    .sys_clk(sys_clk),
    .rx(rx),
    .tx(tx),
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal),
    .turn_left_signal(turn_left_signal),
    .turn_right_signal(turn_right_signal),
    .place_barrier_signal(place_barrier_signal),
    .destroy_barrier_signal(destroy_barrier_signal),
    .front_detector(front_detector),
    .back_detector(back_detector),
    .left_detector(left_detector),
    .right_detector(right_detector)
);


endmodule
