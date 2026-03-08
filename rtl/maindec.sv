/**
    -> main component of controller
    -> determines enable and mux signals of most components in datapath according to opcode
    -> instructions with same opcodes are very similar to each other and have same type (R,I,B,S) ,
        so that their most signals are same(not mean all inst. of a type have the same opcode)
    -> the distinction of instruction with same opcodes comes from funct3
    -> if same opcode same funct3 , funct7 disctincs (only R-Type have funct7 since its the most general operation type)
**/
module maindec
(     
  input  logic [6:0] op,              //  opcode            

  output logic [1:0] ALUOp,            // to aludec                     
  output logic [1:0] ResultSrc,       
  output logic       ALUSrc,          // rd2 or imm         
  output logic [2:0] ImmSrc,  
  output logic       Branch, 
  output logic       Jump, 
  output logic       MemWrite,    
  output logic       RegWrite
);

  logic [10:0] controls;

  assign {RegWrite, ImmSrc, ALUSrc, MemWrite,ResultSrc, Branch, ALUOp, Jump} = controls;

  always_comb
    case(op)
      // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
      7'b0000011: controls = 11'b1_00_1_0_01_0_00_0;  // lw (I-Type) ! not same opcode with other I-Types
      7'b0100011: controls = 11'b0_01_1_1_00_0_00_0;  // sw (S-Type)
      7'b0110011: controls = 11'b1_xx_0_0_00_0_10_0;  // R-type
      7'b1100011: controls = 11'b0_10_0_0_00_1_01_0;  // beq (B-Type)
      7'b0010011: controls = 11'b1_00_1_0_00_0_10_0;  // I-type 
      7'b1101111: controls = 11'b1_11_0_0_10_0_00_1;  // jal (J-Type)
      default:    controls = 11'bx_xx_x_x_xx_x_xx_x; 
    endcase

endmodule