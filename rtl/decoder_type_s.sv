`include "definitions.svh"

module decoder_type_s (
	input  logic [31:0] instr,
	output logic [31:0] imm,
	output logic [3:0]  store_op
);

	logic [2:0] funct3;
	assign funct3 = instr[14:12];

	assign imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};

	always_comb begin
		store_op = STORE_INV;

		case (funct3)
			3'b000: store_op = STORE_SB;
			3'b001: store_op = STORE_SH;
			3'b010: store_op = STORE_SW;
			default: store_op = STORE_INV;
		endcase
	
	end


endmodule