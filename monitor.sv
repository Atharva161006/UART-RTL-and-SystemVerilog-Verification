class monitor;//Monitor
virtual uart_if vif;
mailbox#(transaction)mbx;

function new(input mailbox#(transaction)mbx,input virtual uart_if vif);
this.mbx=mbx;
this.vif=vif;
endfunction

task run();
transaction tr;
forever begin
@(vif.mon_cb);

wait(vif.mon_cb.done==1);
tr=new();
tr.tx= vif.mon_cb.tx;
tr.busy = vif.mon_cb.busy;
tr.done = vif.mon_cb.done;
tr.data_out = vif.mon_cb.data_out;
tr.display("[MONITOR]");
$display("[MON] data_out = %0h", tr.data_out);
mbx.put(tr);

end
endtask
endclass
