import uvm_pkg::*;
`include "uvm_macros.svh"

module apb_tb_top;
  
  bit clk;
  bit reset;

  always 
    #5 clk = ~clk;
  
  initial begin
  clk = 0;
  reset = 0;
  #2
  reset = 1;
  end

  apb_interface apb_intf(clk, reset);
  
  APB_SPI_top dut
  (
    .PCLK(clk),
    .PRESETn(reset),
    .PADDR (apb_intf.PADDR),
    .PWRITE (apb_intf.PWRITE),
    .PSEL (apb_intf.PSEL),
    .PENABLE (apb_intf.PENABLE),
    .PWDATA (apb_intf.PWDATA),
    .PRDATA (apb_intf.PRDATA),
    .PREADY (apb_intf.PREADY),
    .TrFr (apb_intf.TrFr),
    .SCLK (),
    .MISO (),
    .MOSI (),
    .SS   ()

  );

  initial begin
    uvm_config_db#(virtual apb_interface)::set(uvm_root::get(), "*", "apb_vif", apb_intf);
    //$fsdbDumpfile("waves.fsdb");
    //$fsdbDumpvars(0);
    $dumpfile("waves.vcd");
    $dumpvars();

  end

  initial begin
    run_test();
  end
endmodule: apb_tb_top