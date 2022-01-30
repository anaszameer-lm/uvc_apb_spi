 class apb_transaction extends uvm_sequence_item;
  
  rand bit [`APB_ADDR_WIDTH-1:0] PADDR; 
  rand bit [`APB_DATA_WIDTH-1:0] PWDATA;
  rand bit PWRITE;
  bit [`APB_DATA_WIDTH-1:0] PRDATA;

  function new(string name="apb_transaction");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_transaction)
    `uvm_field_int(PADDR,UVM_ALL_ON)
    `uvm_field_int(PWDATA,UVM_ALL_ON)
    `uvm_field_int(PWRITE,UVM_ALL_ON)
    `uvm_field_int(PRDATA,UVM_ALL_ON)
  `uvm_object_utils_end

endclass: apb_transaction
