`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/24 13:10:37
// Design Name: 
// Module Name: vga_num_ram
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


module vga_num_ram(
	input clk,
	input rst,
	input [5:0] data,
	output reg [7:0] col0,
	output reg [7:0] col1,
	output reg [7:0] col2,
	output reg [7:0] col3,
	output reg [7:0] col4,
	output reg [7:0] col5,
	output reg [7:0] col6
    );
    always @(posedge clk or negedge rst)
		begin
			if (!rst)
				begin
					col0 <= 8'b0000_0000;
					col1 <= 8'b0000_0000;
					col2 <= 8'b0000_0000;
					col3 <= 8'b0000_0000;
					col4 <= 8'b0000_0000;
					col5 <= 8'b0000_0000;
					col6 <= 8'b0000_0000;
				end
			else
				begin
					case (data)
                    6'b00_0000: // "0"
							begin
								col0 <= 8'b0000_0000;
								col1 <= 8'b0011_1110;
								col2 <= 8'b0101_0001;
								col3 <= 8'b0100_1001;
								col4 <= 8'b0100_0101;
								col5 <= 8'b0011_1110;
								col6 <= 8'b0000_0000;
							end
						6'b00_0001: // "1"
							begin
								col0 <= 8'b0000_0000;
								col1 <= 8'b0000_0000;
								col2 <= 8'b0100_0010;
								col3 <= 8'b0111_1111;
								col4 <= 8'b0100_0000;
								col5 <= 8'b0000_0000;
								col6 <= 8'b0000_0000;
							end
						6'b00_0010: // "2"
							begin
								col0 <= 8'b0000_0000;
								col1 <= 8'b0100_0010;
								col2 <= 8'b0110_0001;
								col3 <= 8'b0101_0001;
								col4 <= 8'b0100_1001;
								col5 <= 8'b0100_0110;
								col6 <= 8'b0000_0000;
							end
						6'b00_0011: // "3"
							begin
								col0 <= 8'b0000_0000;
								col1 <= 8'b0010_0010;
								col2 <= 8'b0100_0001;
								col3 <= 8'b0100_1001;
								col4 <= 8'b0100_1001;
								col5 <= 8'b0011_0110;
								col6 <= 8'b0000_0000;
							end
						6'b00_0100: // "4"
							begin
								col0 <= 8'b0000_0000;
								col1 <= 8'b0001_1000;
								col2 <= 8'b0001_0100;
								col3 <= 8'b0001_0010;
								col4 <= 8'b0111_1111;
								col5 <= 8'b0001_0000;
								col6 <= 8'b0000_0000;
							end
						6'b00_0101: // "5"
							begin
								col0 <= 8'b0000_0000;
								col1 <= 8'b0010_0111;
								col2 <= 8'b0100_0101;
								col3 <= 8'b0100_0101;
								col4 <= 8'b0100_0101;
								col5 <= 8'b0011_1001;
								col6 <= 8'b0000_0000;
							end
						6'b00_0110: // "6"
							begin
								col0 <= 8'b0000_0000;
								col1 <= 8'b0011_1110;
								col2 <= 8'b0100_1001;
								col3 <= 8'b0100_1001;
								col4 <= 8'b0100_1001;
								col5 <= 8'b0011_0010;
								col6 <= 8'b0000_0000;
							end
						6'b00_0111: // "7"
							begin
								col0 <= 8'b0000_0000;
								col1 <= 8'b0110_0001;
								col2 <= 8'b0001_0001;
								col3 <= 8'b0000_1001;
								col4 <= 8'b0000_0101;
								col5 <= 8'b0000_0011;
								col6 <= 8'b0000_0000;
							end
						6'b00_1000: // "8"
							begin
								col0 <= 8'b0000_0000;
								col1 <= 8'b0011_0110;
								col2 <= 8'b0100_1001;
								col3 <= 8'b0100_1001;
								col4 <= 8'b0100_1001;
								col5 <= 8'b0011_0110;
								col6 <= 8'b0000_0000;
							end
						6'b00_1001: // "9"
							begin
								col0 <= 8'b0000_0000;
								col1 <= 8'b0010_0110;
								col2 <= 8'b0100_1001;
								col3 <= 8'b0100_1001;
								col4 <= 8'b0100_1001;
								col5 <= 8'b0011_1110;
								col6 <= 8'b0000_0000;
							end

					endcase
				end
		end
endmodule
						