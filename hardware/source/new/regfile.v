module regfile (
  input  regwr,
  input  wrclk,
  input  [4:0]  ra,  //rs1
  input  [4:0]  rb,  //rs2
  input  [4:0]  rw,  //rd
  input  [31:0] busW,
  output reg [31:0] busA,
  output reg [31:0] busB
);

/* first for bit-width, second for index */
reg [31:0] regfile[31:0];

/* write (rd) at negedge */
always @(negedge wrclk) begin
//always @(~wrclk) begin
  if (regwr) regfile[rw] <= busW;
  regfile[0] <= 32'b0;
end

/* always read rs1 and rs2 */
/* x0 is always 0 */
always @(*) begin
  busA <= regfile[ra];
  busB <= regfile[rb];
end
endmodule