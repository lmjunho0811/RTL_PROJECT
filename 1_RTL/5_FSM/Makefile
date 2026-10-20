.DEFAULT_GOAL := all
.NOTPARALLEL:
CASES := 1_MOORE_MACHINE/1_assign_output 1_MOORE_MACHINE/2_always_output 1_MOORE_MACHINE/3_reg_output 2_MEALY_MACHINE
.PHONY: all clean
all:
	@set -e; for case_dir in $(CASES); do echo "=== $$case_dir ==="; $(MAKE) -C "$$case_dir" all; done
clean:
	@set -e; for case_dir in $(CASES); do $(MAKE) -C "$$case_dir" clean; done
