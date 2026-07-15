class transaction;//Transaction

rand logic [7:0]data_in;

logic tx;
logic busy;
logic done;
logic [7:0] data_out;

function transaction copy();
copy=new();
copy.data_in=this.data_in;
copy.tx=this.tx;
copy.busy=this.busy;
copy.done=this.done;
copy.data_out=this.data_out;
endfunction;

function void display(input string tag);

        $display("------------------------------------------");
        $display("%s", tag);
        $display("Data In  = %0h", data_in);
        $display("TX       = %0b", tx);
        $display("Busy     = %0b", busy);
        $display("Done     = %0b", done);
        $display("Data Out = %0h", data_out);
        $display("------------------------------------------");

endfunction

endclass
