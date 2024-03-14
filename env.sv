class env extends uvm_env;
	`uvm_component_utils(env)

	agent agnt;// class handle for agent class
	scoreboard scb; //class handle for scoreboard class
	coverage  cov;// class handle for coverage class
	
	
	
	// creating a new constructor for environment class
	function new(string name ="env" , uvm_component parent);
		super.new(name,parent);
		`uvm_info("ENVIRONMENT CLASS", "Inside Constructor!",UVM_LOW)
	endfunction

	//Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("ENVIRONMENT CLASS", "Build Phase!",UVM_LOW)
		
		agnt = agent ::type_id::create("agnt",this);
		scb = scoreboard:: type_id::create("scb", this);
		cov=coverage::type_id::create("cov",this);
	endfunction
	
	
    //Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("ENVIRONMENT CLASS", "Connect Phase!",UVM_LOW)
		
		agnt.mon.monitor_port.connect(scb.scoreboard_port);//connecting monitor analysis port to scoreboard analysis port
		agnt.mon.monitor_port.connect(cov.coverage_port);//connecting monitor analysis port to coverage analysis port
	endfunction
	
	//Run Phase
	task run_phase (uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("ENVIRONMENT CLASS", "Inside Run Phase!",UVM_LOW)
	endtask
endclass
		
	
	
	
	