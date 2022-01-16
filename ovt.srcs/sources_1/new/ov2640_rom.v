`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/01 16:02:01
// Design Name: 
// Module Name: ov2640_rom
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


module ov2640_rom(
    input wire clk,
    input wire [7:0] addr,
    output reg [15:0] dout
);
    //ov2640的rom初始化
    always @(posedge clk) begin
        case(addr) 
            8'h00: dout <= 16'hff_01;
            8'h01: dout <= 16'h12_80;
            8'h02: dout <= 16'hff_f0;
            8'h03: dout <= 16'hff_00;
            8'h04: dout <= 16'h2c_ff;
            8'h05: dout <= 16'h2e_df;
            8'h06: dout <= 16'hff_01;
            8'h07: dout <= 16'h3c_32;
            8'h08: dout <= 16'h11_01;
            8'h09: dout <= 16'h09_02;
            8'h0A: dout <= 16'h04_20;
            8'h0B: dout <= 16'h13_e5;
            8'h0C: dout <= 16'h14_48;
            8'h0D: dout <= 16'h2c_0c;
            8'h0E: dout <= 16'h33_78;
            8'h0F: dout <= 16'h3a_33;
            8'h10: dout <= 16'h3b_fB;
            8'h11: dout <= 16'h3e_00;
            8'h12: dout <= 16'h43_11;
            8'h13: dout <= 16'h16_10;
            8'h14: dout <= 16'h39_92;
            8'h15: dout <= 16'h35_da;
            8'h16: dout <= 16'h22_1a;
            8'h17: dout <= 16'h37_c3;
            8'h18: dout <= 16'h23_00;
            8'h19: dout <= 16'h34_c0;
            8'h1A: dout <= 16'h36_1a;
            8'h1B: dout <= 16'h06_88;
            8'h1C: dout <= 16'h07_c0;
            8'h1D: dout <= 16'h0d_87;
            8'h1E: dout <= 16'h0e_41;
            8'h1F: dout <= 16'h4c_00;
            8'h20: dout <= 16'h48_00;
            8'h21: dout <= 16'h5B_00;
            8'h22: dout <= 16'h42_03;
            8'h23: dout <= 16'h4a_81;
            8'h24: dout <= 16'h21_99;
            8'h25: dout <= 16'h24_40;
            8'h26: dout <= 16'h25_38;
            8'h27: dout <= 16'h26_82;
            8'h28: dout <= 16'h5c_00;
            8'h29: dout <= 16'h63_00;
            8'h2A: dout <= 16'h46_00;
            8'h2B: dout <= 16'h0c_3c;
            8'h2C: dout <= 16'h61_70;
            8'h2D: dout <= 16'h62_80;
            8'h2E: dout <= 16'h7c_05;
            8'h2F: dout <= 16'h20_80;
            8'h30: dout <= 16'h28_30;
            8'h31: dout <= 16'h6c_00;
            8'h32: dout <= 16'h6d_80;
            8'h33: dout <= 16'h6e_00;
            8'h34: dout <= 16'h70_02;
            8'h35: dout <= 16'h71_94;
            8'h36: dout <= 16'h73_c1;
            8'h37: dout <= 16'h12_40;
            8'h38: dout <= 16'h17_11;        
            8'h39: dout <= 16'h18_39;        
            8'h3A: dout <= 16'h19_00;        
            8'h3B: dout <= 16'h1a_3C;        
            8'h3C: dout <= 16'h32_09;        
            8'h3D: dout <= 16'h37_c0;
            8'h3E: dout <= 16'h4f_ca;
            8'h3F: dout <= 16'h50_a8;
            8'h40: dout <= 16'h5a_23;
            8'h41: dout <= 16'h6d_00;
            8'h42: dout <= 16'h3d_38;
            8'h43: dout <= 16'hff_00;
            8'h44: dout <= 16'he5_7f;
            8'h45: dout <= 16'hf9_c0;
            8'h46: dout <= 16'h41_24;
            8'h47: dout <= 16'he0_14;
            8'h48: dout <= 16'h76_ff;
            8'h49: dout <= 16'h33_a0;
            8'h4A: dout <= 16'h42_20;
            8'h4B: dout <= 16'h43_18;
            8'h4C: dout <= 16'h4c_00;
            8'h4D: dout <= 16'h87_d5;
            8'h4E: dout <= 16'h88_3f;
            8'h4F: dout <= 16'hd7_03;
            8'h50: dout <= 16'hd9_10;
            8'h51: dout <= 16'hd3_82;
            8'h52: dout <= 16'hc8_08;
            8'h53: dout <= 16'hc9_80;
            8'h54: dout <= 16'h7c_00;
            8'h55: dout <= 16'h7d_00;
            8'h56: dout <= 16'h7c_03;
            8'h57: dout <= 16'h7d_48;
            8'h58: dout <= 16'h7d_48;
            8'h59: dout <= 16'h7c_08;
            8'h5A: dout <= 16'h7d_20;
            8'h5B: dout <= 16'h7d_10;
            8'h5C: dout <= 16'h7d_0e;
            8'h5D: dout <= 16'h90_00;
            8'h5E: dout <= 16'h91_0e;
            8'h5F: dout <= 16'h91_1a;
            8'h60: dout <= 16'h91_31;
            8'h61: dout <= 16'h91_5a;
            8'h62: dout <= 16'h91_69;
            8'h63: dout <= 16'h91_75;
            8'h64: dout <= 16'h91_7e;
            8'h65: dout <= 16'h91_88;
            8'h66: dout <= 16'h91_8f;
            8'h67: dout <= 16'h91_96;
            8'h68: dout <= 16'h91_a3;
            8'h69: dout <= 16'h91_af;
            8'h6A: dout <= 16'h91_c4;
            8'h6B: dout <= 16'h91_d7;
            8'h6C: dout <= 16'h91_e8;
            8'h6D: dout <= 16'h91_20;
            8'h6E: dout <= 16'h92_00;
            8'h6F: dout <= 16'h93_06;
            8'h70: dout <= 16'h93_e3;
            8'h71: dout <= 16'h93_05;
            8'h72: dout <= 16'h93_05;
            8'h73: dout <= 16'h93_00;
            8'h74: dout <= 16'h93_04;
            8'h75: dout <= 16'h93_00;
            8'h76: dout <= 16'h93_00;
            8'h77: dout <= 16'h93_00;
            8'h78: dout <= 16'h93_00;
            8'h79: dout <= 16'h93_00;
            8'h7A: dout <= 16'h93_00;
            8'h7B: dout <= 16'h93_00;
            8'h7C: dout <= 16'h96_00;
            8'h7D: dout <= 16'h97_08;
            8'h7E: dout <= 16'h97_19;
            8'h7F: dout <= 16'h97_02;
            8'h80: dout <= 16'h97_0c;
            8'h81: dout <= 16'h97_24;
            8'h82: dout <= 16'h97_30;
            8'h83: dout <= 16'h97_28;
            8'h84: dout <= 16'h97_26;
            8'h85: dout <= 16'h97_02;
            8'h86: dout <= 16'h97_98;
            8'h87: dout <= 16'h97_80;
            8'h88: dout <= 16'h97_00;
            8'h89: dout <= 16'h97_00;
            8'h8A: dout <= 16'hc3_ed;
            8'h8B: dout <= 16'ha4_00;
            8'h8C: dout <= 16'ha8_00;
            8'h8D: dout <= 16'hc5_11;
            8'h8E: dout <= 16'hc6_51;
            8'h8F: dout <= 16'hbf_80;
            8'h90: dout <= 16'hc7_10;
            8'h91: dout <= 16'hb6_66;
            8'h92: dout <= 16'hb8_A5;
            8'h93: dout <= 16'hb7_64;
            8'h94: dout <= 16'hb9_7C;
            8'h95: dout <= 16'hb3_af;
            8'h96: dout <= 16'hb4_97;
            8'h97: dout <= 16'hb5_FF;
            8'h98: dout <= 16'hb0_C5;
            8'h99: dout <= 16'hb1_94;
            8'h9A: dout <= 16'hb2_0f;
            8'h9B: dout <= 16'hc4_5c;
            8'h9C: dout <= 16'hc0_50;  
            8'h9D: dout <= 16'hc1_3C;   
            8'h9E: dout <= 16'h8c_00;  
            8'h9F: dout <= 16'h86_3D;
            8'hA0: dout <= 16'h50_00;
            8'hA1: dout <= 16'h51_A0;
            8'hA2: dout <= 16'h52_78;
            8'hA3: dout <= 16'h53_00;
            8'hA4: dout <= 16'h54_00;
            8'hA5: dout <= 16'h55_00;            
            8'hA6: dout <= 16'h5a_A0;        
            8'hA7: dout <= 16'h5b_78;        
            8'hA8: dout <= 16'h5c_00;       
            8'hA9: dout <= 16'hd3_82;
            8'hAA: dout <= 16'hc3_ed;
            8'hAB: dout <= 16'h7f_00;
            8'hAC: dout <= 16'hda_08;
            8'hAD: dout <= 16'he5_1f;
            8'hAE: dout <= 16'he1_67;
            8'hAF: dout <= 16'he0_00;
            8'hB0: dout <= 16'hdd_7f;
            8'hB1: dout <= 16'h05_00;
            default: dout <= 16'hFFFF;//结束
        endcase
    end
endmodule
