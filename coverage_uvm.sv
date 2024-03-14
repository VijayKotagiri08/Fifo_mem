class coverage extends uvm_test ;
`uvm_component_utils(coverage)// regisering the covergae class with the factory
uvm_analysis_imp #(fifo_seq_item, coverage) coverage_port;// craeting annalysis port for the coverage

real coverage_score1;
real coverage_score2;
real coverage_score3;
real total_coverage;
fifo_seq_item cov_pkt;
virtual intfc cov_if; // virtaul interface handle



//creating cover groups for write and read address
covergroup cov_mem with function sample(fifo_seq_item cov_pkt) ;
    a1: coverpoint cov_pkt.waddr { // Measure coverage
       bins waddr[]= {[0:255]};
     }
	 a2: coverpoint cov_pkt.raddr { // Measure coverage
     bins raddr[]= {[0:255]};
     }
     w_r_addr: cross a1,a2;
   endgroup

// craeting cover group for testing write operation
covergroup test_write with function sample(fifo_seq_item w_pkt) ;

c0:coverpoint w_pkt.w_rst_n{
             bins RESET_1 = {1};
			 bins RESET_0 ={0};
			 }
c1:coverpoint w_pkt.empty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c2:coverpoint w_pkt.full {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
			 
c3 : coverpoint w_pkt.w_en {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

c4 : coverpoint w_pkt.data_in {
             bins wr_data = {[0:255]};
			  }

c10 : coverpoint w_pkt.r_en {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
			  
read_and_fifo_empty:cross c3,c1;       //done
read_write_fifo_empty:cross c3,c4,c1; //done also fifo_full
read_and_clear:cross c3,c0;      // done
write_and_fifo_full:cross c4,c2;  //done 
read_write_clear:cross c3,c0,c10;   //done
clear_and_fifo_empty:cross c1,c0; //done
commands_while_reset: cross c0,c3,c10;

endgroup

// creating cover group for testing read operation
covergroup test_read with function sample(fifo_seq_item r_pkt) ;
c5 : coverpoint r_pkt.r_en {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
c6: coverpoint r_pkt.r_rst_n {
             bins r_rst_n_high = {1};
			 bins r_rst_n_low = {0};
			 }			 

c7 : coverpoint r_pkt.data_out {
             bins rd_data = {[0:255]};
			  }
			  
c8:coverpoint r_pkt.empty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c9:coverpoint r_pkt.full {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
c11 : coverpoint r_pkt.w_en {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

read_and_fifo_emptyr:cross c5,c8;       //done
read_write_fifo_emptyr:cross c11,c5,c8; //done also fifo_full
read_and_clear_read:cross c5,c6;      // done
write_and_fifo_fullr:cross c9,c11;  //done 
read_write_clear:cross c5,c6,c11;   //done
clear_and_fifo_empty:cross c6,c8; //done
commands_while_reset: cross c5,c6,c11;

endgroup

// creating a new constructor for coverage class and all the above created cover groups
function new (string name="coverage",uvm_component parent);
super.new(name,parent);
`uvm_info("COVERAGE CLASS", "Inside Constructor!", UVM_LOW)
//cov_mem=new();
test_write=new();
test_read=new();
endfunction

//Buid Phase
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("COVERAGE CLASS", "Build Phase!", UVM_HIGH)
   
    coverage_port = new("coverage_port", this); 
endfunction
  
  // Write Function
function void write(fifo_seq_item t);
//cov_mem.sample(t);
test_read.sample(t);
test_write.sample(t);

endfunction

// Extract Phase
function void extract_phase(uvm_phase phase);
   super.extract_phase(phase);
  //coverage_score1=cov_mem.get_coverage();
coverage_score2=test_write.get_coverage();
coverage_score3=test_read.get_coverage();
endfunction

//Report Phase
function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	//`uvm_info("COVERAGE",$sformatf("Coverage=%0f%%",coverage_score1),UVM_MEDIUM);
	`uvm_info("COVERAGE",$sformatf("Coverage=%0f%%",coverage_score2),UVM_MEDIUM);
	`uvm_info("COVERAGE",$sformatf("Coverage=%0f%%",coverage_score3),UVM_MEDIUM);
endfunction

endclass