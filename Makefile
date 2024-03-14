all: clean compile run

compile:
	vlog w2rsync.sv
	vlog r2wsync.sv
	vlog write_ptr.sv
	vlog read_ptr.sv
	vlog fifo_mem.sv
	vlog top.sv
	vlog uvmtb_top.sv

run:
	vsim -c uvmtb_top -do "run -all; quit"

clean:
	rm -rf work
	rm -rf transcript
