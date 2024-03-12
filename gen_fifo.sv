 
class gen_fifo;

	trans_fifo trans, endtrans; // declaring transaction class
	
	mailbox  gen2driv; //declaring mailbox
	
	int count, size,flag=0;
	event ended;
	//constructor
	function new(mailbox  gen2driv, event ended);
		this.gen2driv = gen2driv;
        this.ended=ended;		//getting the mailbox from env
	endfunction

	task main();
	int i;
	endtrans =new();//creating endtrans object
	endtrans.flag=0;
	repeat(size) 
	begin
	//repeat(count)
	//begin 
		//creating endtrans object
		for(int j=0;j<count;j++)
		begin 
			trans =new();
			if(j<count/2)
				
					assert(trans.randomize() with {trans.w_en==1;trans.r_en==0;});
				// randomizing the inputs
		
			if (j>=count/2)
				
					assert(trans.randomize() with {trans.w_en==0;trans.r_en==1;});
			gen2driv.put(trans); //put method to put the data into the mailbox to transfer the data from genrator to driver
		$display("[Generator][Generator trasaction no=%0d]:---data_in =%d, w_en = %d, r_en =%d ", i,trans.data_in, trans.w_en, trans.r_en);
				
		i++;	
		end
		//$display("[Generator][Generator trasaction no=%0d]:---data_in =%d, w_en = %d, r_en =%d ", i,trans.data_in, trans.w_en, trans.r_en);
	
	//end
	end
		endtrans.flag=1;
		gen2driv.put(endtrans);//put method to put the data into the mailbox of endtrans to transfer the data from genrator to driver
	endtask
	


endclass 