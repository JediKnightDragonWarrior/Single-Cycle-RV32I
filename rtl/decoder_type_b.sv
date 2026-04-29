`include "definitions.svh"

module decoder_type_b (
	input  logic [31:0] instr,
	output logic [31:0] imm,
	output logic [3:0]  branch_op);

	logic [2:0] funct3;
	assign funct3 = instr[14:12];

	assign imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

	always_comb begin
		branch_op = BRANCH_INV;

		case (funct3)
			3'b000: branch_op = BRANCH_BEQ;
			3'b001: branch_op = BRANCH_BNE;
			3'b100: branch_op = BRANCH_BLT;
			3'b101: branch_op = BRANCH_BGE;
			3'b110: branch_op = BRANCH_BLTU;
			3'b111: branch_op = BRANCH_BGEU;
		endcase
	end

endmodule