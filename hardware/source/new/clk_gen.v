module clk_gen(input clkin, input clken, output reg clkout);
    parameter clk_freq = 500;
    parameter countlimit = 100000000/2/clk_freq - 1;
    reg[31:0] clkcount;  
    initial clkcount = 0;
    initial clkout = 0;
    always @ (posedge clkin)
        begin
            if (clken) begin
                if (clkcount >= countlimit) begin
                    clkcount <= 32'd0;
                    clkout <=~ clkout;
                end
                else begin
                    clkcount <= clkcount+1;
                end
            end
        end
endmodule