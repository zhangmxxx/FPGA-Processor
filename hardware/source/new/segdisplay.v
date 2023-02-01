module segdisplay(clk, data, an, part);
  input clk;
  input [31:0] data;
  output reg [7:0] an;   // choice of the seg
  output reg [7:0] part; // content to display
  
  reg [2:0] select;
  initial select = 3'b000;
  
  always@(posedge clk) begin
    case(select)
      3'b000: begin 
        an = 8'b11111110;
        part = data % 16;
        select <= select + 1;
      end
      3'b001: begin 
        an = 8'b11111101; 
        part = data / 16 % 16;
        select <= select + 1;
      end
      3'b010: begin 
        an = 8'b11111011; 
        part = data / 16 / 16 % 16;
        select <= select + 1;
      end
      3'b011: begin 
        an = 8'b11110111; 
        part = data / 16 / 16 / 16 % 16;
        select <= select + 1;
      end
      3'b100: begin 
        an = 8'b11101111; 
        part = data / 16 / 16 / 16 / 16 % 16;
        select <= select + 1; 
      end
      3'b101: begin 
        an = 8'b11011111; 
        part = data / 16 / 16 / 16 / 16 / 16 % 16;
        select <= select + 1; 
      end
      3'b110: begin 
        an = 8'b10111111; 
        part = data / 16 / 16 / 16 / 16 / 16 / 16 % 16;
        select <= select + 1; 
      end
      3'b111: begin 
        an = 8'b01111111; 
        part = data / 16 / 16 / 16 / 16 / 16 / 16 / 16 % 16;
        select <= 3'b000; 
      end
    endcase
  end
endmodule
