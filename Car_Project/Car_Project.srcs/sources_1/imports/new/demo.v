`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/06 22:00:30
// Design Name: 
// Module Name: GlobalState
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


module AE86Car(
    input clk,           
    input power_on,             // 点火 button R15
    input power_off,            // 熄火 button R17
    input throttle,             // 油门 switch P3
    input clutch,               // 离合 switch P5
    input brake,                // 刹车 switch P4
    input reverse_gear,         // 倒车 switch P2
    input turn_left,            // 左转 button V1
    input turn_right,           // 右转 button R11
    //由于题上说明左右转用按钮，所以手动半自动左右转共用
    // input turn_left_Semi,       // 左转 button V1
    // input turn_right_Semi,      // 右转 button R11
    input go_straight_semi,     // 直走 button U4
    input rst_n,                // reset button P15
    input rx,                   // 输入 绑定到 N5
    output tx,                  // 输出 绑定到 T4
    input [1:0] mode_selection, // 模式选择 switch*2 N4 R1
    output turn_left_light,     // 左转灯 led F6
    output turn_right_light,    // 右转灯 led G4
    output [7:0] seg_en,        // 8 个流水灯开关 
    output [7:0] seg_out0,      // 前 4 个流水灯输出
    output [7:0] seg_out1,       // 后 4 个流水灯输出


//测试输出
    output power_state,
    output reg [1:0] mode,
    output [1:0] manual_state,
    output manual_move_forward_signal,

    output front_detector,
    output back_detector,
    output left_detector,
    output right_detector

   
    );
wire reset;
assign  reset = ~rst_n;

// Global States
//wire power_state;//电源状态
// reg [1:0] mode;//驾驶模式,01为手动，10为半自动，11为全自动
// wire [1:0] manual_state;//手动驾驶中的not_starting,starting,moving状态

//各个模式的输出，绑定在simulate的输入
wire manual_turn_left_signal;
wire manual_turn_right_signal;
// wire manual_move_forward_signal;
wire manual_move_backward_signal;
wire manual_place_barrier_signal;
wire manual_destroy_barrier_signal;
wire semiauto_turn_left_signal;
wire semiauto_turn_right_signal;
wire semiauto_move_forward_signal;
wire semiauto_move_backward_signal;
wire semiauto_place_barrier_signal;
wire semiauto_destroy_barrier_signal;
wire auto_turn_left_signal;
wire auto_turn_right_signal;
wire auto_move_forward_signal;
wire auto_move_backward_signal;
wire auto_place_barrier_signal;
wire auto_destroy_barrier_signal;

// 最终传出的输出
reg turn_left_signal;
reg turn_right_signal;
reg move_forward_signal;
reg move_backward_signal;
reg place_barrier_signal;
reg destroy_barrier_signal;

// 经测试，detector在碰到墙时为1
// wire front_detector;
// wire back_detector;
// wire left_detector;
// wire right_detector;

// parameter On =1'b1,Off=1'b0 ;//弃用

// 将power_state由power_module接管
wire power_off_signal;
wire power_off_manual;

// mode selection
always @(posedge clk, posedge reset) begin
    if(reset) begin 
        mode <= 2'b00;
    end
    else begin 
        //认为开着车是可以换模式的
        // mode<=mode_selection;

        //开着车不能换模式
        case (mode) 
            2'b00: begin 
                if(mode_selection != 2'b00) begin 
                    mode <= mode_selection;
                end
            end
        endcase
    end
end

// output switcher
always @(posedge clk,posedge reset) begin
    if(reset) begin
        turn_left_signal <= 0;
        turn_right_signal <= 0;
        move_forward_signal <= 0;
        move_backward_signal <= 0;
        place_barrier_signal <= 0;
        destroy_barrier_signal <= 0;
    end
    else begin
        case(mode) 
            2'b01: begin
                turn_left_signal <= manual_turn_left_signal;
                turn_right_signal <= manual_turn_right_signal;
                move_backward_signal <= manual_move_backward_signal;
                move_forward_signal <= manual_move_forward_signal;
                place_barrier_signal <= 0;
                destroy_barrier_signal <= 0;
            end
            2'b10: begin
                turn_left_signal <= semiauto_turn_left_signal;
                turn_right_signal <= semiauto_turn_right_signal;
                move_backward_signal <= semiauto_move_backward_signal;
                move_forward_signal <= semiauto_move_forward_signal;
                place_barrier_signal <= 0;
                destroy_barrier_signal <= 0;
            end
            2'b11: begin 
                turn_left_signal <= auto_turn_left_signal;
                turn_right_signal <= auto_turn_right_signal;
                move_backward_signal <= auto_move_backward_signal;
                move_forward_signal <= auto_move_forward_signal;
                place_barrier_signal <= auto_place_barrier_signal;
                destroy_barrier_signal <= auto_destroy_barrier_signal;
            end
        endcase
    end
end


assign power_off_signal = power_off + power_off_manual; 
power_module u_power_module(.clk(clk), .power_on(power_on), .power_off(power_off_signal), .reset(reset), .power_state(power_state));

ManualDriving u_manualdriving(
.power_state(power_state),
.mode(mode),
.clk(clk),
.reset(reset),
.throttle(throttle),
.brake(brake),
.clutch(clutch),
.shift(reverse_gear),
.turn_left(turn_left),
.turn_right(turn_right),
.turn_left_signal(manual_turn_left_signal),
.turn_right_signal(manual_turn_right_signal),
.move_forward_signal(manual_move_forward_signal),
.move_backward_signal(manual_move_backward_signal),
.power_off_manual(power_off_manual),
.manual_state(manual_state)
);

// SemiAutoDriving u_semi_auto_driving(
//     .turn_left_Semi(turn_left),
//     .turn_right_Semi(turn_right),
//     .clk(clk),
//     .turn_left_signal(semiauto_turn_left_signal),
//     .turn_right_signal(semiauto_turn_right_signal),
//     .move_forward_signal(semiauto_move_forward_signal),
//     .move_backward_signal(semiauto_move_backward_signal),
//     .reset(reset),
//     .back_detector(back_detector),
//     .left_detector(left_detector),
//     .right_detector(right_detector),
//     .front_detector(front_detector)
// );

semi_auto u_semi_auto(
    .turn_left_semi(turn_left),
    .turn_right_semi(turn_right),
    .go_straight_semi(go_straight_semi),
    .clk(clk),
    .turn_left_signal(semiauto_turn_left_signal),
    .turn_right_signal(semiauto_turn_right_signal),
    .move_forward_signal(semiauto_move_forward_signal),
    .move_backward_signal(semiauto_move_backward_signal),
    .reset(reset),
    .back_detector(back_detector),
    .left_detector(left_detector),
    .right_detector(right_detector),
    .front_detector(front_detector)
);


AutoDriving u_auto_driving(
    .reset(reset),
    .clk(clk),
    .front_detector(front_detector),
    .back_detector(back_detector),
    .right_detector(right_detector),
    .left_detector(left_detector),
    .turn_left_signal(auto_turn_left_signal),
    .turn_right_signal(auto_turn_right_signal),
    .move_backward_signal(auto_move_backward_signal),
    .move_forward_signal(auto_move_forward_signal),
    .place_barrier_signal(auto_place_barrier_signal),
    .destroy_barrier_signal(auto_destroy_barrier_signal)
);

turn_light_module u_turn_light_module(
    .reset(reset),
    .clk(clk),
    .power_state(power_state),
    .mode(mode),
    .manual_state(manual_state),
    .turn_left_signal(turn_left_signal),
    .turn_right_signal(turn_right_signal),
    .left_led(turn_left_light),
    .right_led(turn_right_light)
);

//里程计

wire[23:0] record;
record_module u_record_module(
    .reset(reset),
    .clk(clk),
    .power_state(power_state),
    .mode(mode),
    .manual_state(manual_state),
    .turn_left_signal(turn_left_signal),
    .turn_right_signal(turn_right_signal),
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal),
    .record(record));

record_display u_record_display(
    .clk(clk),
    .reset(reset),
    .power_state(power_state),
    .record(record),
    .seg_en(seg_en),    
    .seg_out0(seg_out0),  
    .seg_out1(seg_out1));

SimulatedDevice simulate(
    .sys_clk(clk),
    .rx(rx),
    .tx(tx),

    .turn_left_signal(turn_left_signal),
    .turn_right_signal(turn_right_signal),
    .move_forward_signal(move_forward_signal),
    .move_backward_signal(move_backward_signal),
    .place_barrier_signal(place_barrier_signal),
    .destroy_barrier_signal(destroy_barrier_signal),
    .front_detector(front_detector),
    .back_detector(back_detector),
    .left_detector(left_detector),
    .right_detector(right_detector)
);


endmodule
