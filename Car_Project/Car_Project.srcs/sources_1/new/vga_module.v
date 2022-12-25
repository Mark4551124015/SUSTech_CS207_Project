`timescale 1ns / 1ps

module vga_module(
    input clk,
    input rst,
	input [4:0] state,
	input [23:0] record,

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

	// 显示字符左上角位�?
	parameter up_pos = 267;
	parameter down_pos = 274;
	parameter left_pos = 415;
	parameter right_pos = 512;

	wire pclk;
	reg [1:0] count;
	reg [9:0] hcount, vcount;
	wire [7:0] p[97:0];
	reg [3:0] num0, num1, num2, num3, num4, num5, num6;
	reg [5:0] let0,let1,let2,let3,let4;

	parameter power_off = 5'b0XXXX;
    parameter manual_non_staring  = 5'b11001;
    parameter manual_starting = 5'b11010;
    parameter manual_moving = 5'b11011;
	parameter semi = 5'b101XX;
	parameter auto = 5'b111XX;

	parameter 
		A = 6'b00_1010,
		E = 6'b00_1110,
		F = 6'b00_1111,
		I = 6'b01_0010,
		M = 6'b01_0110,
		N = 6'b01_0111,
		O = 6'b01_1000,
		P = 6'b01_1001,
		R = 6'b01_1011,
		S = 6'b01_1100,
		T = 6'b01_1101,
		U = 6'b01_1110,
		V = 6'b01_1111,
		W = 6'b10_0000;
 
	always@(posedge clk) begin
        casex (state)
			manual_non_staring: 
            begin
                let0 = N;
				let1 = O;
				let2 = N;
				let3 = S;
				let4 = T;
            end
            //----------------------------------------------------
			manual_starting: 
            begin
               	let0 = S;
				let1 = T;
				let2 = A;
				let3 = R;
				let4 = T;
            end
            //----------------------------------------------------
            manual_moving: 
            begin
                let0 = M;
				let1 = O;
				let2 = V;
				let3 = I;
				let4 = N;
            end
            //----------------------------------------------------
            semi: 
            begin
                let0 = S;
				let1 = E;
				let2 = M;
				let3 = I;
				let4 = 6'b00_0000;
            end
            //----------------------------------------------------
            auto: 
            begin
                let0 = A;
				let1 = U;
				let2 = T;
				let3 = O;
				let4 = 6'b00_0000;
            end
            //----------------------------------------------------
            default:
            begin
               	let0 = P;
				let1 = W;
				let2 = O;
				let3 = F;
				let4 = F;
            end
        endcase
    end

vga_let_ram_module letter_0(
	.clk(clk),
	.rst(rst),
	.data(let0),
	.col0(p[0]),
	.col1(p[1]),
	.col2(p[2]),
	.col3(p[3]),
	.col4(p[4]),
	.col5(p[5]),
	.col6(p[6])
);
vga_let_ram_module letter_1(
	.clk(clk),
	.rst(rst),
	.data(let1),
	.col0(p[7]),
	.col1(p[8]),
	.col2(p[9]),
	.col3(p[10]),
	.col4(p[11]),
	.col5(p[12]),
	.col6(p[13])
);
vga_let_ram_module letter_2(
	.clk(clk),
	.rst(rst),
	.data(let2),
	.col0(p[14]),
	.col1(p[15]),
	.col2(p[16]),
	.col3(p[17]),
	.col4(p[18]),
	.col5(p[19]),
	.col6(p[20])
);
vga_let_ram_module letter_3(
	.clk(clk),
	.rst(rst),
	.data(let3),
	.col0(p[21]),
	.col1(p[22]),
	.col2(p[23]),
	.col3(p[24]),
	.col4(p[25]),
	.col5(p[26]),
	.col6(p[27])
);
vga_let_ram_module letter_4(
	.clk(clk),
	.rst(rst),
	.data(let4),
	.col0(p[28]),
	.col1(p[29]),
	.col2(p[30]),
	.col3(p[31]),
	.col4(p[32]),
	.col5(p[33]),
	.col6(p[34])
);

	always@(posedge clk) begin
        if (rst) begin
            num0  <= 0;
            num1  <= 0;
            num2  <= 0;
            num3  <= 0;
            num4  <= 0;
            num5  <= 0;
            num6  <= 0;
        end
        else begin
            num6 <= record/1_000_000%10;
            num5 <= record/1_000_00%10;
            num4 <= record/1_000_0%10;
            num3 <= record/1_000%10;
            num2 <= record/1_00%10;
            num1 <= record/1_0%10;
            num0 <= record%10;
        end
	end

vga_num_ram_module number_6(
	.clk(clk),
	.rst(rst),
	.data(num6),
	.col0(p[49]),
	.col1(p[50]),
	.col2(p[51]),
	.col3(p[52]),
	.col4(p[53]),
	.col5(p[54]),
	.col6(p[55])
);
vga_num_ram_module number_5(
	.clk(clk),
	.rst(rst),
	.data(num5),
	.col0(p[56]),
	.col1(p[57]),
	.col2(p[58]),
	.col3(p[59]),
	.col4(p[60]),
	.col5(p[61]),
	.col6(p[62])
);
vga_num_ram_module number_4(
	.clk(clk),
	.rst(rst),
	.data(num4),
	.col0(p[63]),
	.col1(p[64]),
	.col2(p[65]),
	.col3(p[66]),
	.col4(p[67]),
	.col5(p[68]),
	.col6(p[69])
);
vga_num_ram_module number_3(
	.clk(clk),
	.rst(rst),
	.data(num3),
	.col0(p[70]),
	.col1(p[71]),
	.col2(p[72]),
	.col3(p[73]),
	.col4(p[74]),
	.col5(p[75]),
	.col6(p[76])
);
vga_num_ram_module number_2(
	.clk(clk),
	.rst(rst),
	.data(num2),
	.col0(p[77]),
	.col1(p[78]),
	.col2(p[79]),
	.col3(p[80]),
	.col4(p[81]),
	.col5(p[82]),
	.col6(p[83])
);
vga_num_ram_module number_1(
	.clk(clk),
	.rst(rst),
	.data(num1),
	.col0(p[84]),
	.col1(p[85]),
	.col2(p[86]),
	.col3(p[87]),
	.col4(p[88]),
	.col5(p[89]),
	.col6(p[90])
);
vga_num_ram_module number_0(
	.clk(clk),
	.rst(rst),
	.data(num0),
	.col0(p[91]),
	.col1(p[92]),
	.col2(p[93]),
	.col3(p[94]),
	.col4(p[95]),
	.col5(p[96]),
	.col6(p[97])
);
	// 获得像素时钟25MHz
	assign pclk = count[1];
	always @ (posedge clk or posedge rst)
	begin
		if (rst)
			count <= 0;
		else
			count <= count+1;
	end
	
	// 列计数与行同�?
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
	
	// 行计数与场同�?
	assign vs = (vcount < 2) ? 0 : 1;
	always @ (posedge pclk or posedge rst)
	begin
		if (rst)
			vcount <= 0;
		else if (hcount == 799) 
			begin
				if (vcount == 520)
					vcount <= 0;
				else
					vcount <= vcount+1;
			end
		else
			vcount <= vcount;
	end
	
	// 设置显示信号�?
	always @ (posedge pclk or posedge rst)
	begin
		if (rst)
			begin
				r <= 0;
				g <= 0;
				b <= 0;
			end
		else if (vcount>=UP_BOUND && vcount<=DOWN_BOUND && hcount>=LEFT_BOUND && hcount<=RIGHT_BOUND)
			begin
			if (vcount>=up_pos && vcount<=down_pos && hcount>=left_pos && hcount<=right_pos)
				begin
				if (p[hcount-left_pos][vcount-up_pos])
					begin
						r <= 3'b111;
						g <= 3'b111;
						b <= 2'b11;
					end
				else 
					begin
						r <= 3'b000;
						g <= 3'b000;
						b <= 2'b00;
					end
				end
			else 
				begin
					r <= 3'b000;
					g <= 3'b000;
					b <= 2'b00;
				end
			end
		else 
		begin
			r <= 3'b000;
			g <= 3'b000;
			b <= 2'b00;
		end
	end
endmodule
 

 