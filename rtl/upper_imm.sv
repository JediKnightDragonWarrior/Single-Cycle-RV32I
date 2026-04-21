`include "definitions.svh"

module upper_imm
(
    input logic [3:0]  u_op,
    input logic [31:0] imm,
    input logic [31:0] pc,

    output logic [31:0]  upper_imm_result
);

    logic [31:0] shifted_imm;    
    assign shifted_imm = (imm << 12);


    case (u_op)
        U_LUI:      upper_imm_result = shifted_imm;
        U_AUIPC:    upper_imm_result = pc + shifted_imm;
        default:
    endcase


endmodule