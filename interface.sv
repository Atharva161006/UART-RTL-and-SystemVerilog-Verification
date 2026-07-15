interface uart_if;//Interface


logic clk,rst;
logic tx_start;
logic [7:0]data_in;
logic[7:0]data_out;
logic tx;
logic busy,done;

clocking drv_cb @(posedge clk);
        
        output tx_start;
        output data_in;

        input tx;
        input busy;
        input done;
        input data_out;
endclocking

clocking mon_cb @(posedge clk);
        input rst;
        input tx_start;
        input data_in;
        input tx;
        input busy;
        input done;
        input data_out;
endclocking
endinterface
