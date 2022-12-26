//rtl
module clk_even_div(
    input clk,
    input rst,
    output reg clk_div
);    
    parameter NUM_DIV = 4;
    reg [3:0]cnt;
    
always @(posedge clk or negedge rst)
    if(!rst) begin
        cnt     <= 4'd0;
        clk_div    <= 1'b0;
    end
    else if(cnt < NUM_DIV / 2 - 1) begin
        cnt     <= cnt + 1'b1;
        clk_div    <= clk_div;
    end
    else begin
        cnt     <= 4'd0;
        clk_div    <= ~clk_div;
    end
endmodule