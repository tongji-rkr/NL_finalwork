`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/01 16:06:23
// Design Name: 
// Module Name: camera_config
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


module camera_config
#(
    parameter CLK_FREQ = 25000000
)
(
   input clk,     //clk50MHZ时钟
   input start,   //start信号拉高开始配置摄像头
   output sioc,   //sioc接摄像头时钟总线
   output siod,   //siod接摄像头数据总线
   output done,    //done为1时表示摄像头配置完毕
   output xclk,
   output reset
);
   
   wire [7:0] rom_addr;
   wire [15:0] rom_dout;
   wire [7:0] SCCB_addr;
   wire [7:0] SCCB_data;
   wire SCCB_start;
   wire SCCB_ready;
   wire SIOC_oe;
   wire SIOD_oe;
   
   assign sioc = SIOC_oe ? 1'b0 : 1'bZ;
   assign siod = SIOD_oe ? 1'b0 : 1'bZ;
   assign reset = 1;
   clock_devider dev3(.clkin(clk),.clkout(xclk));
   
   //储存配置摄像头的信息，rom_addr为寄存器地址，rom_dout为相应要配置的值
   ov2640_rom rom1(
       .clk(clk),
       .addr(rom_addr),
       .dout(rom_dout)
   );
   
   //将取出的配置信息转为从机地址+ 寄存器地址+数据的形式，控制配置完一项之后配置下一项
   ov2640_config #(.CLK_FREQ(CLK_FREQ)) config_1(
       .clk(clk),
       .SCCB_ready(SCCB_ready),
       .rom_data(rom_dout),
       .start(start),
       .rom_addr(rom_addr),
       .done(done),
       .SCCB_addr(SCCB_addr),
       .SCCB_data(SCCB_data),
       .SCCB_start(SCCB_start)
   );
   
   //将SCCB传输信息按协议方式传输，制造sccb时钟信号和数据信号
   SCCB_sig #( .CLK_FREQ(CLK_FREQ)) SCCB1(
       .clk(clk),
       .start(SCCB_start),
       .address(SCCB_addr),
       .data(SCCB_data),
       .ready(SCCB_ready),
       .SIOC_oe(SIOC_oe),
       .SIOD_oe(SIOD_oe)
   );
   
endmodule    