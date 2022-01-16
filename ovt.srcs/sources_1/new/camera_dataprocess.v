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
    input pclk,                     //ov2640ʱ��pclk
    input vsync,                    //��ͬ���ź�
    input href,                     //��ͬ���ź�
    input[7:0] d,                   //����ͷ��������
    output[18:0] addr,              //BRAM��ַλ
    output reg[11:0] dout,          //48bitRGB444ͼ
    output [11:0] dout_grey,        //48bit�Ҷ�ͼ
    output reg we                   //����д����Ч�ź�
);

    reg [15:0] d_latch;
    reg [18:0] address;
    reg [18:0] address_next; 
    reg [1:0] wr_hold;   
    wire valid;
    //�Ҷ�ͼ���ݼ���
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
            wr_hold <= {wr_hold[0] , (href &&(!wr_hold[0]))};   //�Ƿ���������ֽھ�����λ״̬���������ֽڴ����ֹͣ����
            d_latch <= {d_latch[7:0] , d};                      //d��d_latch[7:0]���һ��16λ��d_latch
            if (wr_hold[1] == 1 )begin
                address_next <= address_next+1;      
                dout  <= {d_latch[15:12],d_latch[10:7],d_latch[4:1]};//����rgb444���
            end
        end
    end
endmodule
