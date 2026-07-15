class environment;

generator gen;
driver drv;
monitor mon;
scoreboard scb;


mailbox#(transaction)gen_drv_mbx;
mailbox#(transaction)gen_scb_mbx;
mailbox#(transaction)mon_scb_mbx;

virtual uart_if vif;

function new(virtual uart_if vif);

this.vif=vif;

gen_drv_mbx=new();
gen_scb_mbx=new();
mon_scb_mbx=new();

gen=new(gen_drv_mbx,gen_scb_mbx);
drv=new(gen_drv_mbx,vif);
mon=new(mon_scb_mbx,vif);
scb=new(gen_scb_mbx,mon_scb_mbx);

endfunction

task run();
fork
    gen.run();
    drv.run();
    mon.run();
    scb.run();
join_none

endtask
endclass
