`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/24 15:28:18
// Design Name: 
// Module Name: auto_module
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


module auto_module(
    input clk,  // 100MHz system clock
    input enable, // The signal of whether to enable automatic driving mode
    input [3:0] detector, // Detector data
    output reg placeBarrier, // Place beacon
    output reg destroyBarrier, // Destroy beacon
    output [3:0] auto_move, // Move signal outputs in automatic mode
    output [4:0] auto_state_out // Showing for debuging
);
    reg moveForward;
    reg moveBack;
    reg turnRight;
    reg turnLeft;
    assign auto_move = {moveForward, moveBack, turnLeft, turnRight};    //debug输出auto姿态
    reg [51:0] time_limit;  
    reg [31:0] placeB_cnt;  
    reg [31:0] turn_cnt;    //转弯时间
    reg [8:0] counter = 1;

    //检测有无墙
    wire front_d = detector[3];
    wire back_d = detector[2];
    wire left_d = detector[1];
    wire right_d = detector[0];

    wire clk_50hz;
    reg last_enable;

    reg isCross,needLeft,needRight,needBack;
    clk_module #(.frequency(50)) clk_divider(
        .clk(clk),
        .enable(enable),
        .clk_out(clk_50hz)
    );
    parameter
        auto_rest = 5'b00001,
        auto_forward = 5'b00000,
        auto_turn_left = 5'b00010,
        auto_turn_right = 5'b00011,
        auto_turn_back = 5'b00100,
        auto_placeB = 5'b00101,
        auto = 5'b111XX,

        turn_sec = 32'd85_000_000,          //转90度时间
        turn_back_sec = 32'd180_000_000,    //转180度时间
        forward_sec = 32'd50_000_000,       //前进走出路口时间
        cool_sec = 32'd10_000_000,          //完成转向后回正时间
        rest_sec = 32'd5_000_000,           //detector延迟

        place_Barrier_sec = 32'd250_000_000,    
        place_Barrier_sec_half = 32'd85_000_000,

        buffer_sec = 32'd2_100_000,                 //放路标所需持续时间
        max_right = 5'd5,                           //改成depth
        destroy_timelimit = 33'd6_000_000_000;

    reg [4:0] auto_state; 
    reg [5:0] lastState;                            
    reg [31:0] rest;        
    reg [31:0] cool;
    reg [31:0] forward_cnt;
    reg [31:0] buffer;

    reg needBarrier;
    assign auto_state_out = {isCross, isCross, needLeft, needRight, needBack};   //debug

    always @(posedge clk_50hz) begin
        casex(detector)
            4'bXX00:            //left & right      
            begin
                isCross = ~detector[2];
                needLeft = 0;
                needRight = 1;
                needBack = 0;
            end
            4'b0X01:            //left & front
            begin
                isCross = ~detector[2];
                needLeft = 0;
                needRight = 0;
                needBack = 0;
            end
            4'b0X10:            //right & front
            begin
                isCross = ~detector[2];
                needLeft = 0;
                needRight = 1;
                needBack = 0;
            end
            4'b1X01:            //left
            begin
                isCross=0;
                needLeft = 1;
                needRight = 0;
                needBack = 0;
            end
            4'b1X10:            //right
            begin
                isCross   = 0;
                needLeft = 0;
                needRight = 1;
                needBack = 0;
            end
            4'b1X11:            //back
            begin
                isCross   = 0;
                needLeft = 0;
                needRight = 0;
                needBack = 1;
            end
            default:
            begin
                isCross   = 0;
                needLeft = 0;
                needRight = 0;
                needBack = 0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (enable & ~last_enable) begin
            auto_state <= auto_forward;
        end
        else begin
            last_enable = 1;
        end
        if (enable) begin
            case (auto_state)
                auto_forward:begin
                    moveForward <= 1;
                    moveBack <= 0;
                    turnLeft <= 0;
                    turnRight <= 0;
                    if (forward_cnt > 1) begin
                        forward_cnt <= forward_cnt - 1;
                        moveForward <= 1;
                        moveBack <= 0;
                        turnLeft <= 0;
                        turnRight <= 0;
                        rest <= rest_sec;
                    end
                    else if (forward_cnt == 1) begin
                        forward_cnt <= forward_cnt - 1;
                        moveForward <= 1;
                        moveBack <= 0;
                        turnLeft <= 0;
                        turnRight <= 0;
                        rest <= rest_sec;
                        if (needBarrier) begin
                            buffer <= buffer_sec;
                            placeBarrier <= 1;
                        end
                    end
                    else if (isCross | needLeft | needRight | needBack) begin
                            cool <= cool_sec;
                            if (rest > 0) begin
                                rest <= rest - 1;
                                moveForward <= 0;
                                moveBack <= 0;
                                turnLeft <= 0;
                                turnRight <= 0;
                            end
                            else begin
                                if (~isCross)begin                      // 非路口直接转向 Turn directly if not Cross
                                    if (needLeft) begin
                                        turn_cnt <= turn_sec;
                                        auto_state <= auto_turn_left;
                                        moveForward <= 0;
                                        moveBack <= 0;
                                        turnLeft <= 0;
                                        turnRight <= 0;
                                    end
                                    else if (needRight) begin
                                        turn_cnt <= turn_sec;
                                        auto_state <= auto_turn_right;
                                        moveForward <= 0;
                                        moveBack <= 0;
                                        turnLeft <= 0;
                                        turnRight <= 0;
                                    end
                                    else if (needBack) begin
                                        turn_cnt <= turn_back_sec;
                                        auto_state <= auto_turn_right;
                                        moveForward <= 0;
                                        moveBack <= 0;
                                        turnLeft <= 0;
                                        turnRight <= 0;
                                    end
                                end
                                else begin                              // 路口给走的方向放信标 Turn after place the barrier
                                    if (needLeft) begin
                                        turn_cnt <= turn_sec;
                                        auto_state <= auto_turn_left;
                                        moveForward <= 0;
                                        moveBack <= 0;
                                        turnLeft <= 0;
                                        turnRight <= 0;
                                        needBarrier <= 1;
                                    end
                                    else if (needRight) begin
                                        turn_cnt <= turn_sec;
                                        auto_state <= auto_turn_right;
                                        moveForward <= 0;
                                        moveBack <= 0;
                                        turnLeft <= 0;
                                        turnRight <= 0;
                                        needBarrier <= 1;
                                    end
                                    else begin
                                        auto_state <= auto_forward;
                                        moveForward <= 0;
                                        moveBack <= 0;
                                        turnLeft <= 0;
                                        turnRight <= 0;
                                        forward_cnt <= forward_sec;
                                        needBarrier <= 1;
                                    end
                                end
                            end
                    end
                    else begin
                        moveForward <= 1;
                        moveBack <= 0;
                        turnLeft <= 0;
                        turnRight <= 0;
                        turn_cnt <= turn_cnt;
                        rest <= rest_sec;
                    end
                end
                auto_turn_left: begin
                    if (turn_cnt > 0) begin
                        moveForward <= 0;
                        moveBack <= 0;
                        turnLeft <= 1;
                        turnRight <= 0;
                        turn_cnt <= turn_cnt - 1;
                        auto_state <= auto_turn_left;
                    end
                    else begin
                        if (cool > 0) begin
                            cool <= cool - 1;
                            moveForward <= 0;
                            moveBack <= 0;
                            turnLeft <= 0;
                            turnRight <= 0;
                            auto_state <= auto_turn_left;
                        end 
                        else begin
                            forward_cnt <= forward_sec;
                            auto_state <= auto_forward;
                        end
                    end
                end
                auto_turn_right: begin
                    if (turn_cnt > 0) begin
                        moveForward <= 0;
                        moveBack <= 0;
                        turnLeft <= 0;
                        turnRight <= 1;
                        turn_cnt <= turn_cnt - 1;
                        auto_state <= auto_turn_right;
                    end
                    else begin
                        if (cool > 0) begin
                            cool <= cool - 1;
                            moveForward <= 0;
                            moveBack <= 0;
                            turnLeft <= 0;
                            turnRight <= 0;
                            auto_state <= auto_turn_right;
                        end 
                        else begin
                            forward_cnt <= forward_sec;
                            auto_state <= auto_forward;
                        end
                    end 
                end
                default:
                begin
                    auto_state <= auto_state;
                    placeB_cnt <= placeB_cnt;
                    turn_cnt <= turn_cnt;
                    moveForward <= moveForward;
                    moveBack <= moveBack;
                    turnLeft <= turnLeft;
                    turnRight <= turnRight;
                end
            endcase


            // if (isCross) begin
            //     destroyCnt = destroy_timelimit;
            // end
            // else if (destroyCnt > 0) begin
            //     destroyCnt = destroyCnt -1;
            // end
            // else begin
            //     destroyBarrier = 1;
            //     buffer = buffer_sec;
            //     destroyCnt = destroy_timelimit;
            // end

            if (buffer>0) begin 
                placeBarrier <= placeBarrier;
                destroyBarrier <= destroyBarrier;
                buffer <= buffer - 1;
            end
            else begin
                placeBarrier <= 0;
                destroyBarrier <= 0;
            end
        end
    end

    
endmodule
