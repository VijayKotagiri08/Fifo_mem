class trans_fifo;

    parameter  data_width =8, ptr_width = 8;
	rand bit w_en;
	rand bit r_en;
	randc bit [data_width-1:0] data_in;
	int flag,mflag;
	bit [data_width-1:0] data_out;
	bit empty, full;
	bit [ptr_width:0] waddr;
	bit [ptr_width:0]raddr;
	
	//Constraints dor read and write enable
	//constraint wr {w_en dist {1:/50, 0:/(50)};}
	//constraint rd {r_en dist {0:/50, 1:/(50)};}
	// function void post_randomize();
	// r_en = ~w_en;
	// endfunction
	
endclass
	
	

