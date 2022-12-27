`timescale 1ns / 1ps

module vga_module(
    input clk,
	input [4:0] state,
	input [23:0] record,
    output[11:0] rgb,
    output hsync,
    output vsync
    );
	
	//parameter define  
	parameter
    hsync_end = 10'd95,
    hdat_begin = 10'd143,
    hdat_end = 10'd783,
    hpixel_end = 10'd799,
    vsync_end = 10'd1,
    vdat_begin = 10'd34,
    vdat_end = 10'd514,
    vline_end = 10'd524;

	// wire vga_clk;
	reg vga_clk = 0;
	reg cnt_clk = 0;
	reg [11:0] hcount, vcount;
	reg[11:0] data;
	wire hcount_ov;
	wire vcount_ov;
	wire dat_act;
	wire hsync;
    wire vsync;
	wire [7:0] p[97:0];
	

	always@(posedge clk)
    begin
        if (cnt_clk == 1)
        begin
            vga_clk <= ~vga_clk;
            cnt_clk <= 0;
        end
        else
            cnt_clk <= cnt_clk + 1;
    end

	//行计数器对像素时钟计�??
	always@(posedge vga_clk)
	begin
		if(hcount_ov)
			hcount <= 10'd0;
		else
			hcount <= hcount + 10'd1;
	end
	assign hcount_ov = (hcount == hpixel_end);
	
	//场计数器对行计数
	always@(posedge vga_clk)
	begin
		if(hcount_ov)
		begin
			if(vcount_ov)
			vcount <= 10'd0;
			else
			vcount <= vcount + 10'd1;
		end
	end
	assign vcount_ov = (vcount == vline_end);

	//VGA行场同步信号
	assign dat_act = ((hcount >= hdat_begin) && (hcount < hdat_end)) && ((vcount > vdat_begin) && (vcount<vdat_end));
	assign hsync   = (hcount > hsync_end);                    
	assign vsync   = (vcount > vsync_end);
	assign rgb = (dat_act)?data:3'h000;   
	
	// 设置显示信号�???
	always @ (posedge vga_clk)
	begin
		 if(vcount<=50||vcount>=490)
			data <= 12'h000;//hei
    	else if(vcount ==90||vcount ==130||vcount ==170||vcount==210 ||vcount==250||vcount ==290||vcount ==330||vcount==370 ||vcount==410||vcount==450)
      		data <= 12'h000;
   		else
     		data <= 12'hfff;
	end
endmodule
 

 
