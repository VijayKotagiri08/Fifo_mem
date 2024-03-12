module top #(parameter depth=256, data_width=8,ptr_width=8) (intfc i1 );


// input bit wclk,rclk,r_rst_n,w_rst_n,w_en,r_en;
// input logic [data_width-1:0] data_in;
// output bit full,empty;
// output logic [data_width-1:0] data_out;
// logic [ptr_width:0] rptr_sync, wptr_sync, waddr, wptr,raddr, rptr;

//wclk,rclk,r_rst_n,w_rst_n,w_en,r_en, data_in, full,empty,  data_out

//2 flop sunchronizers
w2rsync #(ptr_width) w2rsync_inst(i1.rclk,  i1.r_rst_n,  i1.wptr ,  i1.wptr_sync );
r2wsync #(ptr_width) r2wsync_inst(i1.wclk, i1.w_rst_n, i1.rptr,  i1.rptr_sync );

//write point handler
write_ptr #(ptr_width) write_ptr_inst (i1.wclk, i1.w_rst_n, i1.w_en,  i1.rptr_sync,  i1.waddr, i1.wptr, i1.full);

//read point handler
read_ptr #(ptr_width) read_ptr_inst (i1.rclk, i1.r_rst_n, i1.r_en,   i1.wptr_sync,  i1.raddr, i1.rptr,  i1.empty);

//fifo memory
fifo_mem #(data_width,ptr_width,depth) fifo_mem_inst (i1.wclk,i1.rclk,i1.r_rst_n,i1.w_rst_n,i1.w_en,i1.r_en,i1.full,i1.empty, i1.data_in,  i1.waddr,i1.raddr,  i1.data_out);

endmodule