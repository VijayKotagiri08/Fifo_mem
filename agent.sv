class agent extends uvm_agent;
	`uvm_component_utils(agent) //registering the class with factory

	sequencer  s0;//class handle for sequencer class
	driver d0;//class handle for driver class
	monitor mon;// class handle for monitor class

//creating a new constructor for sequencer class
	function new(string name ="agent",uvm_component parent);
		super.new(name,parent);
		`uvm_info("AGENT CLASS", "Inside Constructor!",UVM_LOW)
	endfunction
	
	//build phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		
		`uvm_info("AGENT CLASS", "BUILD PHASE!",UVM_LOW)
		s0 = sequencer::type_id::create("s0",this);
		d0 = driver::type_id::create("d0",this);
		mon = monitor:: type_id::create("mon", this);
	endfunction
	
	//connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("AGENT CLASS", "CONNECT PHASE!",UVM_LOW)
		d0.seq_item_port.connect(s0.seq_item_export);
	endfunction
	
	//run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("AGENT CLASS", "INSIDE BUILD PHASE!",UVM_LOW)
	endtask
	
endclass