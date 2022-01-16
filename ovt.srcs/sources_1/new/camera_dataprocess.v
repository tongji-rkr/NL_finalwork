`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/02 11:10:45
// Design Name: 
// Module Name: camera_dataprocess
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


module camera_dataprocess(
    input pclk,                     //ov2640时钟pclk
    input vsync,                    //场同步信号
    input href,                     //行同步信号
    input[7:0] d,                   //摄像头传入数据
    output[18:0] addr,              //BRAM地址位
    output reg[11:0] dout,          //48bitRGB444图
    output [11:0] dout_grey,        //48bit灰度图
    output reg we                   //传出写入有效信号
);

    reg [15:0] d_latch;
    reg [18:0] address;
    reg [18:0] address_next; 
    reg [1:0] wr_hold;   
    wire valid;
    //灰度图数据计算
    grey_cul cul(.data(d_latch),.grey(dout_grey));
     
    assign addr = address;
    
    initial begin
        d_latch = 16'b0;
        address = 19'b0;
        address_next = 19'b0;
        wr_hold = 2'b0;
        dout = 12'b0;
    end
    
    always@(posedge pclk)
    begin
        if(vsync == 0) begin
            address <= 19'b0;
            address_next <= 19'b0;
            wr_hold <= 2'b0;
            we <= 0;
        end
        else begin
            address <= address_next;
            we <= wr_hold[1];
            wr_hold <= {wr_hold[0] , (href &&(!wr_hold[0]))};   //是否读到了新字节决定低位状态，两次新字节传入间停止储存
            d_latch <= {d_latch[7:0] , d};                      //d和d_latch[7:0]组成一个16位的d_latch
            if (wr_hold[1] == 1 )begin
                address_next <= address_next+1;      
                dout  <= {d_latch[15:12],d_latch[10:7],d_latch[4:1]};//正常rgb444输出
            end
        end
    end
endmodule
