`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2026 08:36:00
// Design Name: 
// Module Name: top_module
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


module top_module(
input clk,input rst,input tx_start,input [7:0]data_in,output tx,output[7:0]data_out,output busy,output done
    );
    
wire tx_enb;
wire rx_enb;

baud_rate baud_gen(.clk(clk),.tx_enb(tx_enb),.rx_enb(rx_enb));

transmitter_module transmitter(.rst(rst),.clk(clk),.tx_start(tx_start),.tx_enb(tx_enb),.data_in(data_in),.tx(tx),.busy(busy));

Receiver_module receiver(.clk(clk),.rst(rst),.rx(tx),.rx_enb(rx_enb),.data_out(data_out),.done(done));

endmodule
