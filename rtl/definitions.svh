`ifndef DECODER_COMMON_DEFS_SVH
`define DECODER_COMMON_DEFS_SVH

// Instruction type identifiers
// NOT USED !! 
localparam logic [2:0] TYPE_R   = 3'd0;
localparam logic [2:0] TYPE_I   = 3'd1;
localparam logic [2:0] TYPE_S   = 3'd2;
localparam logic [2:0] TYPE_L   = 3'd3;     
localparam logic [2:0] TYPE_B   = 3'd4;
localparam logic [2:0] TYPE_U   = 3'd5;
localparam logic [2:0] TYPE_J   = 3'd6;
localparam logic [2:0] TYPE_INV = 3'd7;

// RISC-V base opcodes
localparam logic [6:0] OPCODE_RTYPE = 7'b0110011;
localparam logic [6:0] OPCODE_ITYPE = 7'b0010011;
localparam logic [6:0] OPCODE_STYPE = 7'b0100011;
localparam logic [6:0] OPCODE_LTYPE = 7'b0000011;
localparam logic [6:0] OPCODE_BTYPE = 7'b1100011;
localparam logic [6:0] OPCODE_LUI   = 7'b0110111;
localparam logic [6:0] OPCODE_AUIPC = 7'b0010111;
localparam logic [6:0] OPCODE_JAL   = 7'b1101111;

// ALU operation codes (R-type / I-type)
localparam logic [3:0] ALU_ADD  = 4'd0;
localparam logic [3:0] ALU_SUB  = 4'd1;
localparam logic [3:0] ALU_SLL  = 4'd2;
localparam logic [3:0] ALU_SLT  = 4'd3;
localparam logic [3:0] ALU_SLTU = 4'd4;
localparam logic [3:0] ALU_XOR  = 4'd5;
localparam logic [3:0] ALU_SRL  = 4'd6;
localparam logic [3:0] ALU_SRA  = 4'd7;
localparam logic [3:0] ALU_OR   = 4'd8;
localparam logic [3:0] ALU_AND  = 4'd9;
localparam logic [3:0] ALU_INV  = 4'd15;

// Memory operation codes (S-type / L-Type)
localparam logic [3:0] LOAD_LB  = 4'd0;
localparam logic [3:0] LOAD_LH  = 4'd1;
localparam logic [3:0] LOAD_LW  = 4'd2;
localparam logic [3:0] LOAD_LBU = 4'd3;
localparam logic [3:0] LOAD_LHU = 4'd4;
localparam logic [3:0] STORE_SB  = 4'd5;
localparam logic [3:0] STORE_SH  = 4'd6;
localparam logic [3:0] STORE_SW  = 4'd7;
localparam logic [3:0] LOAD_INV  = 4'd15;
localparam logic [3:0] STORE_INV = 4'd15;

// Branch operation codes (B-type)
localparam logic [3:0] BRANCH_BEQ  = 4'd0;
localparam logic [3:0] BRANCH_BNE  = 4'd1;
localparam logic [3:0] BRANCH_BLT  = 4'd2;
localparam logic [3:0] BRANCH_BGE  = 4'd3;
localparam logic [3:0] BRANCH_BLTU = 4'd4;
localparam logic [3:0] BRANCH_BGEU = 4'd5;
localparam logic [3:0] BRANCH_INV  = 4'd15;

// U-type operation codes
localparam logic [3:0] U_LUI   = 4'd0;
localparam logic [3:0] U_AUIPC = 4'd1;
localparam logic [3:0] U_INV   = 4'd15;

// Jump operation codes (J-type)
localparam logic [3:0] JUMP_JAL = 4'd0;
localparam logic [3:0] JUMP_INV = 4'd15;

// Generic invalid operation sentinel (all INV values equal this)
localparam logic [3:0] OP_INV = 4'd15;

// Register File Multiplexer
localparam logic [2:0] REG_ALU  = 3'd0;
localparam logic [2:0] REG_DATA = 3'd1;
localparam logic [2:0] REG_PC   = 3'd2;
localparam logic [2:0] REG_U    = 3'd3;
localparam logic [2:0] REG_INV  = 3'd7;

// ALU Multiplexer
localparam logic [1:0] ALSRC_R   = 2'd0;
localparam logic [1:0] ALSRC_I   = 2'd1;
localparam logic [1:0] ALSRC_INV = 2'd3;


`endif
