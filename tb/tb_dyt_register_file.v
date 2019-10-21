/* 
* Author: Yash Bharatula
*
*/
module tb_dyt_register_file;                                                                                                                                           
  /* Make a reset that pulses once. */
  
  reg reset = 0;
/*
  initial begin
     $dumpfile("work/tb_dyt_register_file.vcd");
     $dumpvars(0,tb_dyt_register_file);

     # 17 reset = 1;
     # 11 reset = 0;
     # 5  reset =0;
     # 513 $finish;
  end
  */
  /* Make a regular pulsing clock. */
  logic clk = 0;
  always #1 clk = !clk;
  logic w_en;
  logic [3:0] w_addr, r_a_addr, r_b_addr;
  logic [31:0] w_data, r_a_data, r_b_data;
  dyt_register_file rf ( reset, clk, w_en, w_addr, w_data, r_a_addr, r_a_data, r_b_addr, r_b_data );

  initial begin
    //@(posedge clk)
    //reset = 1;
    //@(posedge clk)
    //# 10 reset = 0;
    //@(posedge clk)
     $dumpfile("work/tb_dyt_register_file.vcd");
     $dumpvars(0,tb_dyt_register_file);

     # 17 reset = 1;
     # 11 reset = 0;
     # 5  reset =0;
    //#520;
    w_en = '1;
    w_addr = 4'd3;
    w_data = 32'hDEADBEEF;
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    # 10;
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    w_en = '1;
    w_addr = 4'd4;
    w_data = 32'hBEEEEEEE;
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    # 10;
    r_a_addr = 4'd3;
    r_b_addr = 4'd4; 
    w_en = '0;
    w_data = 32'hBADDBADD;

    # 10;

    //$dumpfile("work/tb_dyt_register_file.vcd");
    //$dumpvars(0,tb_dyt_register_file);
    //# 513 $finish; 
    $finish;
  end

endmodule // test

