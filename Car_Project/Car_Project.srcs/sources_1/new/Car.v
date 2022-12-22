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
    // ����
    input power_button,          //��Դ���ذ�ť       ����S2
    input power_off,                //��Դ���ذ�ť       ����S2

    input front_button,           //ǰ����ť       
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
    output[1:0] car_state,        //����״̬��ʾ��      LED��D1_3��D1_4
    output clutch_show,           //�����ʾ��         LED��D2_7
    output throttle_show,         //������ʾ��         LED��D2_6
    output break_show,            //ɲ����ʾ��         LED��D2_5
    output reverse_show,          //������ʾ��         LED��D2_4
    output reverse_mode,          //������ʾ��         LED��D2_4
    output [1:0] turning_show,      //ת����ʾ��         LED��D1_5��LED��D1_6
//    output[6:0] journey_show       //�г���ʾ
    output [7:0] seg_en,        // 8 ����ˮ�ƿ��� 
    output [7:0] seg_out0,      // ǰ 4 ����ˮ�����
    output [7:0] seg_out1,       // �� 4 ����ˮ�����
    
    output [3:0] detector_show
);
wire clk;
//�������ң��ֱ������Ͽ��ء����ſ��ء�ɲ�����ء��������أ�1�����ش򿪣�0�����عرա�
wire[3:0] switch_total = {clutch,throttle,brake,reverse};//������״̬
//�������ң���һλ�����Դ��������λ�����ʻģʽѡ�񰴼�������λ��������ת������
wire[4:0] button_total = {power_button,power_off,front_button,left_button,right_button};//������״̬
wire[4:0] state;


wire move_forward_signal;
wire move_backward_signal;
wire turn_left_signal;
wire turn_right_signal;
wire place_barrier_signal;
wire destroy_barrier_signal;
wire front_detector;
wire back_detector;
wire left_detector;
wire right_detector;
wire reset;
wire mode = ~rst;
wire [31:0] cool;

wire [3:0] detector = {front_detector,back_detector,left_detector,right_detector};
assign reverse_mode = reverse_show;
assign clk = sys_clk;
assign detector_show = detector;

state_machine state_machine(
    .clk(clk),
    .mode(mode),
    .cool(cool),
    .detector(detector),
    .switch_total(switch_total),
    .button_total(button_total),
    .state(state)
);

moving_module moving_module(
    .clk(clk),
    .state(state),
    .cool(cool),
    .switch_total(switch_total),
    .button_total(button_total), 
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal),
    .turn_left_signal(turn_left_signal),
    .turn_right_signal(turn_right_signal)
);

lighting_module lighting_module(
    .clk(clk),
    .state(state),
    .switch_total(switch_total),
    .button_total(button_total),
    .power_state(power_state),
    .driving_mode(driving_mode),
    .car_state(car_state),
    .clutch_show(clutch_show),
    .throttle_show(throttle_show),
    .break_show(break_show),
    .reverse_show(reverse_show),
    .turning_show(turning_show)
);

record_module record_module(
    .clk(clk),
    .state(state),
    .seg_en(seg_en),    
    .seg_out0(seg_out0),  
    .seg_out1(seg_out1),
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal)
);


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
    .back_detector(left_detector),
    .left_detector(right_detector),
    .right_detector(back_detector)
);


endmodule
