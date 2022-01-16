`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/05 14:20:15
// Design Name: 
// Module Name: grey_cul
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


module grey_cul(
    input[15:0] data,
    output [11:0] grey
);
wire [7:0] R,G,B,rgb_grey;

//R 76,G 150,B 30
assign R={1'b0,1'b0,data[15],data[14],data[13],data[12],data[11]|data[15],data[15]|data[14]};
assign G={1'b0,data[10],data[9],data[8],data[7]|data[10],data[6]|data[9],data[5]|data[8],data[10]|data[7]};
assign B={1'b0,1'b0,1'b0,data[4],data[3],data[2],data[1],data[0]};
assign rgb_grey=R+G+B;
assign grey={3{rgb_grey[7:4]}};
endmodule
