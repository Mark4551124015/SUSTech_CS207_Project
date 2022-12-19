`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mark455
// 
// Create Date: 2022/12/14 18:47:34
// Design Name: 
// Module Name: lighting_module
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

module lighting_module(
    input clk,
    input [4:0] state,
    input [3:0] switch_total,
    input [3:0] button_total,
    output power_state,           //µÁ‘¥◊¥Ã¨œ‘ æµ∆      LEDµ∆D1_0
    output [1:0] driving_mode,     //º› ªƒ£ Ωœ‘ æµ∆      LEDµ∆D1_1°¢D1_2
    output [1:0] car_state,        //∆˚≥µ◊¥Ã¨œ‘ æµ∆      LEDµ∆D1_3°¢D1_4
    output clutch_show,           //¿Î∫œœ‘ æµ∆         LEDµ∆D2_7
    output throttle_show,         //”Õ√≈œ‘ æµ∆         LEDµ∆D2_6
    output break_show,            //…≤≥µœ‘ æµ∆         LEDµ∆D2_5
    output reverse_show,          //µπµ≤œ‘ æµ∆         LEDµ∆D2_4
    output reg [1:0]  turning_show      //◊™œÚœ‘ æµ∆         LEDµ∆D1_5°¢LEDµ∆D1_6
);
    parameter power_off = 5'b0XXXX;
    parameter manual_non_staring  = 5'b11001;
    parameter manual_starting = 5'b11010;
    parameter manual_moving = 5'b11011;
    reg clutch,throttle,brake,reverse,leftButton,rightButton;
    
    assign power_state = state[4];
    assign driving_mode = state[3:2];
    assign car_state  = state[1:0];
    
    assign clutch_show = switch_total[3] & power_state;
    assign throttle_show = switch_total[2] & power_state;
    assign break_show = switch_total[1] & power_state;
    assign reverse_show = switch_total[0] & power_state;

    always@(posedge clk) begin
        clutch = switch_total[3];
        throttle = switch_total[2];
        brake = switch_total[1];
        reverse = switch_total[0];
        leftButton = button_total[1];
        rightButton = button_total[0];
        
        casex (state)
            
            
            manual_non_staring: 
            begin
                turning_show[0] <=1;
                turning_show[1] <=1;
            end
            
            manual_moving: 
            begin
                if (leftButton & ~rightButton) begin
                   turning_show[0]    = 1;
                   turning_show[1]    = 0;
                end
                else if (~leftButton & rightButton) begin
                    turning_show[0]   = 0;
                    turning_show[1]   = 1;
                end 
                else begin
                    turning_show[0] <=0;
                    turning_show[1] <=0;
                end
            end
           default:
            begin
                turning_show[0] <=0;
                turning_show[1] <=0;
            end
        endcase
    end
endmodule
