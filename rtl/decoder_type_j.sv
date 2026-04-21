`include "definitions.svh"

module j_type_decoder (
	input  logic [31:0] instr,
	output logic [31:0] imm,
	output logic [3:0]  jump_op);

	assign imm     = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
	assign jump_op = JUMP_JAL;

endmodule