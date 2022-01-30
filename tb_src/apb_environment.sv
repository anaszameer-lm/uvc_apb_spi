class apb_environment extends uvm_env;

  `uvm_component_utils(apb_environment)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  apb_agent agent;
  apb_scoreboard scoreboard;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = apb_agent::type_id::create("agent", this);
    scoreboard = apb_scoreboard::type_id::create("scoreboard", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.mon_analysis_port.connect(scoreboard.sb_analysis_imp);
  endfunction : connect_phase
    
endclass : apb_environment