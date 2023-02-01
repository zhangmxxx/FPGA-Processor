module ctrl_gen(
  input [6:0]  opcode,
  input [2:0]  func3,
  input [6:0]  func7,
  output reg [2:0] extop,
  output reg       regwr,
  output reg       ALUAsrc,
  output reg [1:0] ALUBsrc,
  output reg [3:0] ALUctr,
  output reg [3:0] branch,
  output reg       memtoreg,
  output reg       memwr,
  output reg [2:0] memop
);

always @(*) begin
  extop <= 3'b0;
  regwr <= 1'b0;
  ALUAsrc <= 1'b0;
  ALUBsrc <= 2'b0;
  ALUctr <= 4'b0;
  branch <= 4'b0;
  memtoreg <= 1'b0;
  memwr <= 1'b0;
  memop <= 3'b0;
  /* lui */
  if (opcode[6:2] == 5'b01101) begin
    extop <= 3'b001;
    regwr <= 1'b1;
    branch <= 3'b000;
    memtoreg <= 1'b0;
    memwr <= 1'b0;
    ALUBsrc <= 2'b01;
    ALUctr <= 4'b0011;
  end
  /* auipc */
  else if (opcode[6:2] == 5'b00101) begin
    extop <= 3'b001;
    regwr <= 1'b1;
    branch <= 3'b000;
    memtoreg <= 1'b0;
    memwr <= 1'b0;
    ALUAsrc <= 1'b1;
    ALUBsrc <= 2'b01;
    ALUctr <= 4'b0000;
  end
  else if (opcode[6:2] == 5'b00100) begin
    /* addi */
    if (func3 == 3'b000) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0000;
    end
    /* slti */
    else if (func3 == 3'b010) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0010;
    end
    /* sltiu */
    else if (func3 == 3'b011) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b1010;
    end
    /* xori */
    else if (func3 == 3'b100) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0100;
    end
    /* ori */
    else if (func3 == 3'b110) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0110;
    end
    /* andi */
    else if (func3 == 3'b111) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0111;
    end
    /* slli */
    else if (func3 == 3'b001) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0001;
    end 
    else if (func3 == 3'b101) begin
      /* srli */
      if (func7[5] == 1'b0) begin
        extop <= 3'b000;
        regwr <= 1'b1;
        branch <= 3'b000;
        memtoreg <= 1'b0;
        memwr <= 1'b0;
        ALUAsrc <= 1'b0;
        ALUBsrc <= 2'b01;
        ALUctr <= 4'b0101;
      end
      /* srai */
      else if (func7[5] == 1'b1) begin
        extop <= 3'b000;
        regwr <= 1'b1;
        branch <= 3'b000;
        memtoreg <= 1'b0;
        memwr <= 1'b0;
        ALUAsrc <= 1'b0;
        ALUBsrc <= 2'b01;
        ALUctr <= 4'b1101;
      end
    end
  end
  else if (opcode[6:2] == 5'b01100) begin 
    if (func3 == 3'b000) begin
      /* add */
      if (func7[5] == 1'b0) begin
        regwr <= 1'b1;
        branch <= 3'b000;
        memtoreg <= 1'b0;
        memwr <= 1'b0;
        ALUAsrc <= 1'b0;
        ALUBsrc <= 2'b00;
        ALUctr <= 4'b0000;
      end
      /* sub */
      else if (func7[5] == 1'b1) begin
        regwr <= 1'b1;
        branch <= 3'b000;
        memtoreg <= 1'b0;
        memwr <= 1'b0;
        ALUAsrc <= 1'b0;
        ALUBsrc <= 2'b00;
        ALUctr <= 4'b1000;
      end
    end
    /* sll */
    else if (func3 == 3'b001) begin
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b0001;
    end
    /* slt */
    else if (func3 == 3'b010) begin
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b0010;
    end
    /* sltu */
    else if (func3 == 3'b011) begin 
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b1010;
    end
    /* xor */
    else if (func3 == 3'b100) begin
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b0100;
    end
    else if (func3 == 3'b101) begin
      /* srl */
      if (func7[5] == 1'b0) begin
        regwr <= 1'b1;
        branch <= 3'b000;
        memtoreg <= 1'b0;
        memwr <= 1'b0;
        ALUAsrc <= 1'b0;
        ALUBsrc <= 2'b00;
        ALUctr <= 4'b0101;
      end
      /* sra */
      else if (func7[5] == 1'b1) begin
        regwr <= 1'b1;
        branch <= 3'b000;
        memtoreg <= 1'b0;
        memwr <= 1'b0;
        ALUAsrc <= 1'b0;
        ALUBsrc <= 2'b00;
        ALUctr <= 4'b1101;
      end
    end
    /* or */
    else if (func3 == 3'b110) begin 
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b0110;
    end
    /* and */
    else if (func3 == 3'b111) begin
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b0;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b0111;
    end
  end
  /* jal */
  else if (opcode[6:2] == 5'b11011) begin
    extop <= 3'b100;
    regwr <= 1'b1;
    branch <= 3'b001;
    memtoreg <= 1'b0;
    memwr <= 1'b0;
    ALUAsrc <= 1'b1;
    ALUBsrc <= 2'b10;
    ALUctr <= 4'b0000;
  end
  /* jalr */
  else if (opcode[6:2] == 5'b11001) begin
    extop <= 3'b000;
    regwr <= 1'b1;
    branch <= 3'b010;
    memtoreg <= 1'b0;
    memwr <= 1'b0;
    ALUAsrc <= 1'b1;
    ALUBsrc <= 2'b10;
    ALUctr <= 4'b0000;
  end
  else if (opcode[6:2] == 5'b11000) begin
    /* beq */
    if (func3 == 3'b000) begin
      extop <= 3'b011;
      regwr <= 1'b0;
      branch <= 3'b100;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b0010;
    end
    /* bne */
    else if (func3 == 3'b001) begin
      extop <= 3'b011;
      regwr <= 1'b0;
      branch <= 3'b101;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b0010;
    end
    /* blt */
    else if (func3 == 3'b100) begin
      extop <= 3'b011;
      regwr <= 1'b0;
      branch <= 3'b110;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b0010;
    end
    /* bge */
    else if (func3 == 3'b101) begin
      extop <= 3'b011;
      regwr <= 1'b0;
      branch <= 3'b111;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b0010;
    end
    /* bltu */
    else if (func3 == 3'b110) begin
      extop <= 3'b011;
      regwr <= 1'b0;
      branch <= 3'b110;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b1010;
    end
    /* bgeu */
    else if (func3 == 3'b111) begin
      extop <= 3'b011;
      regwr <= 1'b0;
      branch <= 3'b111;
      memwr <= 1'b0;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b00;
      ALUctr <= 4'b1010;
    end
  end
  else if (opcode[6:2] == 5'b00000) begin
    /* lb */
    if (func3 == 3'b000) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b1;
      memwr <= 1'b0;
      memop <= 000;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0000;
    end
    /* lh */
    else if (func3 == 3'b001) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b1;
      memwr <= 1'b0;
      memop <= 001;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0000;
    end
    /* lw */
    else if (func3 == 3'b010) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b1;
      memwr <= 1'b0;
      memop <= 010;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0000;
    end
    /* lbu */
    else if (func3 == 3'b100) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b1;
      memwr <= 1'b0;
      memop <= 100;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0000;
    end
    /* lhu */
    else if (func3 == 3'b101) begin
      extop <= 3'b000;
      regwr <= 1'b1;
      branch <= 3'b000;
      memtoreg <= 1'b1;
      memwr <= 1'b0;
      memop <= 101;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0000;
    end
  end
  else if (opcode[6:2] == 5'b01000) begin
    /* sb */
    if (func3 == 3'b000) begin
      extop <= 3'b010;
      regwr <= 1'b0;
      branch <= 3'b000;
      memwr <= 1'b1;
      memop <= 000;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0000;
    end
    /* sh */
    else if (func3 == 3'b001) begin
      extop <= 3'b010;
      regwr <= 1'b0;
      branch <= 3'b000;
      memwr <= 1'b1;
      memop <= 001;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0000;
    end
    /* sw */
    else if (func3 == 3'b010) begin
      extop <= 3'b010;
      regwr <= 1'b0;
      branch <= 3'b000;
      memwr <= 1'b1;
      memop <= 010;
      ALUAsrc <= 1'b0;
      ALUBsrc <= 2'b01;
      ALUctr <= 4'b0000;
    end
  end
end


endmodule