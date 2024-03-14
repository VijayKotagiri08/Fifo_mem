
class uvmtest extends uvm_test;
	`uvm_component_utils(uvmtest)
	
	env e0; //class handle for environment class
	fifo_sequence    reset_seq;
	fifo_sequence_wr write_seq; // class handle for fifo write sequence
	sequence_fifo_rd read_seq;// class handle for fifo read sequence
	
	// creating new constructor for the uvm test class
	function new(string name ="uvmtest",uvm_component parent);
		super.new(name,parent);
		`uvm_info("TEST CLASS", "INSIDE CONSTRUCTOR!",UVM_LOW)
	endfunction
	
//Build phase(defined using functions as it does to consume simulation time)
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("TEST CLASS", "INSIDE BUILD PHASE!",UVM_LOW)
		e0 = env::type_id::create("e0",this);
	endfunction
	
	//Connect Phase(defined using functions as it does to consume simulation time)
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("TEST CLASS", "INSIDE CONNECT PHASE!",UVM_LOW)
		
	endfunction
	
	// Run phase (defined using task because it consumes simulation time)
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("TEST CLASS", "INSIDE RUN PHASE!",UVM_LOW)
		phase.raise_objection(this);
		
			reset_seq=	fifo_sequence::type_id::create("reset_seq");
			reset_seq.start(e0.agnt.s0);
			
		#10;
			write_seq=	fifo_sequence_wr::type_id::create("write_seq");
			write_seq.start(e0.agnt.s0);
		#4;
		
		
		
			read_seq= sequence_fifo_rd::type_id::create("read_seq");
			read_seq.start(e0.agnt.s0);
		#10;
			
		phase.drop_objection(this);
	endtask
	//End of Elaboration phase to print the uvm topology
function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_root::get().print_topology();
endfunction

endclass