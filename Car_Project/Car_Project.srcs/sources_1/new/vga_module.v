`timescale 1ns / 1ps

module vga_module (
    input clk,  // 100MHz system clock
    input [4:0] state,  // Car state
    input [23:0] record,  // Record data
    output [11:0] rgb,  // Red, green and blue color signals
    output hsync,  // Line synchronization signal
    output vsync  // Field synchronization signal
);
  //parameter define  
  parameter
    HDAT_BEGIN = 10'd144,
    HDAT_END = 10'd783,
	VDAT_BEGIN= 10'd35,
    VDAT_END = 10'd514,

	HSYNC_END = 10'd95,
    VSYNC_END = 10'd1,
	HPIXEKL_END = 10'd799,
    VLINE_END = 10'd524;

  // wire vga_clk;
  reg vga_clk = 0;
  reg cnt_clk = 0;
  reg [11:0] hcount, vcount;
  reg [11:0] data;
  wire hcount_ov;
  wire vcount_ov;
  wire dat_act;

  wire [7:0] p[41:0];
  wire [7:0] p1[41:0];
  wire [7:0] p2[48:0];
  wire [7:0] mile[48:0];
  reg [63:0] st[336:0];
  reg [63:0] st1[336:0];
  reg [63:0] st2[392:0];
  reg [63:0] mile_after[392:0];
  reg [5:0] let0, let1, let2, let3, let4, let5;
  reg [3:0] num0, num1, num2, num3, num4, num5, num6;

  parameter power_off = 5'b0XXXX;
  parameter manual_non_staring = 5'b11001;
  parameter manual_starting = 5'b11010;
  parameter manual_moving = 5'b11011;
  parameter semi = 5'b101XX;
  parameter auto = 5'b111XX;

  parameter
		A = 6'b00_1010,
		E = 6'b00_1110,
		F = 6'b00_1111,
		G = 6'b01_0000,
		I = 6'b01_0010,
		L = 6'b01_0101,
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


  always @(posedge clk) begin
    if (cnt_clk == 1) begin
      vga_clk <= ~vga_clk;
      cnt_clk <= 0;
    end else cnt_clk <= cnt_clk + 1;
  end


  always @(posedge vga_clk) begin
    casex (state)
      manual_non_staring: begin
        let0 <= N;
        let1 <= O;
        let2 <= N;
        let3 <= S;
        let4 <= T;
        let5 <= A;
      end
      //----------------------------------------------------
      manual_starting: begin
        let0 <= S;
        let1 <= T;
        let2 <= A;
        let3 <= R;
        let4 <= T;
        let5 <= 6'b00_000;
      end
      //----------------------------------------------------
      manual_moving: begin
        let0 <= M;
        let1 <= O;
        let2 <= V;
        let3 <= I;
        let4 <= N;
        let5 <= G;
      end
      //----------------------------------------------------
      semi: begin
        let0 <= S;
        let1 <= E;
        let2 <= M;
        let3 <= I;
        let4 <= 6'b00_0000;
        let5 <= 6'b00_000;
      end
      //----------------------------------------------------
      auto: begin
        let0 <= A;
        let1 <= U;
        let2 <= T;
        let3 <= O;
        let4 <= 6'b00_0000;
        let5 <= 6'b00_0000;
      end
      //----------------------------------------------------
      default: begin
        let0 <= P;
        let1 <= O;
        let2 <= W;
        let3 <= O;
        let4 <= F;
        let5 <= F;
      end
    endcase
  end

  vga_let_ram_module letter_0 (
      .clk (vga_clk),
      .data(let0),
      .col0(p[0]),
      .col1(p[1]),
      .col2(p[2]),
      .col3(p[3]),
      .col4(p[4]),
      .col5(p[5]),
      .col6(p[6])
  );
  vga_let_ram_module letter_1 (
      .clk (vga_clk),
      .data(let1),
      .col0(p[7]),
      .col1(p[8]),
      .col2(p[9]),
      .col3(p[10]),
      .col4(p[11]),
      .col5(p[12]),
      .col6(p[13])
  );
  vga_let_ram_module letter_2 (
      .clk (vga_clk),
      .data(let2),
      .col0(p[14]),
      .col1(p[15]),
      .col2(p[16]),
      .col3(p[17]),
      .col4(p[18]),
      .col5(p[19]),
      .col6(p[20])
  );
  vga_let_ram_module letter_3 (
      .clk (vga_clk),
      .data(let3),
      .col0(p[21]),
      .col1(p[22]),
      .col2(p[23]),
      .col3(p[24]),
      .col4(p[25]),
      .col5(p[26]),
      .col6(p[27])
  );
  vga_let_ram_module letter_4 (
      .clk (vga_clk),
      .data(let4),
      .col0(p[28]),
      .col1(p[29]),
      .col2(p[30]),
      .col3(p[31]),
      .col4(p[32]),
      .col5(p[33]),
      .col6(p[34])
  );
  vga_let_ram_module letter_5 (
      .clk (vga_clk),
      .data(let5),
      .col0(p[35]),
      .col1(p[36]),
      .col2(p[37]),
      .col3(p[38]),
      .col4(p[39]),
      .col5(p[40]),
      .col6(p[41])
  );
  vga_let_ram_module letter_10 (
      .clk (vga_clk),
      .data(S),
      .col0(p1[0]),
      .col1(p1[1]),
      .col2(p1[2]),
      .col3(p1[3]),
      .col4(p1[4]),
      .col5(p1[5]),
      .col6(p1[6])
  );
  vga_let_ram_module letter_11 (
      .clk (vga_clk),
      .data(T),
      .col0(p1[7]),
      .col1(p1[8]),
      .col2(p1[9]),
      .col3(p1[10]),
      .col4(p1[11]),
      .col5(p1[12]),
      .col6(p1[13])
  );
  vga_let_ram_module letter_12 (
      .clk (vga_clk),
      .data(A),
      .col0(p1[14]),
      .col1(p1[15]),
      .col2(p1[16]),
      .col3(p1[17]),
      .col4(p1[18]),
      .col5(p1[19]),
      .col6(p1[20])
  );
  vga_let_ram_module letter_13 (
      .clk (vga_clk),
      .data(T),
      .col0(p1[21]),
      .col1(p1[22]),
      .col2(p1[23]),
      .col3(p1[24]),
      .col4(p1[25]),
      .col5(p1[26]),
      .col6(p1[27])
  );
  vga_let_ram_module letter_14 (
      .clk (vga_clk),
      .data(E),
      .col0(p1[28]),
      .col1(p1[29]),
      .col2(p1[30]),
      .col3(p1[31]),
      .col4(p1[32]),
      .col5(p1[33]),
      .col6(p1[34])
  );
  vga_let_ram_module letter_15 (
      .clk (vga_clk),
      .data(6'b11_1110),
      .col0(p1[35]),
      .col1(p1[36]),
      .col2(p1[37]),
      .col3(p1[38]),
      .col4(p1[39]),
      .col5(p1[40]),
      .col6(p1[41])
  );
  vga_let_ram_module letter_20 (
      .clk (vga_clk),
      .data(M),
      .col0(p2[0]),
      .col1(p2[1]),
      .col2(p2[2]),
      .col3(p2[3]),
      .col4(p2[4]),
      .col5(p2[5]),
      .col6(p2[6])
  );
  vga_let_ram_module letter_21 (
      .clk (vga_clk),
      .data(I),
      .col0(p2[7]),
      .col1(p2[8]),
      .col2(p2[9]),
      .col3(p2[10]),
      .col4(p2[11]),
      .col5(p2[12]),
      .col6(p2[13])
  );
  vga_let_ram_module letter_22 (
      .clk (vga_clk),
      .data(L),
      .col0(p2[14]),
      .col1(p2[15]),
      .col2(p2[16]),
      .col3(p2[17]),
      .col4(p2[18]),
      .col5(p2[19]),
      .col6(p2[20])
  );
  vga_let_ram_module letter_23 (
      .clk (vga_clk),
      .data(E),
      .col0(p2[21]),
      .col1(p2[22]),
      .col2(p2[23]),
      .col3(p2[24]),
      .col4(p2[25]),
      .col5(p2[26]),
      .col6(p2[27])
  );
  vga_let_ram_module letter_24 (
      .clk (vga_clk),
      .data(A),
      .col0(p2[28]),
      .col1(p2[29]),
      .col2(p2[30]),
      .col3(p2[31]),
      .col4(p2[32]),
      .col5(p2[33]),
      .col6(p2[34])
  );
  vga_let_ram_module letter_25 (
      .clk (vga_clk),
      .data(G),
      .col0(p2[35]),
      .col1(p2[36]),
      .col2(p2[37]),
      .col3(p2[38]),
      .col4(p2[39]),
      .col5(p2[40]),
      .col6(p2[41])
  );
  vga_let_ram_module letter_26 (
      .clk (vga_clk),
      .data(E),
      .col0(p2[42]),
      .col1(p2[43]),
      .col2(p2[44]),
      .col3(p2[45]),
      .col4(p2[46]),
      .col5(p2[47]),
      .col6(p2[48])
  );

  always @(posedge vga_clk) begin
    num6 <= record / 1_000_000 % 10;
    num5 <= record / 1_000_00 % 10;
    num4 <= record / 1_000_0 % 10;
    num3 <= record / 1_000 % 10;
    num2 <= record / 1_00 % 10;
    num1 <= record / 1_0 % 10;
    num0 <= record % 10;
  end

  vga_num_ram_module number_6 (
      .clk (vga_clk),
      .data(num6),
      .col0(mile[0]),
      .col1(mile[1]),
      .col2(mile[2]),
      .col3(mile[3]),
      .col4(mile[4]),
      .col5(mile[5]),
      .col6(mile[6])
  );
  vga_num_ram_module number_5 (
      .clk (vga_clk),
      .data(num5),
      .col0(mile[7]),
      .col1(mile[8]),
      .col2(mile[9]),
      .col3(mile[10]),
      .col4(mile[11]),
      .col5(mile[12]),
      .col6(mile[13])
  );
  vga_num_ram_module number_4 (
      .clk (vga_clk),
      .data(num4),
      .col0(mile[14]),
      .col1(mile[15]),
      .col2(mile[16]),
      .col3(mile[17]),
      .col4(mile[18]),
      .col5(mile[19]),
      .col6(mile[20])
  );
  vga_num_ram_module number_3 (
      .clk (vga_clk),
      .data(num3),
      .col0(mile[21]),
      .col1(mile[22]),
      .col2(mile[23]),
      .col3(mile[24]),
      .col4(mile[25]),
      .col5(mile[26]),
      .col6(mile[27])
  );
  vga_num_ram_module number_2 (
      .clk (vga_clk),
      .data(num2),
      .col0(mile[28]),
      .col1(mile[29]),
      .col2(mile[30]),
      .col3(mile[31]),
      .col4(mile[32]),
      .col5(mile[33]),
      .col6(mile[34])
  );
  vga_num_ram_module number_1 (
      .clk (vga_clk),
      .data(num1),
      .col0(mile[35]),
      .col1(mile[36]),
      .col2(mile[37]),
      .col3(mile[38]),
      .col4(mile[39]),
      .col5(mile[40]),
      .col6(mile[41])
  );
  vga_num_ram_module number_0 (
      .clk (vga_clk),
      .data(num0),
      .col0(mile[42]),
      .col1(mile[43]),
      .col2(mile[44]),
      .col3(mile[45]),
      .col4(mile[46]),
      .col5(mile[47]),
      .col6(mile[48])
  );

  //行计数器对像素时钟计数
  always @(posedge vga_clk) begin
    if (hcount_ov) hcount <= 10'd0;
    else hcount <= hcount + 10'd1;
  end
  assign hcount_ov = (hcount == HPIXEKL_END);

  //场计数器对行计数
  always @(posedge vga_clk) begin
    if (hcount_ov) begin
      if (vcount_ov) vcount <= 10'd0;
      else vcount <= vcount + 10'd1;
    end
  end
  assign vcount_ov = (vcount == VLINE_END);

  //VGA行场同步信号
  assign dat_act = ((hcount >= HDAT_BEGIN) && (hcount <= HDAT_END)) && ((vcount >= VDAT_BEGIN) && (vcount <= VDAT_END));
  assign hsync = (hcount > HSYNC_END);
  assign vsync = (vcount > VSYNC_END);
  assign rgb = (dat_act) ? data : 3'h000;

  integer i;
  integer j;

  // 设置显示信号
  always @(posedge vga_clk) begin
    for (i = 0; i < 336; i = i + 1) begin
      for (j = 0; j < 64; j = j + 1) begin
        st[i][j]  = p[i/8][j/8];
        st1[i][j] = p1[i/8][j/8];
      end
    end
    for (i = 0; i < 392; i = i + 1) begin
      for (j = 0; j < 64; j = j + 1) begin
        st2[i][j] = p2[i/8][j/8];
        mile_after[i][j] = mile[i/8][j/8];
      end
    end
    if (hcount >= 272 && vcount >= 120 && hcount - 272 <= 391 && vcount - 120 <= 255) begin
      if (vcount - 120 <= 63 && hcount - 272 <= 335) begin
        if (st1[hcount-272][vcount-120]) data <= 12'h000;
        else data <= 12'hffc;
      end else if (vcount - 120 > 63 && vcount - 120 <= 127 && hcount - 272 <= 335) begin
        if (st[hcount-272][vcount-184]) data <= 12'hcff;
        else data <= 12'hffc;
      end else if (vcount - 120 > 127 && vcount - 120 <= 191) begin
        if (st2[hcount-272][vcount-248]) data <= 12'h000;
        else data <= 12'hffc;
      end else if (vcount - 120 > 191) begin
        if (mile_after[hcount-272][vcount-312]) data <= 12'hcff;
        else data <= 12'hffc;
      end
    end else data <= 12'hfff;
  end
endmodule



