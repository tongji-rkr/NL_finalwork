`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/01 16:06:23
// Design Name: 
// Module Name: ov2640_config
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


module ov2640_config
#(
    parameter CLK_FREQ = 25000000
)
(
    input wire clk,
    input wire SCCB_ready,
    input wire [15:0] rom_data,
    input wire start,
    output reg [7:0] rom_addr,
    output reg done,
    output reg [7:0] SCCB_addr,
    output reg [7:0] SCCB_data,
    output reg SCCB_start
);
    
    initial begin
        rom_addr = 0;
        done = 0;
        SCCB_addr = 0;
        SCCB_data = 0;
        SCCB_start = 0;
    end
    
    localparam FSM_IDLE = 0;
    localparam FSM_SEND_CMD = 1;
    localparam FSM_TIMER = 2;
    reg [2:0] FSM_state = FSM_IDLE;
    reg [31:0] timer = 0; 
    
    always@(posedge clk) begin
        case(FSM_state)
            FSM_IDLE: begin 
                FSM_state <= start ? FSM_SEND_CMD : FSM_IDLE;
                rom_addr <= 0;
                done <= start ? 0 : done;
            end
            
            FSM_SEND_CMD: begin 
                case(rom_data)
                    16'hFFFF: begin //ROMÅäÖÃ½áÊø
                        done<=1;
                        FSM_state <= FSM_IDLE;
                    end
                    
                    16'hFFF0: begin  
                        timer <= (CLK_FREQ/200); //5 msµÄÑÓ³Ù
                        FSM_state <= FSM_TIMER;
                        rom_addr <= rom_addr + 1;
                    end
                    
                    default: begin 
                        if (SCCB_ready) begin
                            FSM_state <= FSM_TIMER;
                            timer <= 0; 
                            rom_addr <= rom_addr + 1;
                            SCCB_addr <= rom_data[15:8];
                            SCCB_data <= rom_data[7:0];
                            SCCB_start <= 1;
                        end
                    end
                endcase
            end
                               
            FSM_TIMER: begin //ÑÓ³Ù¼ÆÊ±
                FSM_state <= (timer == 0) ? FSM_SEND_CMD : FSM_TIMER;
                timer <= (timer==0) ? 0 : timer - 1;
                SCCB_start <= 0;
            end
        endcase
    end
endmodule
