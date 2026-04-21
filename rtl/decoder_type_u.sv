`include "definitions.svh"

module decoder_type_u (
	input  logic [31:0] instr,
	output logic [31:0] imm,
	output logic [3:0]  u_op);

	always_comb begin
		imm    = {instr[31:12], 12'b0};

		// U-type module serves only LUI/AUIPC decode selected by top-level opcode dispatch.
		u_op  = (instr[5]) ? U_LUI : U_AUIPC;
	end

endmodule