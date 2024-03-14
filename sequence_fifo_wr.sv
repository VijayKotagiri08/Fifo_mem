import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_sequence extends uvm_sequence;
	
	`uvm_object_utils (fifo_sequence) // registering the class with factory
	
	fifo_seq_item fifo_pkt; // creating the class handle for sequence item class
	
	// creating a new constructor for write_sequence class
	function new( string name = "fifo_sequence");
		super.new (name);
		`uvm_info("FIFO_SEQUENCE", "Inside Constructor!", UVM_LOW)
	endfunction
	 
	 

	// randomizing with write_enable-1 and read enable-0
	task body();
		begin
		    `uvm_info("FIFO_SEQUENCE","INSIDE THE TASK BODY!",UVM_LOW)
			fifo_pkt = fifo_seq_item#(8,8,256)::type_id ::create ("fifo_pkt");
			start_item(fifo_pkt);
			fifo_pkt.no_rst.constraint_mode(0);
			assert (fifo_pkt.randomize() with {fifo_pkt.w_rst_n==0;fifo_pkt.r_rst_n==0;});
			`uvm_info("SEQ",$sformatf("Generate new item: %s",fifo_pkt.convert2str()),UVM_LOW)
			$display("-----------------------In reset body--------------------------------------");
			$display("------------------------------------------------------------------");
			finish_item(fifo_pkt);
	    end
	endtask
	
endclass
	  
	  
class fifo_sequence_wr extends uvm_sequence;
	
	`uvm_object_utils (fifo_sequence_wr) // registering the class with factory
	
	fifo_seq_item fifo_pkt_wr; // creating the class handle for sequence item class
	
	// creating a new constructor for write_sequence class
	function new( string name = "fifo_sequence_wr");
		super.new (name);
		`uvm_info("FIFO_SEQUENCE", "Inside Constructor!", UVM_LOW)
	endfunction
	 
	 
	int num=256;
	// randomizing with write_enable-1 and read enable-0
	task body();
		for (int i=0; i<num;i++) begin
		    `uvm_info("FIFO_SEQUENCE","INSIDE THE TASK BODY!",UVM_LOW)
			fifo_pkt_wr = fifo_seq_item#(8,8,256)::type_id ::create ("fifo_pkt_wr");
			start_item(fifo_pkt_wr);
			assert (fifo_pkt_wr.randomize() with {w_en==1 ; r_en==0;});
			`uvm_info("SEQ",$sformatf("Generate new item: %s",fifo_pkt_wr.convert2str()),UVM_LOW)
			$display("------------------------------------------------------------------");
			$display("------------------------------------------------------------------");
			finish_item(fifo_pkt_wr);
			`uvm_info("SEQ",$sformatf(" Done Generate new item: %d",i),UVM_LOW)
	    end
		 `uvm_info("SEQ",$sformatf(" Done Generation of items: %d",num),UVM_LOW)
	endtask
	
endclass

// raed sequence class	 
class sequence_fifo_rd extends uvm_sequence;
	
	`uvm_object_utils (sequence_fifo_rd) // registered the read sequence class with factory
	
	fifo_seq_item fifo_rd_pkt;// class handle for sequence item 
	
	// created a new constructor for the sequence_fifo_rd
	function new( string name = "sequence_fifo_rd");
		super.new (name);
		`uvm_info("FIFO_READ_SEQUENCE", "Inside Constructor!", UVM_LOW)
	endfunction
	 
    int num=256;
	// randomizing with write_enable-0 and read enable-1
	task body();
		for (int i=0; i<num;i++) begin
		    `uvm_info("FIFO_READ_SEQUENCE","INSIDE THE TASK BODY!",UVM_LOW)
			fifo_rd_pkt = fifo_seq_item#(8,8,256)::type_id::create ("fifo_rd_pkt");
			start_item(fifo_rd_pkt);
			assert (fifo_rd_pkt.randomize() with {w_en==0 & r_en==1;});
			`uvm_info("SEQ",$sformatf("Generate new item:%s ",fifo_rd_pkt.convert2str()),UVM_LOW)
			
			$display("------------------------------------------------------------------");
			$display("------------------------------------------------------------------");
			finish_item(fifo_rd_pkt);
			`uvm_info("SEQ",$sformatf(" done Generate new item: %d",i),UVM_LOW)
		end
		 `uvm_info("SEQ",$sformatf(" Done Generation of items: %d",num),UVM_LOW)
	endtask
	
endclass	 