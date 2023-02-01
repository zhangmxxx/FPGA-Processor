module imm_gen(
  input  [2:0]  extop,
  input  [31:0] inst,
  output [31:0] imm
);

wire [31:0] immI;
wire [31:0] immU;
wire [31:0] immS;
wire [31:0] immB;
wire [31:0] immJ;

/* imm generate */
assign immI = {{20{inst[31]}}, inst[31:20]};
assign immU = {inst[31:12], 12'b0};
assign immS = {{20{inst[31]}}, inst[31:25], inst[11:7]};
assign immB = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
assign immJ = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};

/* imm select */
/* recursive `? :` */
assign imm = (extop[2] ? immJ : (extop[1] ? (extop[0] ? immB : immS) : (extop[0] ? immU : immI)));
endmodule
