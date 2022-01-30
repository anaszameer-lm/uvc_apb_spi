class apb_monitor extends uvm_monitor;
  
  `uvm_component_utils(apb_monitor)
  virtual apb_interface apb_vif;
  uvm_analysis_port#(apb_transaction) mon_analysis_port;
  apb_transaction sampled_tx;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_vif", apb_vif))
      `uvm_fatal("Monitor","Could Not Get Interface!")
    mon_analysis_port = new("mon_analysis_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
    super.run_phase(phase);
    sampled_tx = apb_transaction::type_id::create("sampled_tx", this);
    sample_signals();
    end
  endtask

  task sample_signals();

    @(posedge apb_vif.PCLK);
    if (apb_vif.PREADY && apb_vif.PENABLE) begin
      sampled_tx.PADDR = apb_vif.PADDR;
      
      if(apb_vif.PWRITE) begin
        sampled_tx.PWRITE = apb_vif.PWRITE;
        sampled_tx.PWDATA = apb_vif.PWDATA;
        $display("PWRITE % Time=%t",sampled_tx.PWRITE,$time);
      end
      
      else if(!apb_vif.PWRITE) begin
        @(negedge apb_vif.PCLK);
        sampled_tx.PWRITE = apb_vif.PWRITE;
        sampled_tx.PRDATA = apb_vif.PRDATA;
      end
      
      $display("Enable %d Time=%t",apb_vif.PWRITE,$time);
      $display("Data Write %d Time=%t",apb_vif.PWDATA,$time);
      $display("Data Read %d Time=%t",apb_vif.PRDATA,$time);
      $display("Enable %d Time=%t",sampled_tx.PWRITE,$time);
      $display("Data Write %d Time=%t",sampled_tx.PWDATA,$time);
      $display("Data Read %d Time=%t",sampled_tx.PRDATA,$time);
      `uvm_info(get_type_name(), $sformatf("Transfer collected :\n%s",
      sampled_tx.sprint()), UVM_LOW)
      mon_analysis_port.write(sampled_tx);
    end
  endtask

endclass : apb_monitor