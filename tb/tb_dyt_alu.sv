/*
Description: Unit level testbench to test basic functionality of the ALU

Author: David Pimley
*/

`include "../include/common_types.vh"
`include "../include/dyt_alu_if.vh"

import common_types::*;

`timescale 1 ns / 1 ns

module tb_dyt_alu;    
    // Declare Necessary Signals through the Register File Interface
    dyt_alu_if alu_if();
    
    // Instantiate the DUT
    dyt_alu DUT(alu_if);
 
    // Run the Program
    alu_tb PROG(alu_if);
    
endmodule

program alu_tb(dyt_alu_if alu_if);
   
    // Declare Internal Signals
    int alu_test_num  = 0;
    int alu_test_pass = 0;
    int alu_test_seq  = 32;

    alu_op_t                _alu_op;
    word_t                  _port_0;
    word_t                  _port_1;
    word_t                  _port_out;
    
    logic                   _negative;
    logic                   _overflow;
    logic                   _zero;
    
    logic                   _negative_switch;
    
    word_t                  _calc_out;
    
    initial begin
    
    /*
        Test Sequence
        
        1. Sequence through each operation
        2. Overflow Detection
        3. Zero Detection
        4. Negative Detection
        
    */
    
        // ALU_ADD
        _alu_op                     = ALU_ADD;
        $display("ADD OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Unsigned Adds so Randomly Determine Sign
            _negative_switch        = $random() & (1'b1 << (WORD_W-1));
            
            // Determine Input Values
            _port_0                 = $random() | _negative_switch;
            _port_1                 = $random() | _negative_switch;
            
            // Calculate Correct Value
            _calc_out               = $signed(_port_0) + $signed(_port_1);
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_ADDU;
        $display("ADDU OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Determine Input Values
            _port_0                 = $random();
            _port_1                 = $random();
            
            // Calculate Correct Value
            _calc_out               = _port_0 + _port_1;
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_SUB;
        $display("SUB OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Unsigned Adds so Randomly Determine Sign
            _negative_switch        = $random() & (1'b1 << (WORD_W-1));
            
            // Determine Input Values
            _port_0                 = $random() | _negative_switch;
            _port_1                 = $random() | _negative_switch;
            
            // Calculate Correct Value
            _calc_out               = $signed(_port_1) - $signed(_port_0);
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_SUBU;
        $display("SUBU OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Determine Input Values
            _port_0                 = $random();
            _port_1                 = $random();
            
            // Calculate Correct Value
            _calc_out               = _port_1 - _port_0;
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_OR;
        $display("OR OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Determine Input Values
            _port_0                 = $random();
            _port_1                 = $random();
            
            // Calculate Correct Value
            _calc_out               = _port_0 | _port_1;
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_AND;
        $display("AND OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin   
            // Determine Input Values
            _port_0                 = $random();
            _port_1                 = $random();
            
            // Calculate Correct Value
            _calc_out               = _port_0 & _port_1;
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_XOR;
        $display("XOR OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Determine Input Values
            _port_0                 = $random();
            _port_1                 = $random();
            
            // Calculate Correct Value
            _calc_out               = _port_0 ^ _port_1;
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_SRA;
        $display("SRA OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Determine Input Values
            _port_0                 = $random();
            _port_1                 = $random();
            
            // Calculate Correct Value
            _calc_out               = _port_0 >>> _port_1;
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_SRL;
        $display("SRL OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Determine Input Values
            _port_0                 = $random();
            _port_1                 = $random();
            
            // Calculate Correct Value
            _calc_out               = _port_0 >> _port_1;
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_SLL;
        $display("SLL OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Determine Input Values
            _port_0                 = $random();
            _port_1                 = $random();
            
            // Calculate Correct Value
            _calc_out               = _port_0 << _port_1;
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_SLT;
        $display("SLT OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Determine Input Values
            _port_0                 = $random();
            _port_1                 = $random();
            
            // Calculate Correct Value
            if ($signed(_port_0) < $signed(_port_1)) begin
                _calc_out = 1;
            end else begin
                _calc_out = 0;
            end
            
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
            
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        _alu_op                     = ALU_SLTU;
        $display("SLTU OPERATIONS :: Time - %t ns", $time);
        for (int i = 0; i < alu_test_seq; i++) begin
            // Determine Input Values
            _port_0                 = $random();
            _port_1                 = $random();
            
            // Calculate Correct Value
             if (_port_0 < _port_1) begin       
                 _calc_out = 1;           
             end else begin           
                 _calc_out = 0;           
             end           
             
            // Run the Values through the ALU
            alu_perform_operation(_port_0, _port_1, _alu_op, _port_out);
             
            // Assert The Values are the Same
            assert (_port_out == _calc_out) begin
                $display("Test Case %d Passed :: Time - %t ns", alu_test_num, $time);
                alu_test_pass++;
            end else begin
                $display("Test Case %d Failed :: Time - %t ns", alu_test_num, $time);
            end
            alu_test_num++;
        end
        
        assert (alu_test_pass == alu_test_num) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("TESTS FAILED");
        end
        
    end /* initial begin */
   
    task alu_perform_operation;
    input [WORD_W-1:0]              port_0;
    input [WORD_W-1:0]              port_1;
    input alu_op_t                  alu_op;
    output [WORD_W-1:0]             port_out;
        // Assign the Internal ALU Signals
        alu_if.alu_port_0           = port_0;
        alu_if.alu_port_1           = port_1;
        alu_if.alu_op               = alu_op;
        
        // Delay Combinationally
        #5
        
        // Assign Output
        port_out                    = alu_if.alu_port_out;
        
        // System Display
        $display("ALU Perform Operation :: Port_0 - %h :: Port_1 - %h :: Port_Out - %h :: Time - %t ns", port_0, port_1, port_out, $time);
        
        // Reset the Signals
        alu_if.alu_port_0           = '0;
        alu_if.alu_port_1           = '0;
    endtask

                          
endprogram
