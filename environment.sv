`include "trans_fifo.sv"
`include "gen_fifo.sv"
`include "driv_fifo.sv"
`include "mon_fifo.sv"
`include "scb_fifo.sv"

class environment;

	gen_fifo gen; //generator handle
	driv_fifo driv; //Driver handle
	mon_fifo mon; // Monitor handle
	scb_fifo scb; //scorebord handle
	
	mailbox g2d_mbx; // generator to driver
	mailbox m2s_mbx; // monitor to scoreboard
	   
    //event for synchronization between generator and test
    event gen_ended;
  
	virtual intfc vif;

	function new(virtual intfc vif);
	
		this.vif = vif;  //get the interface from test
		
		g2d_mbx = new();    //creating the mailbox 
		m2s_mbx = new();
		
		//creating generator and driver
		gen = new(g2d_mbx,gen_ended);
		driv = new(vif,g2d_mbx);
		mon = new(vif, m2s_mbx);
		scb = new(m2s_mbx);
	endfunction
	
	task pre_test();
	 driv.reset();

	endtask
	
	task test();
	 fork
	    gen.main();
		driv.drive();
		mon.main();
		scb.main();
	 join_any
	endtask
	
	task post_test();
	//wait(gen.count == driv.no_of_transaction);
    //wait(gen.count == scb.mon_transactions);  
	 wait(scb.flag ==0);
	 wait(driv.flag==1);
	
	 //#10;
	 //driv.flag=0;
	 //scb.flag=1;
	endtask
	
	
	task run;
		pre_test();
		test();
		post_test();
		$finish;
	endtask
	
endclass
	 



