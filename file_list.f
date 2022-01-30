//
// Verilog macros
//

//+define+LITLE_ENDIAN
//+define+UVM_NO_DEPRECATED

//
// Test Bench Top Level
//

tb_src/apb_tb_top.sv

//
// DUT Parts
//

src/APB_SPI_Top.v
src/APB_SLAVE.v

//
// SV Interfaces
//

tb_src/apb_interface.sv

//
// SV Packages
//

tb_src/apb_package.sv

tb_src/apb_transaction.sv
tb_src/apb_sequence.sv
tb_src/apb_sequencer.sv
tb_src/apb_driver.sv
tb_src/apb_monitor.sv
tb_src/apb_agent.sv
tb_src/apb_scoreboard.sv   
tb_src/apb_environment.sv
tb_src/apb_test.sv
