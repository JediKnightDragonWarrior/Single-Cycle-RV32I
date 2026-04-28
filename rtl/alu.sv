`include "definitions.svh"

module alu (
    input  logic [3:0]  alu_op,         
    input  logic [31:0] rs1,        
    input  logic [31:0] rs2,           
    output logic [31:0] alu_result    
);
    
    always_comb begin
        case (alu_op)
            ALU_ADD:    alu_result = rs1 + rs2;                                       
            ALU_SUB:    alu_result = rs1 - rs2;                                       
            ALU_SLL:    alu_result = shifter_out;                                                                                          
            ALU_SLT:    alu_result = ($signed(rs1) < $signed(rs2)) ? 32'd1 : 32'd0;                                                    
            ALU_SLTU:   alu_result = rs1 < rs2;                                                                                        
            ALU_XOR:    alu_result = rs1 ^ rs2;                                       
            ALU_SRL:    alu_result = shifter_out;                                                                                          
            ALU_SRA:    alu_result = shifter_out;                                                                                          
            ALU_OR:     alu_result = rs1 | rs2;                                       
            ALU_AND:    alu_result = rs1 & rs2;                                       
            default:    alu_result = 'x;                                                
        endcase
    end

    logic   [1:0]   mode;
    logic   [1:0]   shamt;
    logic   [31:0]  shifter_out;

    always_comb begin
        case (alu_op)
            ALU_SLL:    mode = 2'd2;                                                                                          
            ALU_SRL:    mode = 2'd1;                                                                                          
            ALU_SRA:    mode = 2'd0;                                                                                          
            default:    mode = 'x;                                                
        endcase
    end

    barrel_shifter sh(
        .mode(mode),
        .shamt(rs2[4:0]),
        .src(rs1),
        .result(shifter_out)
    );

endmodule