`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/07 17:37:00
// Design Name: 
// Module Name: vga_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
module vga_tb();
    reg clk25;            
    wire [3:0] vga_red;   
    wire [3:0] vga_green;
    wire [3:0] vga_blue;
    wire vga_hsync;
    wire vga_vsync;
    wire [18:0] frame_addr;
    reg [11:0] frame_pixel;
    reg [2:0] color_display;
    vga uut(
        .clk25(clk25),
        .vga_red(vga_red),
        .vga_green(vga_green),
        .vga_blue(vga_blue),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),
        .frame_addr(frame_addr),
        .frame_pixel(frame_pixel),
        .color_display(color_display)
    );
    initial begin
        clk25<=1;
        frame_pixel<=12'b0;
        color_display<=3'b000;
        #30 color_display<=3'b001;
        #30 color_display<=3'b010;
        #30 color_display<=3'b100; 
        #30 color_display<=3'b011;
        #30 color_display<=3'b101;
        #30 color_display<=3'b110;
        #30 color_display<=3'b111;       
    end
    always #5  clk25 <= ~clk25;
    always #20 begin
        frame_pixel[11:8] <= frame_pixel[11:8] + 10;
        frame_pixel[7:4] <= frame_pixel[7:4] + 9;
        frame_pixel[3:0] <= frame_pixel[3:0] + 11;   
    end         
endmodule
