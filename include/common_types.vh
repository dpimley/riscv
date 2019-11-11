/*
Description: Shared types folder that will make life easier

Author: Yash Bharatula, David Pimley
*/

`ifndef COMMON_TYPES_VH
`define COMMON_TYPES_VH

package common_types;

    // Common Configurations & Types
    parameter WORD_W    = 32;
    parameter HWORD_W   = WORD_W/2;
    parameter BYTE_W    = 8;
   
    parameter WBYTES    = WORD_W/8;
    
    typedef logic   [WORD_W-1:0]                    word_t;
    typedef logic   [(WORD_W/2)-1:0]                hword_t;
    typedef logic   [(WORD_W/WBYTES):0]             byte_t;
    
    // Opcode Formatting
    parameter OPCODE_W          = 7;
    
    typedef enum logic [OPCODE_W-1:0] {
        OPCODE_LUI              = 7'b0110111,
        OPCODE_AUIPC            = 7'b0010111,
        OPCODE_JAL              = 7'b1101111,
        OPCODE_JALR             = 7'b1100111,
        OPCODE_BRANCH           = 7'b1100011,
        OPCODE_LOAD             = 7'b0000011,
        OPCODE_STORE            = 7'b0100011,
        OPCODE_ITYPE            = 7'b0010011,
        OPCODE_RTYPE            = 7'b0110011
    } opcode_t;
    
    // Funct3 Formatting
    parameter FUNCT3_W          = 3;
    
    // JALR Funct3 Types
    typedef enum logic [FUNCT3_W-1:0] {
        FUNCT3_LUI              = 3'b000
    } funct3_jalr_t;
    
    // Branch Funct3 Types
    typedef enum logic [FUNCT3_W-1:0] {
        FUNCT3_BEQ              = 3'b000,
        FUNCT3_BNE              = 3'b001,
        FUNCT3_BLT              = 3'b100,
        FUNCT3_BGE              = 3'b101,
        FUNCT3_BLTU             = 3'b110,
        FUNCT3_BGEU             = 3'b111
    } funct3_branch_t;
    
    // Load Funct3 Types
    typedef enum logic [FUNCT3_W-1:0] {
        FUNCT3_LB               = 3'b000,
        FUNCT3_LH               = 3'b001,
        FUNCT3_LW               = 3'b010,
        FUNCT3_LBU              = 3'b100,
        FUNCT3_LHU              = 3'b101
    } funct3_load_t;
    
    // Store Funct3 Types
    typedef enum logic [FUNCT3_W-1:0] {
        FUNCT3_SB               = 3'b000,
        FUNCT3_SH               = 3'b001,
        FUNCT3_SW               = 3'b010
    } funct3_store_t;
    
    // Immediate Funct3 Types
    typedef enum logic [FUNCT3_W-1:0] {
        FUNCT3_ADDI             = 3'b000,
        FUNCT3_SLTI             = 3'b010,
        FUNCT3_SLTIU            = 3'b011,
        FUNCT3_XORI             = 3'b100,
        FUNCT3_ORI              = 3'b110,
        FUNCT3_ANDI             = 3'b111,
        FUNCT3_SLLI             = 3'b001,
        FUNCT3_SRI              = 3'b101            // shift right
    } funct3_immediate_t;
    
    // Register Funct3 Types
    typedef enum logic [FUNCT3_W-1:0] {
        FUNCT3_ARITH            = 3'b000,           // add / sub
        FUNCT3_SLL              = 3'b001,
        FUNCT3_SLT              = 3'b010,
        FUNCT3_SLTU             = 3'b011,
        FUNCT3_XOR              = 3'b100,
        FUNCT3_SR               = 3'b101,           // shift right
        FUNCT3_OR               = 3'b110,
        FUNCT3_AND              = 3'b111
    } funct3_register_t;
    
    // Funct7 Formatting
    parameter FUNCT7_W          = 7;
    
    // Register Type Funct7 Types
    typedef enum logic [FUNCT7_W-1:0] {
        FUNCT7_TYP              = 7'b0000000,       // most instructions
        FUNCT7_ATYP             = 7'b0100000        // sub and sra
    } funct7_register_t;
    
    // Immediate Type Funct7 Types (Shift, Not necessarily funct7 but rather msb 7 bits)
    typedef enum logic [FUNCT7_W-1:0] {
        FUNCT7_SL               = 7'b0000000,       // logical shift left & right
        FUNCT7_SRAI             = 7'b0100000        // arithmetic shift right
    } funct7_immediate_t;
    
    // ALU Opcodes & Operations
    parameter ALU_OP_W          = 4;
    
    // ALU Opcode & Operations Types
    typedef enum logic [ALU_OP_W-1:0] {
        ALU_ADD,
        ALU_ADDU,
        ALU_SUB,
        ALU_SUBU,
        ALU_OR,
        ALU_AND,
        ALU_XOR,
        ALU_SRA,
        ALU_SRL,
        ALU_SLL,
        ALU_SLT,
        ALU_SLTU
    } alu_op_t;
    
    // Register File Configurations & Types
    parameter RF_REGISTERS                          = 16;
    parameter RF_ADDRESS_WIDTH                      = $clog2(RF_REGISTERS);
    
    typedef logic   [RF_ADDRESS_WIDTH-1:0]          rf_addr_t;
    typedef logic   [RF_REGISTERS-1:0][WORD_W-1:0]  rf_t;
    
    // LSU Configurations & Types
    typedef enum logic [1:0] {
        MEM_W_WORD,
        MEM_W_HWORD,
        MEM_W_HWORDU,
        MEM_W_BYTE,
        MEM_W_BYTEU
    } lsu_mem_w_type_t;
    
    // SRAM Configurations
    parameter SRAM_MEMORY_SIZE                      = 2048;
    parameter SRAM_ADDR_WIDTH                       = $clog2(SRAM_MEMORY_SIZE);
    parameter SRAM_AUTO_SLEEP                       = 0;
    parameter SRAM_BYTE_WRITE_WIDTH                 = WORD_W;
    parameter SRAM_CASCADE_HEIGHT                   = 0;
    parameter SRAM_ECC_MODE                         = "no_ecc";
    parameter SRAM_MEMORY_INIT_FILE                 = "sraminit.hex";
    parameter SRAM_MEMORY_INIT_PARAM                = "0";
    parameter SRAM_MEMORY_OPTIMIZATION              = "true";
    parameter SRAM_MEMORY_PRIMITIVE                 = "auto";
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

