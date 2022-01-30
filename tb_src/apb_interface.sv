interface apb_interface(input bit PCLK, input logic PRESETn);
 // APB SLAVE PORT INTERFACE 
  logic [`APB_ADDR_WIDTH-1:0 ]  PADDR;       // Addr     
  logic                         PWRITE;      // Write Strobe    
  logic                         PSEL;        // Select signal      
  logic                         PENABLE;     // Enable signal
  logic [`APB_DATA_WIDTH-1:0 ]  PWDATA;      // Write Data     
  logic [`APB_DATA_WIDTH-1:0 ]  PRDATA;      // Read Data
  logic                         PREADY;      // Slave Ready     
  logic 			                  TrFr;        // Slave Error
endinterface