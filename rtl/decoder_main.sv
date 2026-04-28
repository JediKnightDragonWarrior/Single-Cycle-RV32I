`include "definitions.svh"

module decoder_main 
(
	input  logic [31:0] instr,
	
	output logic [4:0]  rs1,
	output logic [4:0]  rs2,
	output logic [4:0]  rd,
	output logic [31:0] imm,
	output logic [3:0]  alu_op,
	output logic [3:0]  memory_op,
	output logic [3:0]  branch_op,
	output logic [3:0]  u_op,
	output logic [3:0]  jump_op,
	output logic [31:0] l_address,
	output logic [31:0] s_address,
	output logic [2:0]  reg_write_src,
	output logic [1:0]  alu_src
);

	// Register specifiers sit at fixed bit positions across all instruction types
	assign rs1 = instr[19:15];
	assign rs2 = instr[24:20];
	assign rd  = instr[11:7];

	logic [6:0] opcode;
	assign opcode = instr[6:0];

	// Immediate and operation outputs from each sub-decoder
	logic [31:0] i_imm, s_imm, l_imm, b_imm, u_imm, j_imm;
	logic [3:0]  r_alu_op, i_alu_op, s_memory_op, l_memory_op, b_branch_op, u_u_op, j_jump_op;


	// Sub-decoders: always active, each decodes its own fields from instr locally
	decoder_type_r u_r_type (.instr,              .alu_op(r_alu_op));
	decoder_type_i u_i_type (.instr, .imm(i_imm), .alu_op(i_alu_op));
	decoder_type_s u_s_type (.instr, .imm(s_imm), .store_op(s_memory_op), .address(s_address));	
	decoder_type_l u_l_type (.instr, .imm(l_imm), .load_op(l_memory_op), .address(l_address));	
	decoder_type_b u_b_type (.instr, .imm(b_imm), .branch_op(b_branch_op));
	decoder_type_u u_u_type (.instr, .imm(u_imm), .u_op(u_u_op));
	decoder_type_j u_j_type (.instr, .imm(j_imm), .jump_op(j_jump_op));

	always_comb begin
		imm             = 32'd0;
		alu_op          = OP_INV;
		memory_op       = OP_INV;
		branch_op       = OP_INV;
		u_op            = OP_INV;
		jump_op         = OP_INV;
		alu_src         = ALSRC_INV;
		reg_write_src   = REG_INV;
        

		case (opcode)
			
            OPCODE_RTYPE:             
                begin 
                    alu_op          = r_alu_op; 
                    alu_src         = ALSRC_R;   
                    reg_write_src   = REG_ALU;
                end 	

			OPCODE_ITYPE:             
                begin
                    imm             = i_imm;
                    alu_op          = i_alu_op; 
                    alu_src         = ALSRC_I;   
                    reg_write_src   = REG_ALU;
                end

			OPCODE_STYPE:             
                begin
                    imm             = s_imm;
                    memory_op       = s_memory_op; 
					alu_op          = ALU_ADD; 
                    alu_src         = ALSRC_I;   
                end

			OPCODE_LTYPE:             
                begin
                    imm             = l_imm;
                    memory_op       = l_memory_op; 
                    alu_src         = ALSRC_I;   
					alu_op          = ALU_ADD; 
                    reg_write_src   = REG_DATA;
                end

			OPCODE_BTYPE:             
                begin
                    imm             = b_imm;
                    branch_op       = b_branch_op; 
                end

			OPCODE_LUI, OPCODE_AUIPC: 
                begin
                    imm             = u_imm;
                    u_op            = u_u_op; 
                    reg_write_src   = REG_U;
                end

			OPCODE_JAL:               
                begin
                    imm             = j_imm;
                    jump_op         = j_jump_op; 
                    reg_write_src   = REG_PC;
                end

			default: ;
		endcase
	end

endmodule
