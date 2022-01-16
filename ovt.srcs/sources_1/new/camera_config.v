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
   input clk,     //clk50MHZʱ��
   input start,   //start�ź����߿�ʼ��������ͷ
   output sioc,   //sioc������ͷʱ������
   output siod,   //siod������ͷ��������
   output done,    //doneΪ1ʱ��ʾ����ͷ�������
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
   
   //������������ͷ����Ϣ��rom_addrΪ�Ĵ�����ַ��rom_doutΪ��ӦҪ���õ�ֵ
   ov2640_rom rom1(
       .clk(clk),
       .addr(rom_addr),
       .dout(rom_dout)
   );
   
   //��ȡ����������ϢתΪ�ӻ���ַ+ �Ĵ�����ַ+���ݵ���ʽ������������һ��֮��������һ��
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
   
   //��SCCB������Ϣ��Э�鷽ʽ���䣬����sccbʱ���źź������ź�
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