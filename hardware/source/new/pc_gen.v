module pc_gen(
  input [31:0] pc,
  input [31:0] imm,
  input [31:0] rs1,
  input [3:0]  branch,
  input rst,
  input less,
  input zero,  
  output reg [31:0] nextpc
);
// PCAsrc, PCBsrc are output of branch, zero, less
always @(*) begin
  nextpc <= 32'b0;
  if (rst) begin nextpc <= 32'b0; end
  else begin
    case (branch) 
      3'b000: begin
        nextpc <= pc + 4;
      end
      3'b001: begin
        nextpc <= pc + imm;
      end
      3'b010: begin
        nextpc <= rs1 + imm;
      end
      3'b100: begin
        if (zero == 1'b0) begin
          nextpc <= pc + 4;
        end
        else begin
          nextpc <= pc + imm;
        end
      end
      3'b101: begin
        if (zero == 1'b0) begin
          nextpc <= pc + imm;
        end
        else begin
          nextpc <= pc + 4;
        end
      end
      3'b110: begin
        if (less == 1'b0) begin
          nextpc <= pc + 4;
        end
        else begin
          nextpc <= pc + imm;
        end
      end
      3'b111: begin
        if (less == 1'b0) begin
          nextpc <= pc + imm;
        end
        else begin
          nextpc <= pc + 4;
        end
      end
    endcase
  end
end
endmodule