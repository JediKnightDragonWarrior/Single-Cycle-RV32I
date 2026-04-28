`include "definitions.svh"

module decoder_type_l (
	input  logic [31:0] instr,
	output logic [31:0] imm,
	output logic [3:0]  load_op
);

	logic [2:0] funct3;
	assign funct3 = instr[14:12];

	assign imm = {{20{instr[31]}}, instr[31:20]};

	always_comb begin
		load_op = LOAD_INV;

		case (funct3)
			3'd0:	 load_op = LOAD_LB;
			3'd1:	 load_op = LOAD_LH;
			3'd2:	 load_op = LOAD_LW;
			3'd4:	 load_op = LOAD_LBU;
			3'd5:	 load_op = LOAD_LHU;
			default: load_op = LOAD_INV;
		endcase
	
	end

endmodule