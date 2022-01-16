`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/07 17:20:26
// Design Name: 
// Module Name: mp3_tb
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

`timescale 1ps/1ps
module mp3_tb();
    reg clk;
    reg mp3_clk;
    reg DREQ;
    reg RST;
    reg [2:0] SONG_COL;
    reg NO_MUSIC;
    wire XDCS;
    wire XCS; 
    wire RSET; 
    wire SI;
    wire SCLK;
    mp3 #(.DELAY_TIME(0))
    uut(
        .clk(clk), 
        .mp3_clk(mp3_clk),
        .RST(RST), 
        .DREQ(DREQ),
        .SONG_COL(SONG_COL),
        .NO_MUSIC(NO_MUSIC),
        .XDCS(XDCS), 
        .XCS(XCS), 
        .RSET(RSET), 
        .SI(SI),
        .SCLK(SCLK)
    );  
    initial begin
        clk<=1;
        mp3_clk<=1;
        DREQ<=1;
        RST<=0;
        SONG_COL<=0;
        NO_MUSIC<=0;
        #10000 RST<=1;
    end
    always #100  clk <= ~clk;
    always #10000  mp3_clk <= ~mp3_clk;
    always #100000 SONG_COL  <= ~SONG_COL;
    always #500000 NO_MUSIC  <= ~NO_MUSIC;
endmodule
