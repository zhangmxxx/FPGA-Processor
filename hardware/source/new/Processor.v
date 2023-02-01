module Processor(
  // input BTNC,
  input CLK100MHZ,
  input reset,
  /* VGA */
  output [3:0] VGA_R,
  output [3:0] VGA_G,
  output [3:0] VGA_B,
  output VGA_HS,
  output VGA_VS,
  /* KBD */
  input PS2_CLK,
  input PS2_DAT,
  /* SEG7 */
  output [7:0] SEG,
  output [7:0] AN,
  /* LED */
  output [15:0] LED
);

/*--------------------CLOCK WIRES--------------------*/

wire CLK25;
wire CLK50;
//wire cpu_clk;
wire CPU_CLK;
//assign CPU_CLK = BTNC;
wire seg_clk;
clk_wiz_0 processor_clk(.clk_in1(CLK100MHZ), .clk_out1(CLK25), .clk_out2(CLK50), .clk_out3(CPU_CLK));
clk_gen display_clk(CLK100MHZ, 1'b1, seg_clk);
//testclk clk1(CLK100MHZ, 1'b1, CPU_CLK);

/*--------------------CPU WIRES--------------------*/
wire [31:0] i_dataout;
wire [31:0] d_dataout;
wire [31:0] d_addr;
wire [31:0] d_datain;
wire [31:0] dbgdata;
wire [31:0] i_addr;
wire [2:0]  memop;
wire memwr;
/*--------------------SEG WIRES--------------------*/
wire [7:0] part;
wire [31:0] _dbgdata;
/*--------------------VGA WIRES--------------------*/
wire valid;
wire [11:0] vga_data;
wire [9:0]  h_addr;
wire [9:0]  v_addr;
wire [6:0]  h_char;
wire [6:0]  v_char;
wire [3:0]  h_font;
wire [3:0]  v_font;
wire [7:0]  char_out;
reg  [7:0]  char_out_sync;
wire [13:0] char_addr;
wire [23:0] color_out;
reg  [23:0] color_out_sync;
wire [13:0] color_addr;
reg  [31:0] line_offset;
assign char_addr  = {h_char, v_char + line_offset[6:0]};
assign color_addr = {h_char, v_char + line_offset[6:0]};
/*--------------------KEYBRD WIRES--------------------*/
reg  [4:0] head;
reg  [4:0] tail;
wire [7:0] keydata;
reg  [7:0] current_key;
reg new_key;
reg ignore_next;
reg nextdata_n;
wire ready;
initial begin
  head <= 5'b0;
  tail <= 5'b0;
end
/*--------------------CLK WIRES--------------------*/
parameter freq = 1000000;
parameter countlimit = 100000000 / freq - 1;
reg  [31:0] count;
reg  [31:0] count_us;
initial begin
  count <= 32'b0;
  count_us <= 32'b0;
end
/*--------------------MEM WIRES--------------------*/
// control registers are not combined into xmemout.
/* enable signal */
wire datawe;
wire vgawe;
wire kbdwe;
wire line_offset_we;
wire color_we;
wire ledwe;
wire segwe;
/* main data wire and latch */
reg  [31:0] d_data_sync;
wire [31:0] d_data;
/* datain/dataout for modules */ 
wire [13:0] wr_char_addr;
wire [7:0]  char_buf_data;
wire [13:0] wr_color_addr;
wire [23:0] color_buf_data;
wire [15:0] led_data;
wire [31:0] seg_data;
wire [31:0] keymemout;
wire [31:0] clkmemout;
/* default initialization */
initial begin
  d_data_sync <= 32'b0;
  line_offset <= 32'b0;
end

/* memout */
always @(*) begin
  d_data_sync <= 32'b0;
  case (d_addr[31:20]) 
    12'h001: begin
      d_data_sync <= d_dataout;
    end
    12'h002: begin
      if (d_addr[19:0] == 20'h10000) begin
        d_data_sync <= line_offset;
      end
    end
    12'h003: begin
      if (d_addr[19:0] == 20'h10000) begin
        d_data_sync <= {22'b0, head, tail};
      end
      else d_data_sync <= keymemout;
    end
    12'h004: begin
      d_data_sync <= clkmemout;
    end
    default: d_data_sync <= 32'b0;
  endcase
end

assign d_data = d_data_sync;

/* enable signals */
assign datawe   = (d_addr[31:20] == 12'h001) ? memwr : 1'b0;
assign vgawe    = (d_addr[31:16] == 16'h0020) ? memwr : 1'b0;
assign kbdwe    = (d_addr[31:20] == 12'h003) ? memwr : 1'b0;
assign ledwe    = (d_addr[31:20] == 12'h005) ? memwr : 1'b0;
assign segwe    = (d_addr[31:20] == 12'h006) ? memwr : 1'b0;
assign color_we = (d_addr[31:16] == 16'h0022) ? memwr : 1'b0;
assign line_offset_we = (d_addr == 32'h00210000) ? memwr : 1'b0;

/* datain/dataout for modules */
assign char_buf_data  = vgawe ? d_datain[7:0]  : 8'b0;
assign led_data       = ledwe ? d_datain[15:0] : 16'b0;
assign seg_data       = segwe ? d_datain[31:0] : 32'b0;
assign wr_char_addr   = vgawe ? d_addr[13:0]   : 14'b0;
assign color_buf_data = color_we ? d_datain[23:0] : 24'b0;
assign wr_color_addr  = color_we ? d_addr[13:0]   : 14'b0;
/*------------------COMPONENTS------------------*/

cpu mycpu(.CPU_CLK(CPU_CLK),
          .rst(reset),
          .inst(i_dataout),
          .d_dataout(d_data),
          .d_addr(d_addr),
          .d_datain(d_datain),
          .dbgdata(dbgdata),
          .nextpc(i_addr),
          .memop(memop),
          .memwr(memwr));

//0x000
imem instructions(.addra(i_addr[17:2]),
                  .clka(~CPU_CLK),
                  .dina(32'b0),
                  .douta(i_dataout),
                  .wea(1'b0));
//0x001
dmem  datamem(.addr(d_addr), 
              .dataout(d_dataout),
              .datain(d_datain), 
              .rdclk(CPU_CLK), 
              .wrclk(~CPU_CLK), 
              .memop(memop), 
              .we(datawe));
//0x002
vga_ctrl myvga_ctrl(.pclk(CLK25), 
                    .reset(reset), 
                    .vga_data(vga_data), 
                    .h_addr(h_addr), 
                    .v_addr(v_addr), 
                    .hsync(VGA_HS), 
                    .vsync(VGA_VS), 
                    .valid(valid), 
                    .vga_r(VGA_R), 
                    .vga_g(VGA_G), 
                    .vga_b(VGA_B), 
                    .h_char(h_char), 
                    .v_char(v_char), 
                    .h_font(h_font), 
                    .v_font(v_font));

vga_ascii ascii(.pclk(CLK50), 
                .rst(reset), 
                .valid(valid), 
                .char(char_out_sync), 
                .h_font(h_font), 
                .v_font(v_font),  
                .frontcolor(color_out_sync[23:12]),
                .backcolor(color_out_sync[11:0]),
                .vga_data(vga_data));

char_buf  mybuf(.addra(wr_char_addr),
                .clka(~CPU_CLK),
                .dina(char_buf_data),
                .ena(1'b1),
                .wea(vgawe),
                .addrb(char_addr),
                .clkb(~CLK50),
                .doutb(char_out),
                .enb(1'b1));

color_buf clbuf(.addra(wr_color_addr),
                .clka(~CPU_CLK),
                .dina(color_buf_data),
                .ena(1'b1),
                .wea(color_we),
                .addrb(color_addr),
                .clkb(~CLK50),
                .doutb(color_out),
                .enb(1'b1));
/* latch */
always @(posedge CLK50) begin
  char_out_sync  <= char_out;
  color_out_sync <= color_out;
end    

always @(negedge CPU_CLK) begin
  if (line_offset_we) 
    line_offset <= d_datain;
end


//0x003
reg [7:0] key_queue [31:0];

ps2_keyboard receiver(.clk(CLK50),
                      .clrn(~reset),
                      .ps2_clk(PS2_CLK),
                      .ps2_data(PS2_DAT),
                      .data(keydata),
                      .ready(ready),
                      .nextdata_n(nextdata_n));

always @(posedge CLK50) begin
  if (ready && nextdata_n) begin
    if (keydata == 8'hF0) begin
      ignore_next <= 1'b1;
      current_key <= 8'b0;
    end
    else if (ignore_next) begin
      ignore_next <= 1'b0;
    end
    else begin
      new_key <= 1'b1;
      if (keydata != current_key) begin
        current_key <= keydata;
      end
    end
    nextdata_n <= 1'b0;
  end
  else begin
    nextdata_n <= 1'b1; new_key <= 1'b0;
  end
  if (reset) begin
    new_key <= 1'b0;
    ignore_next <= 1'b0;
    nextdata_n <= 1'b1;
  end
end

always @(negedge CLK50) begin
  if (tail != head - 1 && current_key != 8'b0 && new_key) begin
    key_queue[tail] <= current_key;
    tail <= tail + 1;
  end
end

always @(negedge CPU_CLK) begin
  if (kbdwe) head <= head + 1;
end

assign keymemout = {24'b0, key_queue[head]};

//0x004

always @(posedge CLK100MHZ) begin
  if (count >= countlimit) begin
    count <= 32'b0;
    count_us <= count_us + 1;
  end
  else begin
    count <= count + 1;
  end
end

assign clkmemout = count_us;

//0x005
reg [15:0] led;
assign LED = led;

always @(negedge CPU_CLK) begin
  if (ledwe) led <= led_data;
end


//0x006
reg [31:0] seg;

always @(negedge CPU_CLK) begin
  if (segwe) seg <= seg_data;
end

assign _dbgdata = seg;

/*------------------SEG-DISPLAY------------------*/

bcd7seg seger(part, SEG);
segdisplay mydisplayer(seg_clk, _dbgdata, AN, part);


// assign _dbgdata = {16'b0, 3'b0, head, 3'b0, tail}; // hardware head/tail in `memory' 
// assign _dbgdata = {mycpu.cpu_regfile.regfile[12][15:0], mycpu.cpu_regfile.regfile[11][15:0]}; // runtime head/tail in register 
// assign _dbgdata = {dbgdata[15:0], mycpu.cpu_regfile.regfile[13][15:0]}; // read a3 for keymem reading result, with pc.
// assign _dbgdata = dbgdata;
endmodule