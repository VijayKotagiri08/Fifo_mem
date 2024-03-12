module tb;

parameter depth=256;
parameter data_width=8;
parameter ptr_width=8;

bit wclk,rclk;
logic w_rst_n,r_rst_n;
logic w_en, r_en;
logic [ptr_width:0] rptr_sync, wptr_sync, waddr, wptr,raddr, rptr;
bit full, empty;
logic [data_width-1:0] data_in,data_out;
logic  [data_width-1:0] wdata_q[$],rdata;


always #5 rclk=~rclk;
always #2 wclk=~wclk;


intfc i_tb(.wclk(wclk), .rclk(rclk));
top  #(.depth(depth), .data_width(data_width), .ptr_width(ptr_width))top1(  .i1(i_tb ));




initial 
begin
i_tb.wclk='1;
i_tb.rclk='1;
i_tb.cbw.w_en=1'b0;
i_tb.data_in='0;
i_tb.w_rst_n=0;
i_tb.r_rst_n=0;
i_tb.cbr.r_en=0;
@(posedge i_tb.wclk);
$display(" ***************************************************************************************************************************");
$display("checking full and empty at the begining without writing anything into the fifo....full=%d, empty=%d, time=%0d,",top1.i1.full,i_tb.empty,$time);

	i_tb.w_rst_n=1'b1;
	i_tb.cbw.w_en=1'b1;
	i_tb.r_rst_n = 1'b1;
	for(int i=0; i<256;i++) 
		begin
			@(posedge i_tb.wclk); 	
			if (i_tb.cbw.w_en) 
			begin
				i_tb.data_in = $urandom_range(0,256);
				wdata_q.push_back(i_tb.data_in);
			end
			$display("checking write .... data_in=%d, waddr=%d,wptr=%d, time=%0d",top1.i1.data_in,i_tb.waddr,i_tb.wptr,$time);
			
			
		end
	@(posedge i_tb.wclk);
	@(posedge i_tb.wclk);
    $display(" checking full and empty at the after  writing  into the fifo....full=%d, empty=%d,time=%0d",i_tb.full,i_tb.empty,$time);
   i_tb.cbr.r_en=1;
   i_tb.cbw.w_en=1'b0;
	for (int i=0; i<256; i++) 
		begin
			@(posedge i_tb.rclk);
            if (i_tb.cbr.r_en) 
		    begin
				rdata = wdata_q.pop_front();
			end
			$display("checking read.. raddr = %d,data_out = %d, time=%0d",i_tb.raddr, rdata,$time);
		end
	@(posedge i_tb.rclk);
	@(posedge i_tb.rclk);
	$display(" checking full and empty at the after reading and writing into the fifo....full=%d, empty=%d,time=%0d",i_tb.full,i_tb.empty,$time); 
    $finish;
 end
  
 endmodule