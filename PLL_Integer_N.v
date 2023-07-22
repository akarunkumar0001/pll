module PLL_Integer_N (
  input wire clk_in,
  input wire rst,
  input wire enable,
  output wire clk_out
);

  // Phase Frequency Detector (PFD)
  reg pfd_out;
  always @(posedge clk_in or posedge rst) begin
    if (rst)
      pfd_out <= 1'b0;
    else
      pfd_out <= clk_out ^ clk_in;
  end

  // Charge Pump (CP)
  reg [1:0] cp_out;
  always @(posedge clk_in or posedge rst) begin
    if (rst)
      cp_out <= 2'b0;
    else if (enable)
      cp_out <= pfd_out ? 2'b01 : 2'b10;
  end

  // Loop Filter (LF)
  reg [9:0] lf_out;
  always @(posedge clk_in or posedge rst) begin
    if (rst)
      lf_out <= 10'b0;
    else if (enable)
      lf_out <= lf_out + cp_out;
  end

  // Voltage-Controlled Oscillator (VCO)
  reg [9:0] vco_divider;
  reg vco_out;
  always @(posedge clk_in or posedge rst) begin
    if (rst)
      vco_divider <= 10'b0;
    else if (enable)
      vco_divider <= vco_divider + lf_out;
    vco_out <= vco_divider[9];
  end

  // Output Clock Divider (Divider)
  reg [15:0] divider_count;
  reg [15:0] clk_out_reg;
  always @(posedge clk_in or posedge rst) begin
    if (rst)
      divider_count <= 16'b0;
    else if (enable)
      divider_count <= divider_count + 1'b1;
    clk_out_reg <= divider_count[15];
  end

  assign clk_out = clk_out_reg;

endmodule

