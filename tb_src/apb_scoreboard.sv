class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  
  uvm_analysis_imp#(apb_transaction, apb_scoreboard) sb_analysis_imp;
  apb_transaction seq_que[$];
  bit [`APB_DATA_WIDTH] sb_mem[2**`APB_ADDR_WIDTH];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_analysis_imp = new("sb_analysis_imp", this);
    foreach (sb_mem [i]) sb_mem [i] = 8'h00;
  endfunction

  virtual function void write(apb_transaction pkt);
    seq_que.push_back(pkt);
  endfunction : write

  task run_phase(uvm_phase phase);
    apb_transaction mem_pkt;
    forever begin
      wait (seq_que.size() > 0);
      mem_pkt = seq_que.pop_front();

      if(mem_pkt.PWRITE) begin
        sb_mem [mem_pkt.PADDR] = mem_pkt.PWDATA;
        $display("Hey_________");
      end

      else if(!mem_pkt.PWRITE) begin
        if( mem_pkt.PRDATA == sb_mem [mem_pkt.PADDR]) begin
          $display("Hello");
          `uvm_info(get_type_name(), $sformatf("------- :: READ DATA MATCH :: -------"), UVM_LOW)
          `uvm_info(get_type_name(), $sformatf("Addr: %0h,", mem_pkt.PADDR), UVM_LOW)
          `uvm_info(get_type_name(), $sformatf("Expected Data : %0h Actual Data : %0h", sb_mem [mem_pkt.PADDR], mem_pkt.PRDATA), UVM_LOW)
          `uvm_info(get_type_name(), $sformatf("---------------------------------------------"), UVM_LOW)
        end
        else begin
          `uvm_info(get_type_name(), $sformatf("------- :: READ DATA MISMATCH :: -------"), UVM_LOW)
          `uvm_info(get_type_name(), $sformatf("Addr: %0h,", mem_pkt.PADDR), UVM_LOW)
          `uvm_info(get_type_name(), $sformatf("Expected Data : %0h Actual Data : %0h", sb_mem [mem_pkt.PADDR], mem_pkt.PRDATA), UVM_LOW)
          `uvm_error("SCOREBOARD ", "ACTUAL AND EXPECTED OUTPUTS ARE NOT EQUAL")
          `uvm_info(get_type_name(), $sformatf("---------------------------------------------"), UVM_LOW)
        end

      end
    end

  endtask : run_phase

endclass: apb_scoreboard
