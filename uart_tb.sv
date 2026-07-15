module tb;
uart_if vif();
initial 
    vif.clk=0;
    
always #10 vif.clk=~vif.clk;



top_module dut(
        .clk      (vif.clk),
        .rst      (vif.rst),
        .tx_start (vif.tx_start),
        .data_in  (vif.data_in),
        .tx       (vif.tx),
        .data_out (vif.data_out),
        .busy     (vif.busy),
        .done     (vif.done)
    );
    
environment env;
initial begin

env=new(vif);

vif.rst=1;
vif.tx_start=0;
vif.data_in=0;

repeat(5)@(posedge vif.clk);

vif.rst=0;

env.run();

end

initial begin
#5000000;
$finish;
end

endmodule
