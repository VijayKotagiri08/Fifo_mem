class mon_fifo;

	//creating virtual interface handle
	virtual intfc vif;
    
	//creating mailbox handle
    mailbox mon2scb;
	trans_fifo trans;
    //constructor
	function new(virtual intfc vif, mailbox mon2scb);
		//getting the interface
		this.vif = vif;
		//getting the mailbox handles from  environment 
		this.mon2scb = mon2scb;
   endfunction
   int flag, mon_transfer;
   
 
	
   task main; // task to get the data from the DUt and pass it to the score baord using the transaction(mail box)
    $display ("-------------INSIDE MONITOR MAIN TASK---------------");
	forever 
		begin
			//trans_fifo trans;
			trans = new(); //creating trans object
			trans.mflag=0;
			@(posedge vif.rclk);
		   // @(posedge vif.wclk);
			wait(vif.w_en || vif.r_en);
			
			if( (!vif.r_en) & vif.w_en  ) // when write enable is high transfering the data from interface to mailbox
			 begin
				@(posedge vif.wclk);
			    @(posedge vif.wclk);
				trans.w_en = vif.w_en;
				trans.r_en = vif.r_en;
				trans.waddr = vif.waddr;
				trans.raddr = vif.raddr;
				trans.data_in = vif.data_in;
				trans.full = vif.full;
				trans.empty = vif.empty;
				trans.data_out = vif.data_out;
				//@(posedge vif.wclk);
				//mon2scb.put(trans);
				$display($time,"[MONITOR][Monitor Write Transfer : %0d]----w_en = %0d,r_en = %0d, data_in = %0d, empty = %0d,full = %0d,waddr = %0d",mon_transfer, vif.w_en,vif.r_en, vif.data_in, vif.empty, vif.full, vif.waddr);
  
			 end
			if((!vif.w_en) & vif.r_en )  // when read enable is high transfering the data from interface to mailbox
			 begin
			    @(posedge vif.rclk);
			
			    trans.w_en = vif.w_en;
				trans.r_en = vif.r_en;
				trans.waddr = vif.waddr;
				trans.raddr = vif.raddr;
				trans.data_in = vif.data_in;
				trans.full = vif.full;
				trans.empty = vif.empty;
				trans.data_out = vif.data_out;
				//@(posedge vif.wclk);
				//mon2scb.put(trans);
				$display($time,"[MONITOR][Monitor Read Transfer : %0d]----w_en = %0d,r_en = %0d,empty = %0d,full = %0d,data_out = %0d,raddr = %0d",mon_transfer, vif.w_en,vif.r_en, vif.empty, vif.full, vif.data_out, vif.raddr);
			 end
			//$display("--------------------------------------------------------------------------------");
			  mon2scb.put(trans);
		   trans.mflag=1;
			mon_transfer++;
				//@(posedge vif.rclk);
				//$display($time,"[MONITOR][Monitor Transfer : %0d]----w_en = %0d,r_en = %0d, data_in = %0d,data_out = %0d, empty = %0d,full = %0d,waddr = %0d,raddr = %0d",mon_transfer, vif.w_en,vif.r_en, vif.data_in,vif.data_out, vif.empty, vif.full, vif.waddr, vif.raddr);
	
		end
		
	endtask
endclass



