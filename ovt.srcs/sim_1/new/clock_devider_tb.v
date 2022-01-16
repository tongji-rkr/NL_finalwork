`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/07 16:48:50
// Design Name: 
// Module Name: clock_devider_tb
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
module clock_devider_tb();
    reg clkin;
    wire clkout;
    clock_devider dev(
        .clkin(clkin),
        .clkout(clkout)
    );
    initial clkin=1;
    always #10  clkin <= ~clkin;
endmodule

