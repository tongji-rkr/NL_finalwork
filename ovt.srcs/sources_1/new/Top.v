`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/01 10:46:57
// Design Name: 
// Module Name: Top
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


module Top(
    input clk100, //时钟CLK
    
     //摄像头配置及相关变量
    output SIOC, 
    output SIOD, 
    output RESET,
    output PWDN, 
    input VSYNC, 
    input HREF, 
    input PCLK,
    output XCLK, 
    input [7:0] D,   
                    
    //vga接口配置及相关变量
    output [3:0] vga_red,
    output [3:0] vga_green, 
    output [3:0] vga_blue, 
    output vga_hsync, 
    output vga_vsync,  
    input [2:0] color_display,
    input vga_grey,     //vga灰度图
    input vga_plate,    //vga底片

    //vs1003b接口配置及相关变量
    input DREQ,
    input[2:0] SONG_COL,//音乐选择    
    input NO_MUSIC,
    output XDCS, 
    output XCS,   
    output RSET, 
    output SI,   
    output SCLK,  
    
    input btn       //开始按钮
);
    wire resend;
    
    //摄像头地址及数据
    wire [18:0] capture_addr;       //摄像头输入地址 0-307200  
    wire [11:0] RGB444_data;        //处理完毕的rgb444图像
    wire [11:0] GREY_data;          //灰度图
    wire [11:0] DERGB444_data;      //底片
    wire [11:0] capture_data;
    
    //读取BRAM数据
    wire [18:0] frame_addr;         //vga像素点对应地址
    wire [11:0] frame_pixel;        //vga显示图片的rgb444
    wire [2:0] vga_color;           //是否显示某种颜色
    
    //控制
    wire start;                     
    wire config_finished;           //配置完毕信号
    wire capture_we;
    
    //时钟
    wire clk50;                     //50M
    wire clk25;                     //25M 
    wire mp3_clk;
    
    assign start = config_finished ? 0:1;
    assign vga_color=btn?color_display:3'b000;
    assign DERGB444_data={12{1'b1}}-RGB444_data;    //计算底片
    assign capture_data = vga_plate?DERGB444_data:(vga_grey?GREY_data:RGB444_data);
    
    //时钟处理
    clock_devider dev1(.clkin(clk100),.clkout(clk50));
    clock_devider dev2( .clkin(clk50),.clkout(clk25));
    clock_devider #(.Time(10)) dev_mp3(clk100, mp3_clk);
    
    //摄像头配置
    camera_config con1(
        .clk(clk50),
        .start(start),
        .sioc(SIOC),
        .siod(SIOD),
        .done(config_finished),
        .reset(RESET),
        .xclk(XCLK)
    ); 
    
    //处理摄像头数据
    camera_dataprocess datapro1(
        .pclk(PCLK),
        .vsync(VSYNC),
        .href(HREF),
        .d(D),
        .addr(capture_addr),
        .dout(RGB444_data),
        .dout_grey(GREY_data),
        .we(capture_we)
    );
    
    //vga显示
    vga vga1(
        .clk25(clk25),
        .vga_red(vga_red),
        .vga_green(vga_green),
        .vga_blue(vga_blue),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),
        .frame_addr(frame_addr),
        .frame_pixel(frame_pixel),
        .color_display(vga_color)
    );

    //BRAM存储
    BRAM bram(
      .clka(PCLK),    // input wire clka
      .wea(capture_we),      // input wire [0 : 0] wea
      .addra(capture_addr),  // input wire [18 : 0] addra
      .dina(capture_data),    // input wire [11 : 0] dina
      .clkb(clk50),    // input wire clkb
      .addrb(frame_addr),  // input wire [18 : 0] addrb
      .doutb(frame_pixel)  // output wire [11 : 0] doutb
    );
        
    //音乐播放
    mp3 MP3(
        .clk(clk100), 
        .mp3_clk(mp3_clk),
        .RST(btn), 
        .DREQ(DREQ),
        .SONG_COL(SONG_COL),
        .NO_MUSIC(NO_MUSIC),
        .XDCS(XDCS), 
        .XCS(XCS), 
        .RSET(RSET), 
        .SI(SI),
        .SCLK(SCLK)
    );  
endmodule
