
`include "interface.sv"
`include "test.sv"

module tb_top;

    parameter depth=256;
    parameter data_width=8;
    parameter ptr_width=8;

	bit rclk;
	bit wclk;
	bit w_rst_n, r_rst_n;
	
	//clock generation
	always #5 rclk=~rclk;
    always #2 wclk=~wclk;
	
	//reset Generation
    initial begin
	    w_rst_n = 0;
		r_rst_n = 0;
		#50 w_rst_n = 1;
		#50 r_rst_n = 1;
    end
	
	intfc intf(.wclk(wclk), .rclk(rclk), .w_rst_n, .r_rst_n); //creatinng instance of interface, inorder to connect DUT and testcase
	
	test t1(intf); //Testcase instance, interface handle is passed to test as an argument
	
	top  #(.depth(depth), .data_width(data_width), .ptr_width(ptr_width))top1(  .i1(intf )); //DUT  instance

endmodule