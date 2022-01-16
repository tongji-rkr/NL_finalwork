`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/03 10:33:21
// Design Name: 
// Module Name: vga
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

module vga(
    input clk25,            //25M
	output [3:0] vga_red,   //四位红色
    output [3:0] vga_green, //四位绿色
    output [3:0] vga_blue,  //四位蓝色
    output reg vga_hsync,
    output reg vga_vsync,
    output [18:0] frame_addr,//对应地址
    input [11:0] frame_pixel,//输入信号
    input [2:0] color_display//颜色显示
);  
            
    parameter hRez = 640;
    parameter hStartSync = 640+16;
    parameter hEndSync = 640+16+96;
    parameter hMaxCount = 800;

    parameter vRez = 480;
    parameter vStartSync = 480+10;
    parameter vEndSync = 480+10+2;
    parameter vMaxCount = 480+10+2+33;

    parameter hsync_active = 0;
    parameter vsync_active = 0;
        
    reg unsigned[9:0] hCounter = {10{1'b0}};
    reg unsigned[9:0] vCounter = {10{1'b0}};
    reg unsigned[18:0] address = {19{1'b0}};
    reg [11:0] color;
    reg blank = 1;
        
    assign frame_addr=address;
    assign vga_red = color_display[2]?color[11:8]:{4{1'b0}};
    assign vga_green = color_display[1]?color[7:4]:{4{1'b0}};    
    assign vga_blue = color_display[0]?color[3:0]:{4{1'b0}};

    always @(posedge clk25) begin
        if (hCounter == hMaxCount-1)
            begin
                hCounter <= {10{1'b0}};
                if(vCounter == vMaxCount-1)
                    vCounter <= {10{1'b0}};
                else 
                    vCounter <= vCounter+1;
            end
        else 
            hCounter <= hCounter+1;  
        if(blank == 0)
            color   <= frame_pixel;
        else
            color   <= {12{1'b0}};
        if(vCounter >= vRez) begin
            address <= {19{1'b0}};
            blank <= 1;
        end
        else begin
            if(hCounter < 640) begin
                blank <= 0;
                address <= address+1'b1;
            end
            else begin
                blank <= 1;
            end
        end
        if(hCounter > hStartSync && hCounter <= hEndSync)
            vga_hsync <= hsync_active;
        else
            vga_hsync <= !hsync_active;
        if(vCounter >= vStartSync && vCounter < vEndSync)
            vga_vsync <= vsync_active;
        else
            vga_vsync <= !vsync_active;
    end
endmodule
