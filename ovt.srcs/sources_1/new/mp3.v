`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/04 11:10:45
// Design Name: 
// Module Name: mp3
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


module mp3
#(
    parameter CMD_NUM=2,
    parameter DELAY_TIME=500000
)
(
	input clk,
	input mp3_clk,
	input DREQ,
	input RST, 
	input [2:0] SONG_COL,
	input NO_MUSIC,
	output reg XDCS, 
	output reg XCS,  
	output reg RSET, 
	output reg SI, 
	output reg SCLK
);
	//mp3状态
	localparam CMD_PRE = 0;
	localparam WRITE_CMD = 1;
	localparam DATA_PRE = 2;
	localparam WRITE_DATA = 3;
	localparam DELAY = 4;
	reg [2: 0] state;
		
	//目前选择的歌曲
	reg[2: 0] cur=3'b00;
	
	// IP核
    reg[11:0] addr;
	wire [15: 0] Dout0,Dout1,Dout2,Dout3,Data;
    reg [15: 0] _Data;
    
    blk_mem_gen_0 music0(.clka(clk),.ena(1),.addra(addr),.douta(Dout0));
    blk_mem_gen_1 music1(.clka(clk),.ena(1),.addra(addr),.douta(Dout1));    
    blk_mem_gen_2 music2(.clka(clk),.ena(1),.addra(addr),.douta(Dout2));
    blk_mem_gen_3 music3(.clka(clk),.ena(1),.addra(addr),.douta(Dout3)); 
    assign Data=NO_MUSIC?{16{1'b0}}:(SONG_COL[2]?Dout3:(SONG_COL[1]?Dout2:(SONG_COL[0]?Dout1:Dout0)));
	
    //复位寄存器
    reg [63: 0] cmd = {32'h02000804, 32'h020B0000};
    reg [2: 0] cmd_cnt = 0;
        
    //计数
    integer delay_cnt = 0;
    integer cnt = 0;
        
    always @ (posedge mp3_clk) begin
        if(!RST||cur!=SONG_COL) begin
            cur<=SONG_COL;
            RSET <= 0;
            SCLK <= 0;
            XCS <= 1;
            XDCS <= 1;
            delay_cnt <= 0;
            state <= DELAY;
            cmd_cnt <= 0;
            addr <= 0;
        end 
        else begin 
            case (state)
                CMD_PRE: begin 
                    SCLK <= 0;
                    if(cmd_cnt == CMD_NUM) begin
                        state <= DATA_PRE;
                    end
                    else if(DREQ) begin 
                        state <= WRITE_CMD;
                        cnt <= 0;
                    end 
                end
                    
                WRITE_CMD: begin 
                    if(DREQ) begin
                        if(clk) begin 
                            if(cnt==32) begin
                                cmd_cnt <= cmd_cnt+1;
                                XCS <= 1;
                                state <= CMD_PRE;
                                cnt <= 0;
                            end 
                            else begin
                                XCS <= 0;
                                SI <= cmd[63];
                                cmd <= {cmd[62: 0], cmd[63]};
                                cnt <= cnt+1;
                            end 
                        end 
                        SCLK <= ~SCLK;
                    end 
                end
                
                DATA_PRE: begin
                    if(DREQ) begin 
                        SCLK <= 0;
                        state <= WRITE_DATA;
                        _Data <= Data;
                        cnt <= 0;
                    end 
                end
                         
                WRITE_DATA: begin 
                    if(SCLK) begin 
                        if(cnt == 16) begin 
                            XDCS <= 1;
                            addr <= addr+1;
                            state <= DATA_PRE;
                            end 
                    else begin 
                        XDCS <= 0;
                        SI <= _Data[15];
                        _Data <= {_Data[14:0], _Data[15]};
                        cnt <= cnt+1;
                        end 
                    end 
                    SCLK = ~SCLK;
                end
                 
                DELAY: begin 
                    if(delay_cnt == DELAY_TIME) begin 
			            delay_cnt <= 0;
                        state <= CMD_PRE;
                        RSET <= 1;
                    end 
                    else begin
						delay_cnt <= delay_cnt+1;
				    end
                end    
            endcase
        end
    end 
endmodule