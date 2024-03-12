
`include "environment.sv"
program test(intfc vif);
	environment env;
	//virtual intfc vif;
	initial
    begin	
		env = new(vif); //creating environment
		env.gen.count =16;
		env.gen.size =1;
		env.run();
	end
 endprogram