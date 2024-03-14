import uvm_pkg::*;
`include "uvm_macros.svh"

class sequencer extends uvm_sequencer #(fifo_seq_item);
	`uvm_component_utils(sequencer) // registering the class to factory
	
	//creating a new constructor for sequencer class
	function new (string name ="sequencer",uvm_component parent);
		super.new(name,parent);
		`uvm_info("SEQUENCER", "Inside Constructor!",UVM_LOW)
	endfunction 
	
	//Build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("SEQUENCER", "Build Phase!",UVM_LOW)
	endfunction
	
	//connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("SEQUENCER", "Connect Phase!",UVM_LOW)
	endfunction

endclass