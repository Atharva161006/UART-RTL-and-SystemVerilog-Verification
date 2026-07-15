`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2026 07:45:40
// Design Name: 
// Module Name: Receiver_module
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


module Receiver_module(
input clk, input rst,input rx_enb,input rx,output reg [7:0]data_out,output reg done);
parameter IDLE  = 3'd0;
parameter START = 3'd1;
parameter DATA  = 3'd2;
parameter STOP  = 3'd3;
parameter DONE  = 3'd4;

reg [2:0]state;
reg [3:0]sample_count;
reg[2:0]bit_count;

always@(posedge clk or posedge rst)begin
if(rst)begin
    state<=IDLE;
    sample_count<=4'b0;
    bit_count<=3'b0;
    data_out<=8'b0;
    done<=1'b0;
end
else
begin
    done<=1'b0;
case(state)

IDLE:
begin
    sample_count<=0;
    bit_count<=0;
    
    if(rx==1'b0)
        state<=START;
end

START:
begin
    if(rx_enb)begin
        sample_count<=sample_count+1;
        if(sample_count==4'd7)
            begin
            if(rx==1'b0)begin
                sample_count<=0;
                bit_count<=0;
                state<=DATA;
            end
            
        else
            state<=IDLE;
        end
    end
end

DATA:
begin
if(rx_enb)begin
    sample_count<=sample_count+1;
    
    if(sample_count==4'd15)begin
        sample_count<=0;
        data_out[bit_count]<=rx;
        
        if(bit_count==3'd7)
            state<=STOP;
        else 
            bit_count<=bit_count+1;
     end
 end
 end
 
STOP:
begin
if(rx_enb)begin
    sample_count <= sample_count + 1;

    if(sample_count == 4'd15)begin
        sample_count <= 0;

        if(rx == 1'b1)
            state <= DONE;
        else
            state <= IDLE;
    end
end
end

DONE:
begin
done<=1'b1;
state<=IDLE;
end

default:
    state<=IDLE;
    
endcase
end
end
    


    

    
endmodule
