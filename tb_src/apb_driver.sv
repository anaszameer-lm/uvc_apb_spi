class apb_driver extends uvm_driver #(apb_transaction);
  
  `uvm_component_utils(apb_driver)
  virtual apb_interface apb_vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_vif", apb_vif))
      `uvm_fatal("Driver","Could Not Get Interface!")
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    forever begin
    super.run_phase(phase);
    seq_item_port.get_next_item(req);
    $display("Driving");
    drive(req);
    seq_item_port.item_done();
    end
  endtask: run_phase
    
  virtual task drive(input apb_transaction req);
    
    if(!apb_vif.PRESETn)
      apb_reset(); 
    
    if (req.PWRITE)
      apb_write(req);
    else
      apb_read(req);
    
    // `uvm_info(get_type_name(), $sformatf("Drive Signals :\n%s",req.sprint()), UVM_LOW)
      
  endtask

  virtual task apb_write(input apb_transaction req); 
    
    @(posedge apb_vif.PCLK);
    /*apb_vif.PADDR <= req.PADDR;
    apb_vif.PWDATA <= req.PWDATA;
    apb_vif.PWRITE <= req.PWRITE;
    apb_vif.PENABLE <= 0;
    apb_vif.PSEL <= 1;
    
    @(posedge apb_vif.PCLK);
    apb_vif.PENABLE <= 1;
    
    @(posedge apb_vif.PCLK);
    wait(apb_vif.PREADY==1);
    `uvm_info(get_type_name(), $sformatf("Drive Signals :\n%s",req.sprint()), UVM_LOW)
    
    @(posedge apb_vif.PCLK);
    apb_vif.PENABLE <= 0;
    apb_vif.PSEL <= 0;*/

    @(negedge apb_vif.PCLK);
    apb_vif.PADDR <= req.PADDR;
    apb_vif.PWDATA <= req.PWDATA;
    apb_vif.PWRITE <= req.PWRITE;
    apb_vif.PENABLE <= 0;
    apb_vif.PSEL <= 1;
    
    @(negedge apb_vif.PCLK);
    apb_vif.PENABLE <= 1;
    
    @(posedge apb_vif.PCLK);
    if (apb_vif.PREADY) begin
    
    @(negedge apb_vif.PCLK);
    apb_vif.PENABLE <= 0;
    apb_vif.PSEL <= 0;

    end
    else begin
    
    wait(apb_vif.PREADY==1);
    @(posedge apb_vif.PCLK);
    @(negedge apb_vif.PCLK);
    apb_vif.PENABLE <= 0;
    apb_vif.PSEL <= 0;

    end

    `uvm_info(get_type_name(), $sformatf("Drive Signals :\n%s",req.sprint()), UVM_LOW)


  endtask: apb_write 

  virtual task apb_read(input apb_transaction req);
    
    @(negedge apb_vif.PCLK);
    apb_vif.PADDR <= req.PADDR;
    apb_vif.PWRITE <= req.PWRITE;
    apb_vif.PSEL <= 1;

    @(negedge apb_vif.PCLK);
    apb_vif.PENABLE <= 1;

    @(posedge apb_vif.PCLK);
    wait(apb_vif.PREADY==1);
    `uvm_info(get_type_name(), $sformatf("Drive Signals :\n%s",req.sprint()), UVM_LOW)

    @(negedge apb_vif.PCLK);
    apb_vif.PENABLE <= 0;
    apb_vif.PSEL <= 0;

  endtask: apb_read

  task apb_reset();
    //apb_vif.PADDR  ;       
    apb_vif.PWRITE <=1 ;          
    apb_vif.PSEL <= 0;             
    apb_vif.PENABLE <=0;     
    //apb_vif.PWDATA;           
    //apb_vif.PRDATA;      
    //apb_vif.PREADY;           
    //apb_vif.TrFr; 
    
    wait(apb_vif.PRESETn==1);

  endtask: apb_reset
  
endclass: apb_driver