class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
virtual intfc vif; //virtual interafce handle
fifo_seq_item mon_pkt;// sequence item handle

uvm_analysis_port #(fifo_seq_item) monitor_port; // creating annalysis port for monitor

// creating a new constructor for monitor class
function new (string name="monitor", uvm_component parent);
	super.new(name, parent);
	`uvm_info("MONITOR", "Inside Constructor!",UVM_LOW)
endfunction

//Build Phase
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("MONITOR", "Inside Build Phase!",UVM_LOW)
	monitor_port = new("monitor_port", this);//creating a new constructor for monitor annalysis port
	if(!(uvm_config_db # (virtual intfc):: get (this, "*", "vif", vif))) //checking proper connection with interface
	begin
	`uvm_error (" DRIVER CLASS", "Failed to get vif from config DB!")
	end
endfunction

//Connect Phase
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("MONITOR", "Inside Connect Phase!",UVM_LOW)
endfunction

//Run phase
task run_phase (uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("MONITOR", "Inside Run Phase!",UVM_LOW)
	
	forever begin
		mon_pkt = fifo_seq_item #(8,8,256)::type_id::create("mon_pkt");
		wait (vif.w_rst_n && vif.r_rst_n);
        //tranfering data when write enable is high
		if(vif.w_en & !vif.r_en)
		begin
			@(posedge vif.wclk);
		
			mon_pkt.w_en=vif.w_en;
			mon_pkt.r_en=vif.r_en;
			mon_pkt.waddr= vif.waddr;
			mon_pkt.raddr=vif.raddr;
			mon_pkt.data_in= vif.data_in;
			mon_pkt.data_out= vif.data_out;
			mon_pkt.full= vif.full;
			mon_pkt.empty= vif.empty;
			`uvm_info("MONITOR WRITE",$sformatf("Burtst Dtails:time=%0d,w_en=%d,r_en=%d,data_in=%d,full=%0d,empty=%0d, waddr=%d,",$time,vif.w_en,vif.r_en,vif.data_in,vif.full,vif.empty,vif.waddr),UVM_LOW) 
		end
		//tranfering data when read enable is high
		if(vif.r_en & !vif.w_en)
		begin
		    @(posedge vif.rclk);
			mon_pkt.w_en=vif.w_en;
			mon_pkt.r_en=vif.r_en;
			mon_pkt.waddr= vif.waddr;
			mon_pkt.raddr=vif.raddr;
			mon_pkt.data_in= vif.data_in;
			mon_pkt.data_out= vif.data_out;
			mon_pkt.full= vif.full;
			mon_pkt.empty= vif.empty;
			`uvm_info("MONITOR READ",$sformatf("Burtst Dtails:time=%0d,w_en=%d,r_en=%d,data_out=%d,full=%0d,empty=%0d, raddr=%d",$time,vif.w_en,vif.r_en,vif.data_out,vif.full,vif.empty,vif.raddr),UVM_LOW)
			
		end
		monitor_port.write(mon_pkt); // calling the write method from the scoreboard
	end
endtask

endclass