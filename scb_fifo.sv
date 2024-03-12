class scb_fifo;

	//creating mailbox handle
    mailbox mon2scb;
	
	//used to count the number of transactions
    int scb_transactions,flag;
	
	//array to use as local memory
    bit [7:0] ref_fifo[$];
	logic [7:0] check_fifo;
	int pass_count,fail_count;
	//constructor
    function new(mailbox mon2scb);
      //getting the mailbox handles from  environment 
      this.mon2scb = mon2scb;
    endfunction
	
	//stores wdata and compare data_out with stored data
    task main;
	$display("------------INSIDE SCOREBOARD:MAIN TASK--------------------");
   // trans_fifo trans;
	//trans=new();
    forever begin
	 trans_fifo trans;
	  trans=new();
      mon2scb.get(trans);
	  if(trans.mflag)
	  
	  begin
	  //$display("Inside Scoreboard if !flag");
		if(trans.w_en && !trans.full) 
		 begin
			ref_fifo.push_front(trans.data_in);
			$display($time,"[SCB-PASS][Scb-transfer =%0d] Scoreboard data written: data_in=%0d",scb_transactions,trans.data_in);
	        pass_count++;
		 end
		if(trans.r_en && !trans.empty)
		 begin
		    check_fifo=ref_fifo.pop_back();
			//check_fifo=trans.data_in;
			if(check_fifo !== trans.data_out)
			 begin
				$error("[SCB-FAIL][Scb-transfer =%0d] Data :: Expected_data_out = %0d Actual_data_out = %0d",scb_transactions,check_fifo,trans.data_out);
				fail_count++;
			 end
		    else 
			 begin
			  $display($time,"[SCB-PASS][Scb-transfer =%0d] Data :: Expected_data_out = %0d Actual_data_out = %0d",scb_transactions,check_fifo,trans.data_out);
			  pass_count++;
			 end
		 end
		 $display("--------------------------------------------------------------------------------");
      scb_transactions++;
	 end
	 else flag = trans.mflag;
    end
	$display("[SCOREBOARD] No.of Testes Passed = %d and No.of Tests failed=%0d",pass_count,fail_count);
  endtask
endclass