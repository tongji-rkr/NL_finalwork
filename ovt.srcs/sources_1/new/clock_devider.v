`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/02 21:20:01
// Design Name: 
// Module Name: clock_devider
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


module clock_devider#(parameter Time=2)//时钟周期是原周期的Time倍
(
    input clkin,
    output reg clkout
);
    integer counter=0;
    initial clkout = 0;
    always @ (posedge clkin)
    begin
        if((counter+1)==Time/2)
        begin
            counter <= 0;
            clkout <= ~clkout;
        end
        else
            counter <= counter+1;
    end
endmodule