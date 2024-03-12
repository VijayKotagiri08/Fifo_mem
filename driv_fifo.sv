 
class driv_fifo;

	virtual intfc vif;
    trans_fifo trans;
	//creating mailbox to handle
	mailbox gen2driv;
	//construct
	function new(virtual intfc vif, mailbox gen2driv);
		//getting the interface
		this.vif = vif;
	
		//getting mailbox handle from environment
		this.gen2driv = gen2driv;
	endfunction
	
	task reset; // Reset the w_en, r_en and data_in to zero when reset is low
		wait(!vif.w_rst_n);
		$display(".....................[Driver] write reset started...............");
		vif.w_en  <= 0 ;
		vif.data_in <=0;
		wait(vif.w_rst_n);
		$display(".....................[Driver] write reset ended...............");
		
		wait(!vif.r_rst_n);
		$display(".....................[Driver] read reset started...............");
		vif.r_en  <= 0 ;
		vif.data_in <=0;
		wait(vif.r_rst_n);
		$display(".....................[Driver] read reset ended...............");
    endtask
	
	 int no_of_transaction, flag;
    task drive; //Drive ask to drive the stimulus generated by generator to the DUT through interface
	$display ("-------------INSIDE DRIVER: DRIVE TASK----------------");
	 forever 
	    begin
		trans=new();
		gen2driv.get(trans); // get method to get the output from the mailbox that is sent from the generator.
		@(posedge vif.rclk);
		if(!trans.flag)
		begin
			
			if(trans.w_en & !trans.r_en) //When write_enable is high, passing the trans signals to the virtual interface 
			  begin
				vif.w_en <= trans.w_en;
				vif.r_en <= trans.r_en;
				vif.data_in <= trans.data_in;
				@(posedge vif.wclk);
				@(posedge vif.wclk);
				$display($time,"[Driver][Driver Transfer : %0d]------ w_en = %0d,r_en=%0d, waddr = %d, data_in = %0d", no_of_transaction,trans.w_en,trans.r_en, vif.waddr, trans.data_in);
			  end
			  
			if(trans.r_en & !trans.w_en)//When write_enable is high, passing the trans signals to the virtual interface 
			  begin
				vif.r_en <= trans.r_en;
				vif.w_en <= trans.w_en;
				vif.data_in <= trans.data_in;
				@(posedge vif.rclk);
		
				$display($time,"[Driver][Driver Transfer : %0d]------r_en = %0d,w_en = %0d, raddr = %d",no_of_transaction, trans.r_en,trans.w_en, vif.raddr);
			  end
			no_of_transaction++; 
			trans.flag=1;
		end
		else flag = trans.flag;
		end
	endtask
	 
endclass