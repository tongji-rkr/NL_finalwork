`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/07 19:18:32
// Design Name: 
// Module Name: camera_dataprocess_tb
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
module camera_dataprocess_tb();
    reg pclk;
    reg vsync;                    //场同步信号
    reg href;                     //行同步信号
    reg [7:0] d;                   //摄像头传入数据
    wire[18:0] addr;              //BRAM地址位
    wire[11:0] dout;          //48bitRGB444图
    wire [11:0] dout_grey;        //48bit灰度图
    wire we;                  //传出写入有效信号
    camera_dataprocess uut(
        .pclk(pclk),
        .vsync(vsync),
        .href(href),
        .d(d),
        .addr(addr),
        .dout(dout),
        .dout_grey(dout_grey),
        .we(we)
    );
    initial begin
        pclk<=1;
        vsync<=1;
        href<=1;
        d<=8'b0;
    end
    always #10  pclk <= ~pclk;
    always #100  vsync <= ~vsync;
    always #50  href <= ~href;
    always #20  d <= ~d+7;
endmodule
