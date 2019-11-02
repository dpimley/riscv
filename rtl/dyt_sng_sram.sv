/*
Description: Wrapper module for the Xilinx xpm single port SRAM

Author: David Pimley
*/

`include "common_types.vh"
`include "dyt_ram_if.vh"

import common_types::*;

module dyt_sng_sram
(
    input logic clk,
    input logic n_rst,
    dyt_sram_if.sram sram_if
);

    // Declare Intermediate Signals
    word_t          masked_address;
    logic           dbiterra, sbiterra, rst;
    
    // Provide "Cheap Modulus to Address" (32 Bit Signal -> 6 Bit Signal)
    assign masked_address = sram_if.sram_address[5:0];
    
    // Module has an active-high reset
    assign rst = ~n_rst;

    // xpm_memory_spram: Single Port RAM
    // Xilinx Parameterized Macro, version 2019.2
    xpm_memory_spram #(
      .ADDR_WIDTH_A(SRAM_ADDR_WIDTH),                   // DECIMAL
      .AUTO_SLEEP_TIME(SRAM_AUTO_SLEEP),                // DECIMAL
      .BYTE_WRITE_WIDTH_A(SRAM_BYTE_WRITE_WIDTH),       // DECIMAL
      .CASCADE_HEIGHT(SRAM_CASCADE_HEIGHT),             // DECIMAL
      .ECC_MODE(SRAM_ECC_MODE),                         // String
      .MEMORY_INIT_FILE(SRAM_MEMORY_INIT_FILE),         // String
      .MEMORY_INIT_PARAM(SRAM_MEMORY_INIT_PARAM),       // String
      .MEMORY_OPTIMIZATION(SRAM_MEMORY_OPTIMIZATION),   // String
      .MEMORY_PRIMITIVE(SRAM_MEMORY_PRIMITIVE),         // String
      .MEMORY_SIZE(SRAM_MEMORY_SIZE),                   // DECIMAL
      .MESSAGE_CONTROL(SRAM_MESSAGE_CONTROL),           // DECIMAL
      .READ_DATA_WIDTH_A(SRAM_READ_DATA_WIDTH),         // DECIMAL
      .READ_LATENCY_A(SRAM_READ_LATENCY),               // DECIMAL
      .READ_RESET_VALUE_A(SRAM_READ_RESET_VALUE),       // String
      .RST_MODE_A(SRAM_RESET_MODE),                     // String
      .SIM_ASSERT_CHK(SRAM_SIM_ASSERT_CHECK),           // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_MEM_INIT(SRAM_USE_MEM_INIT),                 // DECIMAL
      .WAKEUP_TIME(SRAM_WAKEUP_TIME),                   // String
      .WRITE_DATA_WIDTH_A(SRAM_WRITE_DATA_WIDTH),       // DECIMAL
      .WRITE_MODE_A(SRAM_WRITE_MODE)                    // String
    )
    
    xpm_memory_spram_inst (
      .dbiterra(dbiterra),                              // 1-bit output: Status signal to indicate double bit error occurrence
                                                        // on the data output of port A.

      .douta(sram_if.sram_r_data),                      // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      .sbiterra(sbiterra),                              // 1-bit output: Status signal to indicate single bit error occurrence
                                                        // on the data output of port A.

      .addra(masked_address),                           // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      .clka(clk),                                       // 1-bit input: Clock signal for port A.
      .dina(sram_if.sram_w_data),                       // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .ena(1'b1),                                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                                        // cycles when read or write operations are initiated. Pipelined
                                                        // internally.

      .injectdbiterra(1'b0),                            // 1-bit input: Controls double bit error injection on input data when
                                                        // ECC enabled (Error injection capability is not available in
                                                        // "decode_only" mode).

      .injectsbiterra(1'b0),                            // 1-bit input: Controls single bit error injection on input data when
                                                        // ECC enabled (Error injection capability is not available in
                                                        // "decode_only" mode).

      .regcea(sram_if.sram_ren),                        // 1-bit input: Clock Enable for the last register stage on the output
                                                        // data path.

      .rsta(rst),                                       // 1-bit input: Reset signal for the final port A output register stage.
                                                        // Synchronously resets output port douta to the value specified by
                                                        // parameter READ_RESET_VALUE_A.

      .sleep(1'b0),                                     // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea(sram_if.sram_wen)                            // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
                                                        // for port A input data port dina. 1 bit wide when word-wide writes are
                                                        // used. In byte-wide write configurations, each bit controls the
                                                        // writing one byte of dina to address addra. For example, to
                                                        // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
                                                        // is 32, wea would be 4'b0010.

    );

    // End of xpm_memory_spram_inst instantiation
				
endmodule			