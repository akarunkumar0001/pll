module PLL_Integer_N_tb;
  
  reg clk_in;
  reg rst;
  reg enable;
  wire clk_out;
  
  // Instantiate PLL module
  PLL_Integer_N pll_inst (
    .clk_in(clk_in),
    .rst(rst),
    .enable(enable),
    .clk_out(clk_out)
  );
  
  // Clock generation
  always begin
    #5 clk_in = ~clk_in;  // Toggle the input clock every 5 time units
  end
  
  // Testbench stimulus
  initial begin
    // Initialize inputs
    clk_in = 0;
    rst = 1;
    enable = 0;
    
    // Apply reset
    #10 rst = 0;
    
    // Disable reset and enable the PLL
    #10 rst = 1;
    enable = 1;
    
    // Wait for some time
    #100;
    
    // Disable the PLL
    enable = 0;
    
    // Wait for some time
    #50;
    
    // Re-enable the PLL
    enable = 1;
    
    // Wait for some time
    #200;
    
    // Apply reset again
    rst = 0;
    
    // Wait for some time
    #20;
    
    // Disable reset and enable the PLL
    rst = 1;
    
    // Wait for some time
    #150;
    
    // Disable the PLL
    enable = 0;
    
    // Stop simulation
    #10 $finish;
  end
endmodule

