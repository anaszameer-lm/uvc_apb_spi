class apb_base_sequence extends uvm_sequence #(apb_transaction);

`uvm_object_utils(apb_base_sequence)

function new(string name="apb_base_sequence");
  super.new(name);
endfunction

apb_transaction apb_tr;
bit [`APB_ADDR_WIDTH-1:0] ADDR;
bit [`APB_DATA_WIDTH-1:0] DATA;

virtual task body();

endtask: body

endclass: apb_base_sequence

class write_sequence extends apb_base_sequence;

`uvm_object_utils(write_sequence)

function new(string name="write_sequence");
  super.new(name);
endfunction

task body(); 
  `uvm_do_with(req,{  req.PADDR==local::ADDR;
                      req.PWDATA==local::DATA;  
                      req.PWRITE==1;  })
endtask

endclass: write_sequence

class read_sequence extends apb_base_sequence;

  `uvm_object_utils(read_sequence)
  
  function new(string name="read_sequence");
    super.new(name);
  endfunction
  
  task body(); 
    `uvm_do_with(req,{  req.PADDR==local::ADDR;  
                        req.PWRITE==0;  })
  endtask
  
  endclass: read_sequence

  class rand_rw_sequence extends apb_base_sequence;

    `uvm_object_utils(rand_rw_sequence)
    
    function new(string name="rand_rw_sequence");
      super.new(name);
    endfunction
    
    task body(); 
      `uvm_do(req)
    endtask
    
  endclass: rand_rw_sequence



