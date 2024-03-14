vlib work
vdel -all
vlib work

#vlog interface.sv
vlog w2rsync.sv
vlog r2wsync.sv
vlog write_ptr.sv
vlog read_ptr.sv
vlog fifo_mem.sv
vlog top.sv 

vlog uvmtb_top.sv


#vsim work.uvmtb_top
vsim -coverage -vopt work.uvmtb_top 
#vsim work.uvmtb_top -coverage -do

run -all

vcover report -html fifo_coverage
coverage report -detail