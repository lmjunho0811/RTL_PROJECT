# Based on the course compile/elab/sim flow; CLI only.
.DEFAULT_GOAL := all
.NOTPARALLEL:
.PHONY: all clean set compile elab sim
all: clean sim

set:
	mkdir -p build/work.lib
	printf 'define work_lib ./work.lib\n' > build/cds.lib
	printf 'define WORK work_lib\n' > build/hdl.var

compile: set
	cd build && xmvlog -64bit -sv -MESS -linedebug ../FSM.v ../tb_FSM.v

elab: compile
	cd build && xmelab -64bit -MESS -access rwc tb_FSM

sim: elab
	cd build && xmsim -64bit -MESS tb_FSM
	test -s build/FSM.vcd
	cp build/FSM.vcd ./FSM.vcd

clean:
	rm -rf -- build
	rm -f -- FSM.vcd
