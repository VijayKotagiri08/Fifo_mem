interface intfc(input bit wclk, rclk, w_rst_n, r_rst_n);
parameter depth=256, data_width=8, ptr_width=8;
parameter wclk_width=4;
parameter rclk_width=10;
logic w_en, r_en;
logic [ptr_width:0] rptr_sync, wptr_sync, waddr, wptr,raddr, rptr;
bit full, empty;
logic [data_width-1:0] data_in,data_out;
logic  [data_width-1:0] wdata_q[$],rdata;
		
endinterface
