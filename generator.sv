class generator;//Generator

mailbox#(transaction)drv_mbx;
mailbox#(transaction)scb_mbx;

function new(mailbox#(transaction)drv_mbx,mailbox#(transaction)scb_mbx);
this.drv_mbx=drv_mbx;
this.scb_mbx=scb_mbx;
endfunction

task run();
transaction tr;
for(int i=0;i<8;i++)begin
tr=new();
assert(tr.randomize()) else $error("[GEN] :Randomization Failed");
$display("[GEN] data_in = %0h", tr.data_in);
tr.display("[GENERATOR]");
drv_mbx.put(tr.copy());
scb_mbx.put(tr.copy());
end
endtask
endclass
