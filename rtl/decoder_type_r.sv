`include "definitions.svh"

module decoder_type_r (
	input  logic [31:0] instr,
	output logic [3:0]  alu_op
);

	logic [2:0] funct3;
	logic [6:0] funct7;

	always_comb begin
		funct3 = instr[14:12];
		funct7 = instr[31:25];

		alu_op = ALU_INV;

		case ({funct7, funct3})
			{7'b0000000, 3'b000}: alu_op = ALU_ADD;
			{7'b0100000, 3'b000}: alu_op = ALU_SUB;
			{7'b0000000, 3'b001}: alu_op = ALU_SLL;
			{7'b0000000, 3'b010}: alu_op = ALU_SLT;
			{7'b0000000, 3'b011}: alu_op = ALU_SLTU;
			{7'b0000000, 3'b100}: alu_op = ALU_XOR;
			{7'b0000000, 3'b101}: alu_op = ALU_SRL;
			{7'b0100000, 3'b101}: alu_op = ALU_SRA;
			{7'b0000000, 3'b110}: alu_op = ALU_OR;
			{7'b0000000, 3'b111}: alu_op = ALU_AND;
		endcase
	end

endmodule
