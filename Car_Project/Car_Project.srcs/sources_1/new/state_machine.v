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


module state_machine (
    input            clk,           // 100MHz system cloc
    input            mode,          // Driving mode selection signal
    input      [3:0] switch_total,  // Total switch inputs
    input      [5:0] button_total,  // Total button inputs
    input      [3:0] detector,      // Detector signals
    output reg [4:0] state,         // Car state
    output reg       stay           // Hold on to not move
);
  wire clutch, throttle, brake, reverse;
  wire power_off_click;
  wire front_click, back_click, left_click, right_click;
  wire power;
  reg [31:0] init;

  wire clk_100hz;
  reg last_reverse;

  reg [31:0] turn_cnt;
  reg [31:0] rest;
  reg [31:0] cool;
  reg [31:0] forward_cnt;

  wire front_d = detector[3];
  wire back_d = detector[2];
  wire left_d = detector[1];
  wire right_d = detector[0];
  wire mode_click;
  parameter
  rest_state = 5'b00000,
  power_off = 5'b0XXXX,   //关机状态 该状态下除检测到的电源按钮输入外的所有检测到的输入无效
  manual = 5'b110XX,
        manual_non_starting = 5'b11001,   //开机默认模式 手动驾驶模式未启动状态为默认状态 开机&手动&non-starting
  manual_starting = 5'b11010,  //开机&手动&starting
  manual_moving = 5'b11011,  //开机&手动&moving
  semi = 5'b101XX, semi_waiting = 5'b10100,  //开机 半自动waiting
  semi_turning_left = 5'b10101,  //开机 半自动左转
  semi_turning_right = 5'b10110,  //开机 半自动右转
  semi_moving_forward = 5'b10111,  //开机 半自动直行
  auto = 5'b111XX, auto_init = 5'b11100,

  //time count
  start_sec = 32'd100_000_000, turn_sec = 32'd85_000_000,  //转90度时间
  turn_back_sec = 32'd180_000_000,  //转180度时间
  forward_sec = 32'd80_000_000,  //前进走出路口时间
  cool_sec = 32'd20_000_000,  //完成转向后回正时间
  rest_sec = 32'd6_000_000;  //detector延迟

  assign clutch = switch_total[3];
  assign throttle = switch_total[2];
  assign brake = switch_total[1];
  assign reverse = switch_total[0];
  reg isCross, needLeft, needRight, needBack;

  click_detector on_power_off_click (
      .clk(clk),
      .button(button_total[3]),
      .button_click(power_off_click)
  );
  click_detector on_front_click (
      .clk(clk),
      .button(button_total[2]),
      .button_click(front_click)
  );
  click_detector on_left_click (
      .clk(clk),
      .button(button_total[1]),
      .button_click(left_click)
  );
  click_detector on_right_click (
      .clk(clk),
      .button(button_total[0]),
      .button_click(right_click)
  );
  click_detector on_mode_click (
      .clk(clk),
      .button(mode),
      .button_click(mode_click)
  );
  click_detector on_back_click (
      .clk(clk),
      .button(button_total[5]),
      .button_click(back_click)
  );
  assign power = button_total[4];
  
    always @(posedge clk) begin
      casex (detector)
        4'b0X00, 4'b0X10, 4'b0X01, 4'b1X00: begin
          isCross   = 1;
          needLeft  = 0;
          needRight = 0;
          needBack  = 0;
        end
        4'b1X01: begin
          isCross   = 0;
          needLeft  = 1;
          needRight = 0;
          needBack  = 0;
    
        end
        4'b1X10: begin
          isCross   = 0;
          needLeft  = 0;
          needRight = 1;
          needBack  = 0;
        end
        4'b1011: begin
          isCross   = 0;
          needLeft  = 0;
          needRight = 0;
          needBack  = 1;
        end
        default: begin
          isCross   = 0;
          needLeft  = 0;
          needRight = 0;
          needBack  = 0;
        end
      endcase
    end
  always @(posedge clk) begin
    if (power_off_click) begin
      state = rest_state;
      last_reverse = 0;
    end else begin
      casex (state)
        power_off: begin
          if (power) begin
            if (init == start_sec) begin
              state = manual_non_starting;
              init  = 0;
            end else begin
              init = init + 1;
            end
          end else begin
            state = state;
            init  = 0;
          end
        end
        //----------------------------------------------------
        manual_non_starting: begin
          if (mode_click) begin
            state = semi_waiting;
          end else if (~clutch & ((throttle & ~brake) | (last_reverse != reverse))) begin
            state = rest_state;
            last_reverse = 0;
          end else if (clutch & (last_reverse != reverse)) begin
            last_reverse = reverse;
          end else if (clutch & throttle & ~brake) begin
            state = manual_starting;
          end else begin
            state = manual_non_starting;
          end
        end
        //----------------------------------------------------
        manual_starting: begin
          if (mode_click) begin
            state = semi_waiting;
          end else if (~clutch & (last_reverse != reverse)) begin
            state = rest_state;
            last_reverse = 0;

          end else if (clutch & (last_reverse != reverse)) begin
            last_reverse = reverse;
          end else if (brake) begin
            state = manual_non_starting;
          end else if (~clutch & throttle & ~brake) begin
            state = manual_moving;
          end else begin
            state = manual_starting;
          end
        end
        //----------------------------------------------------
        manual_moving: begin
          if (mode_click) begin
            state = semi_waiting;
          end else if (~clutch & (last_reverse != reverse)) begin
            state = rest_state;
            last_reverse = 0;
          end else if (brake) begin
            state = manual_non_starting;
          end else if (clutch | ~throttle) begin
            state = manual_starting;
          end else begin
            state = manual_moving;
          end
        end
        //----------------------------------------------------
        //----------------------------------------------------
        //----------------------------------------------------                 
        semi_waiting: begin
          if (mode_click) begin
            state = auto_init;
          end else if (front_click) begin
            cool = cool_sec;
            forward_cnt = forward_sec;
            state = semi_moving_forward;
          end else if (left_click) begin
            cool = cool_sec;
            turn_cnt = turn_sec;
            state = semi_turning_left;
          end else if (right_click) begin
            cool = cool_sec;
            turn_cnt = turn_sec;
            state = semi_turning_right;
          end else if (back_click) begin
            cool = cool_sec;
            turn_cnt = turn_back_sec;
            state = semi_turning_right;
          end else begin
            state = semi_waiting;
          end
        end
        //----------------------------------------------------
        semi_moving_forward: begin
          if (forward_cnt > 0) begin
            forward_cnt = forward_cnt - 1;
            rest = rest_sec;
            stay = 0;
          end else begin
            stay = 0;
            if (isCross | needLeft | needRight | needBack) begin
              if (rest > 0) begin
                rest = rest - 1;
                stay = 1;
              end else begin
                if (isCross) begin
                  state = semi_waiting;
                end else if (needLeft) begin
                  cool = cool_sec;
                  turn_cnt = turn_sec;
                  state = semi_turning_left;
                end else if (needRight) begin
                  cool = cool_sec;
                  turn_cnt = turn_sec;
                  state = semi_turning_right;
                end else if (needBack) begin
                  cool = cool_sec;
                  turn_cnt = turn_back_sec;
                  state = semi_turning_right;
                end else begin
                  state = semi_moving_forward;
                end
              end
            end
          end
        end
        //----------------------------------------------------
        semi_turning_left: begin
          if (turn_cnt > 0) begin
            stay = 0;
            turn_cnt = turn_cnt - 1;
            state = semi_turning_left;
          end else begin
            if (cool > 0) begin
              cool = cool - 1;
              stay = 1;
            end else begin
              forward_cnt = forward_sec;
              state = semi_moving_forward;
            end
          end
        end
        //----------------------------------------------------
        semi_turning_right: begin
          if (turn_cnt > 0) begin
            stay = 0;
            turn_cnt = turn_cnt - 1;
            state = semi_turning_right;
          end else begin
            if (cool > 0) begin
              cool = cool - 1;
              stay = 1;
            end else begin
              forward_cnt = forward_sec;
              state = semi_moving_forward;
            end
          end
        end
        //----------------------------------------------------
        //----------------------------------------------------
        //----------------------------------------------------
        auto: begin
          state = state;
          if (mode_click) begin
            state = manual_non_starting;
          end
        end
        default: begin
          init  = init;
          state = state;
        end
      endcase  //其他情况不变
    end
  end
endmodule
