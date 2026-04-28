`include "definitions.svh"

module upper_imm
(
    input logic [3:0]  u_op,
    input logic [31:0] imm,
    input logic [31:0] pc,

    output logic [31:0]  upper_imm_result
);

    // imm zaten decoder_type_u'dan {instr[31:12], 12'b0} olarak geliyor
    // tekrar kaydırmaya gerek yok

    always_comb begin
    
        case (u_op)
            U_LUI:      upper_imm_result = imm;
            U_AUIPC:    upper_imm_result = pc + imm;
            default:    upper_imm_result = 32'd0;
        endcase

    end

endmodule