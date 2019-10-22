SHELL = /bin/sh

default: 
	@echo "make module.sim -> simulates module"
	@echo "make module.wav -> opens waveform of module"
	@echo "make clean      -> removes vcd files"
	@echo "make veryclean  -> removes all files in work directory"

# Add modules here for simulation
register_file.sim: 
	@iverilog -g2012 -I include/ -o work/register_file.out rtl/dyt_register_file.v tb/tb_dyt_register_file.v
	@vvp work/register_file.out


# Add modules here for waveforms
register_file.wav:
	@iverilog -g2012 -I include/ -o work/register_file.out rtl/dyt_register_file.v tb/tb_dyt_register_file.v
	@vvp work/register_file.out
	@open -a Scansion work/tb_dyt_register_file.vcd

clean:
	@rm work/*.vcd

veryclean:
	@rm work/*
