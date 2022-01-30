class apb_base_test extends uvm_test;

   `uvm_component_utils(apb_base_test)
  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  apb_environment environment;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    environment = apb_environment::type_id::create("environment", this);
  endfunction

endclass : apb_base_test

class read_write_test extends apb_base_test;

   `uvm_component_utils(read_write_test)
  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  write_sequence seq_w;
  read_sequence seq_r;
  rand_rw_sequence seq_rand_rw;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq_w = write_sequence::type_id::create("seq_w", this);
    seq_r = read_sequence::type_id::create("seq_r", this);
    seq_rand_rw = rand_rw_sequence::type_id::create("seq_rand_rw", this);
  endfunction

virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    $display("TEST Running");
    
    seq_w.DATA='hDE;
    seq_w.ADDR='h5;
    seq_r.ADDR='h5;
    seq_w.start(environment.agent.sequencer);
    seq_r.start(environment.agent.sequencer);

    seq_w.DATA='hAD;
    seq_w.ADDR='h0;
    seq_r.ADDR='h0;
    seq_w.start(environment.agent.sequencer);
    seq_r.start(environment.agent.sequencer);

    seq_w.DATA='hAB;
    seq_w.ADDR='h3;
    seq_r.ADDR='h3;
    seq_w.start(environment.agent.sequencer);
    seq_r.start(environment.agent.sequencer);

    repeat (20) begin
      $display("Random Sequence!");
      seq_rand_rw.start(environment.agent.sequencer);
    end
    phase.drop_objection(this);  
    phase.phase_done.set_drain_time(this, 1000);
endtask

endclass : read_write_test
