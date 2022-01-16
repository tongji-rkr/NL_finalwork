`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/01 16:37:39
// Design Name: 
// Module Name: SCCB_sig
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


module SCCB_sig
#(
    parameter CLK_FREQ = 25000000, //25MCLK
    parameter SCCB_FREQ = 100000   //100k
)
(
    input clk,
    input start,
    input [7:0] address,
    input [7:0] data,
    output reg ready,
    output reg SIOC_oe,
    output reg SIOD_oe
);
    
    localparam CAMERA_ADDR = 8'h60;
    localparam FSM_IDLE = 0;
    localparam FSM_START_SIGNAL = 1;
    localparam FSM_LOAD_BYTE = 2;
    localparam FSM_TX_BYTE_1 = 3;
    localparam FSM_TX_BYTE_2 = 4;
    localparam FSM_TX_BYTE_3 = 5;
    localparam FSM_TX_BYTE_4 = 6;
    localparam FSM_END_SIGNAL_1 = 7;
    localparam FSM_END_SIGNAL_2 = 8;
    localparam FSM_END_SIGNAL_3 = 9;
    localparam FSM_END_SIGNAL_4 = 10;
    localparam FSM_DONE = 11;
    localparam FSM_TIMER = 12;
    
    reg [3:0] FSM_state = 0; 
    reg [3:0] FSM_return_state = 0;
    reg [31:0] timer = 0;
    reg [7:0] latched_address;
    reg [7:0] latched_data; 
    reg [1:0] byte_counter = 0;
    reg [7:0] tx_byte = 0;
    reg [3:0] byte_index = 0;
    
    initial begin 
        SIOC_oe = 0;
        SIOD_oe = 0;
        ready = 1;
    end
    
    //ע��SIOD_oe=1ʱ��siod=0;SIOC_oe=1ʱ��sioc=0.
    always@(posedge clk) begin
        case(FSM_state) 
            FSM_IDLE: begin
                byte_index <= 0;
                byte_counter <= 0;
                if (start) begin 
                    FSM_state <= FSM_START_SIGNAL;
                    latched_address <= address;
                    latched_data <= data;
                    ready <= 0;
                end
                else begin
                    ready <= 1;
                end
            end
            
            FSM_START_SIGNAL: begin //ͨѶ�ӿ������źţ�ʹSIOD����,SIOCΪ����̬ 
                FSM_state <= FSM_TIMER;
                FSM_return_state <= FSM_LOAD_BYTE;
                timer <= (CLK_FREQ/(4*SCCB_FREQ));
                SIOC_oe <= 0;
                SIOD_oe <= 1;
            end
            
            FSM_LOAD_BYTE: begin //������һ��Ҫ������ֽ�
                FSM_state <= (byte_counter == 3) ? FSM_END_SIGNAL_1 : FSM_TX_BYTE_1;
                byte_counter <= byte_counter + 1;
                byte_index <= 0;
                case(byte_counter)
                    0: tx_byte <= CAMERA_ADDR;
                    1: tx_byte <= latched_address;
                    2: tx_byte <= latched_data;
                    default: tx_byte <= latched_data;
                endcase
            end
            
            FSM_TX_BYTE_1: begin //����SIOC�����Ƴٵ���һ��state 
                FSM_state <= FSM_TIMER;
                FSM_return_state <= FSM_TX_BYTE_2;
                timer <= (CLK_FREQ/(4*SCCB_FREQ));
                SIOC_oe <= 1; 
            end
            
            FSM_TX_BYTE_2: begin //ָ���������
                FSM_state <= FSM_TIMER;
                FSM_return_state <= FSM_TX_BYTE_3;
                timer <= (CLK_FREQ/(4*SCCB_FREQ)); //SIOD�ȶ�ʱ���ӳ�
                SIOD_oe <= (byte_index == 8) ? 0 : ~tx_byte[7]; //����9�����ڵ�ack�����ʹ���źŷ�ת
            end
            
            FSM_TX_BYTE_3: begin // ʹSIOC����
                FSM_state <= FSM_TIMER;
                FSM_return_state <= FSM_TX_BYTE_4;
                timer <= (CLK_FREQ/(2*SCCB_FREQ));
                SIOC_oe <= 0; 
            end
            
            FSM_TX_BYTE_4: begin //����Ƿ����
                FSM_state <= (byte_index == 8) ? FSM_LOAD_BYTE : FSM_TX_BYTE_1;
                tx_byte <= tx_byte<<1; //��λ��һ������λ
                byte_index <= byte_index + 1;
            end
            
            FSM_END_SIGNAL_1: begin //����SIOC 
                FSM_state <= FSM_TIMER;
                FSM_return_state <= FSM_END_SIGNAL_2;
                timer <= (CLK_FREQ/(4*SCCB_FREQ));
                SIOC_oe <= 1;
            end
            
            FSM_END_SIGNAL_2: begin // ��SIOC���ʱ��ʹSIOD��� 
                FSM_state <= FSM_TIMER;
                FSM_return_state <= FSM_END_SIGNAL_3;
                timer <= (CLK_FREQ/(4*SCCB_FREQ));
                SIOD_oe <= 1;
            end
            
            FSM_END_SIGNAL_3: begin //����SIOC
                FSM_state <= FSM_TIMER;
                FSM_return_state <= FSM_END_SIGNAL_4;
                timer <= (CLK_FREQ/(4*SCCB_FREQ));
                SIOC_oe <= 0;
            end
            
            FSM_END_SIGNAL_4: begin // SIOC��ʱ��SIOD��
                FSM_state <= FSM_TIMER;
                FSM_return_state <= FSM_DONE;
                timer <= (CLK_FREQ/(4*SCCB_FREQ));
                SIOD_oe <= 0;
            end
            
            FSM_DONE: begin //�����ӳ�
                FSM_state <= FSM_TIMER;
                FSM_return_state <= FSM_IDLE;
                timer <= (2*CLK_FREQ/(SCCB_FREQ));
                byte_counter <= 0;
            end
            
            FSM_TIMER: begin //����ʱ��Ȼ����ת����һ��״̬
                FSM_state <= (timer == 0) ? FSM_return_state : FSM_TIMER;
                timer <= (timer==0) ? 0 : timer - 1;
            end
        endcase
    end    
endmodule
