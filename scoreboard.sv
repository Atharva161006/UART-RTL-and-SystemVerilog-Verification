class scoreboard;//Scoreboard
mailbox#(transaction)gen_mbx;
mailbox#(transaction)mon_mbx;

function new(mailbox #(transaction) gen_mbx,
                 mailbox #(transaction) mon_mbx);

        this.gen_mbx = gen_mbx;
        this.mon_mbx = mon_mbx;

endfunction

task run();
transaction exp;
transaction act;
forever begin

gen_mbx.get(exp);
mon_mbx.get(act);
if(exp.data_in == act.data_out)
   $display("[SCB] PASS");

else
   $display("[SCB] FAIL");
end
endtask
endclass
