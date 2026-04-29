`include "definitions.svh"

module decoder_type_u (
	input  logic [31:0] instr,
	output logic [31:0] imm,
	output logic [3:0]  u_op
);

	assign imm = {instr[31:12], 12'b0};
	assign u_op  = (instr[5]) ? U_LUI : U_AUIPC;

endmodule