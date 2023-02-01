module vga_ctrl(
  input pclk, //25MHz clock
  input reset, 
  input [11:0] vga_data, //vga data from upper module 
  output [9:0] h_addr, //horizontal pos of current pixel
  output [9:0] v_addr, //vertical pos of current pixel
  output hsync, //horizontal sync
  output vsync, //vertical sync
  output valid,
  output [3:0] vga_r, //color data respectively
  output [3:0] vga_g,
  output [3:0] vga_b, 
  output reg [6:0] h_char,
  output [6:0] v_char,
  output reg [3:0] h_font,
  output [3:0] v_font
);
  // h_char, v_char: char index
  // h_font, v_font: index inside one char
  //vga parameters
  parameter h_frontporch = 96;
  parameter h_active = 150;
  parameter h_backporch = 784;
  parameter h_total = 800;  

  parameter v_frontporch = 2;
  parameter v_active = 35;
  parameter v_backporch = 515;
  parameter v_total = 525;

  reg [9:0] x_cnt;
  reg [9:0] y_cnt;
  wire h_valid;
  wire v_valid; 
  wire [9:0] v_modi;

  /* h_font, h_char */
  always @(posedge pclk) begin
    if (h_valid == 1'b0) begin h_char <= 6'b0; h_font <= 4'b0; end
    else begin
      if (h_font >= 4'd8) begin
        h_char <= h_char + 6'd1;
        h_font <= 4'd0;
      end
      else h_font <= h_font + 4'd1;
    end
  end

  assign v_char = {2'b0, v_modi[8:4]}; // vga travels v_char limited to 5-bit, so add 0s is correct
  assign v_font = v_modi[3:0];

  assign v_modi = v_valid ? (y_cnt - 10'd39) : {10{1'b0}};

  always @(posedge reset or posedge pclk) begin  // pixels by row
    if (reset == 1'b1) 
      x_cnt <= 1;
    else begin
      if (x_cnt == h_total) 
        x_cnt <= 1;
      else x_cnt <= x_cnt + 10'd1;
    end 
  end

  always @(posedge pclk) begin // pixels by column
    if (reset == 1'b1) 
      y_cnt <= 1;
    else begin
      if (y_cnt == v_total & x_cnt == h_total) 
        y_cnt <= 1;
      else if (x_cnt == h_total) 
        y_cnt <= y_cnt + 10'd1;
    end
  end

  assign hsync = (x_cnt > h_frontporch);
  assign vsync = (y_cnt > v_frontporch);

  assign h_valid = (x_cnt > h_active) & (x_cnt <= h_backporch);
  assign v_valid = (y_cnt > v_active) & (y_cnt <= v_backporch);
  assign valid = h_valid & v_valid;

  assign h_addr = h_valid ? (x_cnt - 10'd144) : {10{1'b0}};
  assign v_addr = v_valid ? (y_cnt - 10'd35) : {10{1'b0}};

  assign vga_r = vga_data[11:8];
  assign vga_g = vga_data[7:4];
  assign vga_b = vga_data[3:0];

endmodule
