`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 18:48:33
// Design Name: 
// Module Name: transmitter_module
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


module transmitter_module(
input rst ,input clk,input tx_start,input tx_enb,input  [7:0]data_in,output reg tx,output reg busy
    );
reg [2:0]state;
reg [7:0]data_reg;
reg[2:0]bit_count;

parameter IDLE  = 3'd0;
parameter START = 3'd1;
parameter DATA  = 3'd2;
parameter STOP  = 3'd3;
parameter DONE  = 3'd4;

always@(posedge clk or posedge rst)begin
if(rst)
begin
    state<= IDLE;
    tx<=1'b1;
    busy<=1'b0;
    bit_count<=0;
    end
else 
begin
case(state)
IDLE:
begin
    tx<=1;
    busy<=0;
    if(tx_start)begin
        data_reg<=data_in;
        state<=START;
        busy<=1;
    end   
end
START:
begin
    tx<=0;
    if(tx_enb)begin
        bit_count<=0;
        state<=DATA;
    end
end
DATA:
begin
    tx<=data_reg[bit_count];
    if(tx_enb)begin
        if(bit_count==7)
            state<=STOP;
        else 
            bit_count<=bit_count+1;
    end
end
STOP:
begin
    tx<=1;
    if(tx_enb)
        state<=DONE;
end
DONE:
begin
    busy<=0;
    state<=IDLE;
end
default:
state<=IDLE;

endcase
end
end
    

endmodule
