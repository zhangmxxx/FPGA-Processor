module vga_ascii(
  input pclk,
  input rst, 
  input valid,
  input [7:0] char,
  input [3:0] h_font,
  input [3:0] v_font,
  input [11:0] frontcolor,
  input [11:0] backcolor,
  output reg [11:0] vga_data
);
  /* address mapping: {char, v_font} is the line index.*/
  reg [11:0] myfont[4095:0];
  wire [11:0] line;
  
  initial begin
    $readmemh("G:/Processor/vga_font.txt", myfont, 0, 4095);
  end

  wire [11:0] out_data;

  assign out_data = (line[h_font] == 1'b1) ? frontcolor : backcolor;
  assign line = myfont[{char, v_font}];


  always @(posedge pclk) begin
    if (rst == 1'b1)
      vga_data <= 12'h000;
    else begin
      if (valid)
        vga_data <= out_data;
      else 
        vga_data <= 12'h000;  // !valid does not mean left space except the letter. vga_data should be set to 0 instead of back_color to avoid err-display of background
    end
  end
endmodule
