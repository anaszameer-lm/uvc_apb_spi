UVM_VERBOSITY = UVM_MEDIUM
TEST = read_write_test

VCS =	vcs -sverilog -ntb_opts uvm-1.2 -timescale=1ns/1ns -LDFLAGS -Wl,--no-as-needed \
	+acc +vpi \
	+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
	-cm line+cond+fsm+branch+tgl -cm_dir ./coverage.vdb \
	-f file_list.f -full64 -debug_acc+all

SIMV = ./simv +UVM_VERBOSITY=$(UVM_VERBOSITY) \
	+UVM_TESTNAME=$(TEST) +UVM_TR_RECORD +UVM_LOG_RECORD \
	+verbose=1 +ntb_random_seed=244 -l vcs.log

	      
x:	comp run move 

comp:
	$(VCS)

run:
	$(SIMV)

move:   
	rm -rf results/sim
	mkdir -p results/sim
	mv csrc* simv* *.log *.h -t results/sim

clean:
	cd ./results/sim && rm -rf csrc* test* simv* *.bit *.tmp *.vpd *.key *.log *.vcd *.txt *.h *.daidir/ *.vdb/ DVE*/ novas.* waves.*

clean_all: 
	cd ./results/sim && rm -rf csrc* merge* test* simv* *.bit *.tmp *.vpd *.key *.log *.vcd *.txt *.h urgReport/ *.daidir/ *.vdb/ DVE*/ novas.* waves.*


compile:
	vcs -timescale=1ns/10ps -LDFLAGS -Wl,--no-as-needed $(DEFINES) -sverilog -ntb_opts uvm-1.2 -cm line+branch+tgl -f scripts/build_fcb.f -full64 -debug_acc+all -l fcb.log
	rm -rf results/sim	
	mkdir -p results/sim	
	mv csrc* simv* *.log *.h -t results/sim
	cp scripts/*.bit results/sim
gui:
	cd ./results/sim  && ./simv +UVM_TESTNAME=$(TEST) +UVM_TIMEOUT=30000 -gui &
