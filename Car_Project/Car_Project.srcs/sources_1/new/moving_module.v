`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mark455
// 
// Create Date: 2022/12/14 18:47:34
// Design Name: clock module
// Module Name: clk_module
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
// inputs: 
//      clk -------     System clock
//      reset -----     Reset
// outputs:
//      clk_out ---     clk generate by clk module 
//
//////////////////////////////////////////////////////////////////////////////////

module moving_module (
    input clk,  // 100MHz system clock
    input [4:0] state,  // Car state
    input [3:0] switch_total,  // Total switch inputs
    input [5:0] button_total,  // Total button inputs
    input [3:0] auto_move,  // Move signal outputs in automatic mode
    input stay,  // Driving signal in semi-automatic mode
    output reg move_forward_signal,  // Move forward signal
    output reg move_backward_signal,  // Move backward signal
    output reg turn_left_signal,  // Turn left signal
    output reg turn_right_signal  // Turn right signal
);
  parameter
        rest = 5'b00000,
        power_off = 5'b0XXXX,   //关机状态 该状态下除检测到的电源按钮输入外的所有检测到的输入无效
  manual = 5'b110XX,
        manual_non_starting = 5'b11001,   //开机默认模式 手动驾驶模式未启动状态为默认状态 开机&手动&non-starting
  manual_starting = 5'b11010,  //开机&手动&starting
  manual_moving = 5'b11011,  //开机&手动&moving
  semi = 5'b101XX, semi_waiting = 5'b10100,  //开机 半自动waiting
  semi_turning_left = 5'b10101,  //开机 半自动左转
  semi_turning_right = 5'b10110,  //开机 半自动右转
  semi_moving_forward = 5'b10111,  //开机 半自动直行
  auto = 5'b111XX;

  wire clutch, throttle, brake, reverse, leftButton, rightButton;
  assign clutch = switch_total[3];
  assign throttle = switch_total[2];
  assign brake = switch_total[1];
  assign reverse = switch_total[0];
  assign leftButton = button_total[1];
  assign rightButton = button_total[0];

  always @(posedge clk) begin
    casex (state)
      manual_starting: begin
        if (leftButton & ~rightButton) begin
          turn_left_signal  = 1;
          turn_right_signal = 0;
        end else if (~leftButton & rightButton) begin
          turn_left_signal  = 0;
          turn_right_signal = 1;
        end else begin
          turn_left_signal  = 0;
          turn_right_signal = 0;
        end
        move_forward_signal  = 0;
        move_backward_signal = 0;
      end
      manual_moving: begin
        if (throttle & ~reverse) begin
          move_forward_signal  = 1;
          move_backward_signal = 0;
        end else if (throttle & reverse) begin
          move_forward_signal  = 0;
          move_backward_signal = 1;
        end else begin
          move_forward_signal  = 0;
          move_backward_signal = 0;
        end
        if (leftButton & ~rightButton) begin
          turn_left_signal  = 1;
          turn_right_signal = 0;
        end else if (~leftButton & rightButton) begin
          turn_left_signal  = 0;
          turn_right_signal = 1;
        end else begin
          turn_left_signal  = 0;
          turn_right_signal = 0;
        end
      end


      semi_moving_forward: begin
        if (~stay) begin
          move_forward_signal  = 1;
          move_backward_signal = 0;
          turn_left_signal     = 0;
          turn_right_signal    = 0;
        end else begin
          move_forward_signal  = 0;
          move_backward_signal = 0;
          turn_left_signal     = 0;
          turn_right_signal    = 0;
        end
      end
      semi_turning_left: begin
        if (~stay) begin
          move_forward_signal  = 0;
          move_backward_signal = 0;
          turn_left_signal     = 1;
          turn_right_signal    = 0;
        end else begin
          move_forward_signal  = 0;
          move_backward_signal = 0;
          turn_left_signal     = 0;
          turn_right_signal    = 0;
        end
      end
      semi_turning_right: begin
        if (~stay) begin
          move_forward_signal  = 0;
          move_backward_signal = 0;
          turn_left_signal     = 0;
          turn_right_signal    = 1;
        end else begin
          move_forward_signal  = 0;
          move_backward_signal = 0;
          turn_left_signal     = 0;
          turn_right_signal    = 0;
        end
      end

      auto: begin
        casex (auto_move)
          4'b1000: begin
            move_forward_signal  = 1;
            move_backward_signal = 0;
            turn_left_signal     = 0;
            turn_right_signal    = 0;
          end
          4'b0100: begin
            move_forward_signal  = 0;
            move_backward_signal = 1;
            turn_left_signal     = 0;
            turn_right_signal    = 0;
          end
          4'b0010: begin
            move_forward_signal  = 0;
            move_backward_signal = 0;
            turn_left_signal     = 1;
            turn_right_signal    = 0;
          end
          4'b0001: begin
            move_forward_signal  = 0;
            move_backward_signal = 0;
            turn_left_signal     = 0;
            turn_right_signal    = 1;
          end
          default: begin
            move_forward_signal  = 0;
            move_backward_signal = 0;
            turn_left_signal     = 0;
            turn_right_signal    = 0;
          end
        endcase
      end
      default: begin
        move_forward_signal  = 0;
        move_backward_signal = 0;
        turn_left_signal     = 0;
        turn_right_signal    = 0;
      end
    endcase
  end

endmodule



