/*
Description: Unit level testbench to test basic functionality of the register
             file.

Author: Yash Bharatula & David Pimley
*/


`include "../include/common_types.vh"
`include "../include/dyt_register_file_if.vh"

import common_types::*;

`timescale 1 ns / 1ns

module tb_dyt_register_file;                                                                                                                                           

    // Declare a PERIOD of 10 (i.e. 100 MHz Clock)
    parameter PERIOD        = 10;
    
    // Declare Local Necessary Signals
    logic clk = 1; 
    logic n_rst = 1;
    
    // Declare Necessary Signals through the Register File Interface
    dyt_register_file_if rf_if();
    
    // Instantiate the DUT
    dyt_register_file DUT(clk, n_rst, rf_if);
 
    // Start the Clock
    always #(PERIOD/2) clk = !clk;
    
    // Run the Program
    register_file_tb PROG(clk, n_rst, rf_if);
    
endmodule

program register_file_tb(input  logic clk,
                         output logic n_rst,
                         dyt_register_file_if rf_if);
   
    // Declare Internal Signals
    int register_file_test_num  = 1;
    int register_file_test_pass = 0;
    int register_file_test_seq  = 32;
    
    int register_file_idx       = 0;
    
    word_t                  _w_data;
    rf_addr_t               _w_addr;
    
    word_t                  _r_data;
    rf_addr_t               _r_addr;
    logic                   _r_out_sel;
    
    initial begin
    
    /*
        Test Sequence
        
        1. A Series of Writes and Then Reads
        2. Ensure W_Sel @ 0x0 is always 0
        3. Asynchronous Reset
        
    */
    
        // Start With an Asynchronous Reset
        register_file_reset();
    
        // Write -> Read Checking
        for (register_file_test_num = 1; register_file_test_num <= register_file_test_seq; register_file_test_num++) begin
            _w_data = $random();
            _w_addr = $random() & 4'hF;
            
            if (_w_addr == 4'h0) begin
                _w_addr++;
            end
            
            _r_addr = _w_addr;
            _r_out_sel = $random() & 1'b1;
            
            register_file_write(_w_data, _w_addr);
            register_file_read(_r_out_sel, _r_addr, _r_data);
        
            // Assert The Values are the Same
            assert (_w_data == _r_data) begin
                $display("Test Case %d Passed :: Time - %t ns", register_file_test_num, $time);
                register_file_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", register_file_test_num, $time);
            end
        end
        
        // Zero W_Sel Check
        register_file_reset();
        
        _w_data = $random();
        _w_addr = 0;
        
        _r_addr = _w_addr;
        _r_out_sel = $random() & 1'b1;
        
        register_file_write(_w_data, _w_addr);
        register_file_read(_r_out_sel, _r_addr, _r_data);
   
        // Assert The Values are the Same
        assert (_r_data == '0) begin
            $display("Test Case %d Passed :: Time - %t ns", register_file_test_num, $time);
            register_file_test_pass++;
        end else begin
            $display("Test Case %d Failed :: Time - %t ns", register_file_test_num, $time);
        end
        
        // Asynchronous Reset Check
        register_file_reset();
        
        for (register_file_idx = 1; register_file_idx < RF_REGISTERS; register_file_idx++) begin
            register_file_test_num++;
            
            _r_addr = register_file_idx;
            _r_out_sel = $random() & 1'b1;

            // Read the Register Values (Should all be zero)
            register_file_read(_r_out_sel, _r_addr, _r_data);
        
            // Assert The Values are the Same
            assert (_r_data == '0) begin
                $display("Test Case %d Passed :: Time - %t ns", register_file_test_num, $time);
                register_file_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", register_file_test_num, $time);
            end
        end
        
        assert (register_file_test_pass == register_file_test_num) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("TESTS FAILED");
        end
        
    end /* initial begin */
   
    // Program Tasks & Functions
    task register_file_reset;
        n_rst = 1'b0;
        @(posedge clk);
        $display("Reset Register File :: Time - %t ns", $time);
        n_rst = 1'b1;
        @(posedge clk);
    endtask
    
    task register_file_write;
    input [WORD_W-1:0]              w_data;
    input [RF_ADDRESS_WIDTH-1:0]    w_addr;
        // Assign the Internal Register File Signals
        rf_if.rf_wen                = 1'b1;
        rf_if.rf_w_data             = w_data;
        rf_if.rf_w_sel              = w_addr;
        
        // Clock in the Data
        @(posedge clk);
        
        // System Display
        $display("Write Register File :: Data - %h :: W_Sel - %h :: Time - %t ns", w_data, w_addr, $time);
        
        // Reset the Signals
        rf_if.rf_wen                = '0;
        rf_if.rf_w_data             = '0;
        rf_if.rf_w_sel              = '0;
        
        // Clock in the New Signals
        @(posedge clk);
    endtask
    
    task register_file_read;
    input                           r_out_sel;
    input [RF_ADDRESS_WIDTH-1:0]    r_addr;
    output [WORD_W-1:0]             r_data;
        // Assign the Internal Register File Signals
        rf_if.rf_r_sel_0            = r_out_sel ? r_addr : '0;
        rf_if.rf_r_sel_1            = ~_r_out_sel ? r_addr : '0;
        
        // Clock in the Data
        @(posedge clk);
        
        // Get the Data
        r_data                      = r_out_sel ? rf_if.rf_r_data_0 : rf_if.rf_r_data_1;
       
        // System Display
        $display("Read Register File :: Data - %h :: R_Sel - %h :: Time - %t ns", r_data, r_addr, $time);
        
        // Reset the Signals
        rf_if.rf_r_sel_0            = '0;
        rf_if.rf_r_sel_1            = '0;
        
        // Clock in the New Signals
        @(posedge clk);
    endtask
                          
endprogram