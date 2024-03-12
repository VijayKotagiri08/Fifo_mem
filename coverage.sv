module cov #(parameter PTR_WIDTH = 3,SIZE = 5,DATA_WIDTH = 8) 
(rtl_if.cov rif_cov);

  

logic temp_rd_en;
logic temp_wr_en;
logic temp_clear;

always_ff @(posedge rif_cov.CLK)
     begin
     temp_clear <= rif_cov.clear;
     temp_rd_en <= rif_cov.rd_en;
     temp_wr_en <= rif_cov.wr_en;
     end


covergroup test_cg @(posedge rif_cov.CLK);

c0:coverpoint rif_cov.RESET{
             bins RESET_1 = {1};
			 bins RESET_0 ={0};
			 }
c1:coverpoint rif_cov.fifo_empty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c2:coverpoint rif_cov.fifo_full {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
c3 : coverpoint rif_cov.rd_en {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
			 
			 
c4 : coverpoint rif_cov.wr_en {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }
c5 : coverpoint rif_cov.clear {
             bins clear_high = {1};
			 bins clear_low = {0};
			 }
			 /*
c6 : coverpoint r_pointer {
              bins read_pointer_min = {0};
              bins read_pointer_between = {[1 : SIZE-2]};
			  bins read_pointer_max = {SIZE-1};
			  }
			  
c7 : coverpoint w_pointer {
              bins write_pointer_min = {0};
              bins write_pointer_between ={[1:SIZE-2]};
			  bins write_pointer_max = {SIZE-1};
			  }*/
c8 : coverpoint rif_cov.wr_data {
             bins wr_data = {[0:255]};
			  }
c9 : coverpoint rif_cov.rd_data {
             bins rd_data = {[0:255]};
			  }
c10 : coverpoint rif_cov.error {
             bins error_0 = {0};
			 bins error_1= {1};
			 }
			  
			  
read_and_fifo_empty:cross c3,c1;       //done
read_write_fifo_empty:cross c3,c4,c1; //done also fifo_full
read_and_clear:cross c3,c5;      // done
write_and_fifo_full:cross c4,c2;  //done
read_after_clear:cross temp_clear,c3;  
write_after_clear:cross temp_clear,c4;  
read_write_clear:cross c3,c4,c5;   //done
continuos_two_reads:cross temp_rd_en,c3; //done
continuos_two_writes:cross temp_wr_en,c4; // done
clear_and_fifo_empty:cross c1,c5; //done
commands_while_reset: cross c0,c3,c4,c5;

endgroup

test_cg test_inst;

initial begin
  test_inst = new();
 end

endmodule