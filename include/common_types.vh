/*
Description: Shared types folder that will make life easier

Author: Yash Bharatula
*/

`ifndef COMMON_TYPES_VH
`define COMMON_TYPES_VH

package common_types;

    // Common Configurations & Types
    parameter WORD_W    = 32;
    parameter WBYTES    = WORD_W/8;
    
    typedef logic   [WORD_W-1:0]                    word_t;
    typedef logic   [(WORD_W/2)-1:0]                hword_t;
    typedef logic   [(WORD_W/WBYTES):0]             byte_t;
    
    // Register File Configurations & Types
    parameter RF_REGISTERS                          = 16;
    parameter RF_ADDRESS_WIDTH                      = $clog2(RF_REGISTERS);
    
    typedef logic   [RF_ADDRESS_WIDTH-1:0]          rf_addr_t;
    typedef logic   [WORD_W-1:0][RF_REGISTERS-1:0]  rf_t;
    
    // SRAM Configurations
    parameter SRAM_ADDR_WIDTH                       = $clog2(SRAM_MEMORY_SIZE);
    parameter SRAM_AUTO_SLEEP                       = 0;
    parameter SRAM_BYTE_WRITE_WIDTH                 = WORD_W;
    parameter SRAM_CASCADE_HEIGHT                   = 0;
    parameter SRAM_ECC_MODE                         = "no_ecc";
    parameter SRAM_MEMORY_INIT_FILE                 = "sraminit.hex";
    parameter SRAM_MEMORY_INIT_PARAM                = "0";
    parameter SRAM_MEMORY_OPTIMIZATION              = "true";
    parameter SRAM_MEMORY_PRIMITIVE                 = "auto";
    parameter SRAM_MEMORY_SIZE                      = 2048;
    parameter SRAM_MESSAGE_CONTROL                  = 0;
    parameter SRAM_READ_DATA_WIDTH                  = WORD_W;
    parameter SRAM_READ_LATENCY                     = 2;
    parameter SRAM_READ_RESET_VALUE                 = "0";
    parameter SRAM_RESET_MODE                       = "ASYNC";
    parameter SRAM_SIM_ASSERT_CHECK                 = 0;
    parameter SRAM_USE_MEM_INIT                     = 1;
    parameter SRAM_WAKEUP_TIME                      = "disable_sleep";
    parameter SRAM_WRITE_DATA_WIDTH                 = WORD_W;
    parameter SRAM_WRITE_MODE                       = "read_first";

endpackage

`endif /* COMMON_TYPES_VH */

