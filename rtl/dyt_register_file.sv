/*  Description: Register file for RISC-V. 32 bits wide, register 0 is set to 0 
 
    Base ISA -> 32 registers (x0 - x31) 
        -x0 holds the constant 0
        -user visible program counter register, holds address of current instruction
        -standard sofware calling convention, should use x1 to store return address on a call

    There is an ISA E for embedded applications that defines only 16 registerss
    
    Flip flop based. The ETH zero risc-y used differentiated between a latch based and ff based. 
    supposedly ff better for fpga so using that
    
    Did some reading. Register file needs a few things: 2 simulaneous reads, one write. 
        That boils down to the following signals: rst, clk, data (32 bits), read 1 (32 bits), read 2 (32 bits),
        write enable (1 bit), write address (4 bits), read 1 (4 bits), read 2 (4 bits)
    
    Author: Tommy Krause
    Date: 19 October 2019
*/

`include "common_types.vh"
`include "dyt_register_file_if.vh"

import common_types::*;

module dyt_register_file
(    
    //Reset, Clock, and write enable
    input wire          clk,
    input wire          n_rst,
    dyt_register_file_if.rf rf_if
);

    rf                  rf_reg;
    word_t              n_rf_data; //I guess this is a shadow register of sorts

    // Update Logic for the Register File
    always @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            rf_reg <= '0;
        end else begin
            rf_reg[rf_if.rf_w_sel] <= n_rf_data;
        end
    end
    
    // Combinational Next-Reg Logic
    always_comb begin
        if (rf_if.rf_wen) begin        
            if (rf_if.rf_w_sel == '0) begin
                n_rf_data = '0;
            end else begin
                n_rf_data = rf_if.rf_w_data;
            end
        end
    end

    // Combinatorial Output Logic
    assign rf_if.rf_r_data_0 = rf_reg[rf_if.rf_r_sel_0];
    assign rf_if.rf_r_data_1 = rf_reg[rf_if.rf_r_sel_1];

endmodule
