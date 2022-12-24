`timescale 1ns / 1ps

module vga_char_display(
    input clk,
    input rst,
    output reg [2:0] r,
    output reg [2:0] g,
    output reg [1:0] b,
    output hs,
    output vs
    );

	// 显示器可显示区域
	parameter UP_BOUND = 31;
	parameter DOWN_BOUND = 510;
	parameter LEFT_BOUND = 144;
	parameter RIGHT_BOUND = 783;

	// 显示字符左上角位置
	parameter up_pos = 267;
	parameter down_pos = 274;
	parameter left_pos = 457;
	parameter right_pos = 470;
	
	wire pclk;
	reg [1:0] count;
	reg [9:0] hcount, vcount;
	wire [7:0] p[34:0];

	wire [5:0] n0;
	wire [5:0] n1;
	wire [5:0] n2;
	wire [5:0] n3;
	wire [5:0] n4;
	// wire [5:0] n5;
	// wire [5:0] n6;
	vga_ram_module number_0 (
		.clk(clk),
		.rst(rst),
		.data(6'b00_0011),
		.col0(p[0]),
		.col1(p[1]),
		.col2(p[2]),
		.col3(p[3]),
		.col4(p[4]),
		.col5(p[5]),
		.col6(p[6])
	);
	// vga_ram_module number_1 (
	// 	.clk(clk),
	// 	.rst(rst),
	// 	.data(6'b00_1101),
	// 	.col0(p[7]),
	// 	.col1(p[8]),
	// 	.col2(p[9]),
	// 	.col3(p[10]),
	// 	.col4(p[11]),
	// 	.col5(p[12]),
	// 	.col6(p[13])
	// );
	// vga_ram_module number_2 (
	// 	.clk(clk),
	// 	.rst(rst),
	// 	.data(6'b00_0011),
	// 	.col0(p[0]),
	// 	.col1(p[1]),
	// 	.col2(p[2]),
	// 	.col3(p[3]),
	// 	.col4(p[4]),
	// 	.col5(p[5]),
	// 	.col6(p[6])
	// );
	// vga_ram_module number_3 (
	// 	.clk(clk),
	// 	.rst(rst),
	// 	.data(6'b00_1101),
	// 	.col0(p[7]),
	// 	.col1(p[8]),
	// 	.col2(p[9]),
	// 	.col3(p[10]),
	// 	.col4(p[11]),
	// 	.col5(p[12]),
	// 	.col6(p[13])
	// );	
	// vga_ram_module number_4 (
	// 	.clk(clk),
	// 	.rst(rst),
	// 	.data(6'b00_0011),
	// 	.col0(p[0]),
	// 	.col1(p[1]),
	// 	.col2(p[2]),
	// 	.col3(p[3]),
	// 	.col4(p[4]),
	// 	.col5(p[5]),
	// 	.col6(p[6])
	// );
	// vga_ram_module number_5 (
	// 	.clk(clk),
	// 	.rst(rst),
	// 	.data(6'b00_1101),
	// 	.col0(p[7]),
	// 	.col1(p[8]),
	// 	.col2(p[9]),
	// 	.col3(p[10]),
	// 	.col4(p[11]),
	// 	.col5(p[12]),
	// 	.col6(p[13])
	// );
	// vga_ram_module number_6 (
	// 	.clk(clk),
	// 	.rst(rst),
	// 	.data(6'b00_1101),
	// 	.col0(p[7]),
	// 	.col1(p[8]),
	// 	.col2(p[9]),
	// 	.col3(p[10]),
	// 	.col4(p[11]),
	// 	.col5(p[12]),
	// 	.col6(p[13])
	// );

	// 获得像素时钟25MHz
	assign pclk = count[1];
	always @ (posedge clk or posedge rst)
	begin
		if (rst)
			count <= 0;
		else
			count <= count+1;
	end
	
	// 列计数与行同步
	assign hs = (hcount < 96) ? 0 : 1;
	always @ (posedge pclk or posedge rst)
	begin
		if (rst)
			hcount <= 0;
		else if (hcount == 799)
			hcount <= 0;
		else
			hcount <= hcount+1;
	end
	
	// 行计数与场同步
	assign vs = (vcount < 2) ? 0 : 1;
	always @ (posedge pclk or posedge rst)
	begin
		if (rst)
			vcount <= 0;
		else if (hcount == 799) begin
			if (vcount == 520)
				vcount <= 0;
			else
				vcount <= vcount+1;
		end
		else
			vcount <= vcount;
	end
	
	// 设置显示信号值
	always @ (posedge pclk or posedge rst)
	begin
		if (rst) begin
			r <= 0;
			g <= 0;
			b <= 0;
		end
		else if (vcount>=UP_BOUND && vcount<=DOWN_BOUND
				&& hcount>=LEFT_BOUND && hcount<=RIGHT_BOUND) begin
			if (vcount>=up_pos && vcount<=down_pos
					&& hcount>=left_pos && hcount<=right_pos) begin
				if (p[hcount-left_pos][vcount-up_pos]) begin
					r <= 3'b111;
					g <= 3'b111;
					b <= 2'b11;
				end
				else begin
					r <= 3'b000;
					g <= 3'b000;
					b <= 2'b00;
				end
			end
			else begin
				r <= 3'b000;
				g <= 3'b000;
				b <= 2'b00;
			end
		end
		else begin
			r <= 3'b000;
			g <= 3'b000;
			b <= 2'b00;
		end
	end

endmodule
 

 
