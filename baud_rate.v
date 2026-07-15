`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2026 12:29:39
// Design Name: 
// Module Name: baud_rate
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


module baud_rate(
input clk,output tx_enb,output rx_enb
    );
    reg [12:0]tx_counter;
    reg [9:0]rx_counter;
    
    initial begin
    tx_counter = 0;
    rx_counter = 0;
    end
    
    always@(posedge clk)begin
    if(tx_counter==5208)
        tx_counter<=0;
    else 
        tx_counter<=tx_counter+1'b1;
    end
    
    always@(posedge clk)begin
    if(rx_counter==325)
        rx_counter<=0;
    else 
        rx_counter<=rx_counter+1'b1;
    end
    
    assign tx_enb= (tx_counter==0)?1'b1:1'b0;
    assign rx_enb= (rx_counter==0)?1'b1:1'b0;
    
    
endmodule
