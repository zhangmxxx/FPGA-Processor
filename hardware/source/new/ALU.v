module ALU(
	input [31:0] dataa,
	input [31:0] datab,
	input [3:0]  ALUctr,
	output reg less,
	output reg zero,
	output reg [31:0] aluresult
);

always @(*) begin
    zero = 1'b0;
    less = 1'b0;
    aluresult = 32'b0;
    casez (ALUctr) 
      /* add */
      4'b0000: begin 
        aluresult = dataa + datab;
        zero = (aluresult == 0);
      end
      /* sub */
      4'b1000: begin 
        aluresult = dataa - datab;
        zero = (aluresult == 0);
      end
      /* shl */
      4'b?001: begin 
        aluresult = (dataa << datab[4:0]);
        zero = (aluresult == 0);
      end
      /* less */
      4'b0010: begin 
        aluresult = ($signed(dataa) < $signed(datab));
        less = aluresult;
        zero = (dataa == datab);
      end
      /* lessu */
      4'b1010: begin 
        aluresult = ($unsigned(dataa) < $unsigned(datab));
        less = aluresult;
        zero = (dataa == datab);
      end
      /* outb */
      4'b?011: begin 
        aluresult = datab;
        zero = (datab == 0);
      end
      /* xor */
      4'b?100: begin
        aluresult = (dataa ^ datab);
        zero = (aluresult == 0); 
      end
      /* lshr */
      4'b0101: begin 
        aluresult = (dataa >> datab[4:0]);
        zero = (aluresult == 0);
      end
      /* ashr */
      4'b1101: begin 
        aluresult = ($signed(dataa)) >>> datab[4:0];
        zero = (aluresult == 0);
      end
      /* lor */
      4'b?110: begin 
        aluresult = (dataa | datab);
        zero = (aluresult == 0);
      end
      /* land */
      4'b?111: begin 
        aluresult = (dataa & datab);
        zero = (aluresult == 0);
      end 
      default: aluresult = 32'b0;
    endcase
  end
endmodule
