module cpu (
  input         CPU_CLK,
  input         rst,
  input  [31:0] inst,
  input  [31:0] d_dataout,
  output [31:0] d_addr,
  output [31:0] d_datain,
  output [31:0] dbgdata,
  output [31:0] nextpc,
  output [2:0]  memop,
  output memwr
); 
/*--------------------UTILS--------------------*/
reg  [31:0] pc;
reg  [31:0] dnpc;
wire [31:0] imm;
wire [31:0] busA;
wire [31:0] busB;
wire [31:0] busW;

/*--------------------CTRL--------------------*/

wire [2:0]  extop;
wire        regwr;
wire        ALUAsrc;
wire [1:0]  ALUBsrc;
wire [3:0]  ALUctr;
wire [3:0]  branch;
wire        memtoreg;

/*--------------------ALU--------------------*/
wire [31:0] dataa;
wire [31:0] datab;
wire        less;
wire        zero;
wire [31:0] aluresult;

assign dataa = ALUAsrc ? pc : busA;
assign datab = ALUBsrc[1] ? 4 : (ALUBsrc[0] ? imm : busB);
assign busW  = memtoreg ? d_dataout : aluresult;

/*--------CONNECTION_WITH_UPPER_MODULE---------*/

assign d_addr = aluresult;
assign d_datain = busB;

/*------------------SUBMODULES------------------*/
ALU cpu_alu(.dataa(dataa), 
        .datab(datab), 
        .ALUctr(ALUctr), 
        .less(less), 
        .zero(zero), 
        .aluresult(aluresult));

regfile cpu_regfile(.regwr(regwr), 
                    .wrclk(CPU_CLK), 
                    .ra(inst[19:15]), 
                    .rb(inst[24:20]),
                    .rw(inst[11:7]), 
                    .busW(busW), 
                    .busA(busA), 
                    .busB(busB));

imm_gen cpu_imm_gen(.extop(extop), 
                    .inst(inst), 
                    .imm(imm));

ctrl_gen cpu_ctrl_gen(.opcode(inst[6:0]), 
                      .func3(inst[14:12]), 
                      .func7(inst[31:25]), 
                      .extop(extop), 
                      .regwr(regwr), 
                      .ALUAsrc(ALUAsrc), 
                      .ALUBsrc(ALUBsrc), 
                      .ALUctr(ALUctr), 
                      .branch(branch), 
                      .memtoreg(memtoreg), 
                      .memwr(memwr), 
                      .memop(memop));

pc_gen cpu_pc_gen(.pc(pc), 
                  .imm(imm), 
                  .rs1(busA), 
                  .branch(branch), 
                  .rst(rst), 
                  .less(less), 
                  .zero(zero), 
                  .nextpc(nextpc));

/* execute once */
always @(*) begin
  if (rst) dnpc <= 32'b0;
  else dnpc <= nextpc;
end
always @(negedge CPU_CLK) begin
//always @(~CPU_CLK) begin
  pc <= dnpc;
end


/* debug */
//assign dbgdata = {cpu_regfile.regfile[6][15:0], cpu_regfile.regfile[7][15:0]};
assign dbgdata = pc;
endmodule
