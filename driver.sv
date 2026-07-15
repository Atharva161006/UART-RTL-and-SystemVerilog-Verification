class driver;//Driver
virtual uart_if vif;
mailbox#(transaction)mbx;

function new(input mailbox#(transaction)mbx,input virtual uart_if vif);
this.mbx=mbx;
this.vif=vif;
endfunction

task run();
transaction tr;
@(vif.drv_cb);
vif.drv_cb.tx_start <= 0;
vif.drv_cb.data_in  <= 8'h00;
forever begin

mbx.get(tr);
//wait(vif.drv_cb.busy==0);
vif.drv_cb.data_in<=tr.data_in;
@(vif.drv_cb);
vif.drv_cb.tx_start <= 1;
@(vif.drv_cb);

vif.drv_cb.tx_start <= 0;
tr.display("[DRIVER]");
$display("[DRV] data_in = %0h", tr.data_in);
wait(vif.busy == 1);
wait(vif.busy == 0);

end
endtask
endclass
