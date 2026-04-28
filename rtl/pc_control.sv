`include "definitions.svh"

// PC Control Unit
// Computes the next program counter value based on branch conditions and jump operations.
//
// Inputs:
//   pc         - current program counter
//   imm        - sign-extended immediate (branch offset or jump offset)
//   branch_op  - branch operation code from B-type decoder (OP_INV if not a branch)
//   jump_op    - jump operation code from J-type decoder   (OP_INV if not a jump)
//   rs1_val    - value of source register 1 (used for branch comparisons)
//   rs2_val    - value of source register 2 (used for branch comparisons)
//
// Outputs:
//   pc_next    - computed next PC (PC+4 if no branch/jump taken)
//   pc_taken   - 1 when a branch condition is met or an unconditional jump is executed

module pc_control (
    input  logic [31:0] pc,
    input  logic [31:0] imm,
    input  logic [3:0]  branch_op,
    input  logic [3:0]  jump_op,
    input  logic [31:0] rs1_val,
    input  logic [31:0] rs2_val,
    output logic [31:0] pc_next,
    output logic        pc_taken
);

    // Evaluate branch condition
    logic branch_condition;
    always_comb begin
        case (branch_op)
            BRANCH_BEQ:  branch_condition = (rs1_val == rs2_val);
            BRANCH_BNE:  branch_condition = (rs1_val != rs2_val);
            BRANCH_BLT:  branch_condition = ($signed(rs1_val) <  $signed(rs2_val));
            BRANCH_BGE:  branch_condition = ($signed(rs1_val) >= $signed(rs2_val));
            BRANCH_BLTU: branch_condition = (rs1_val <  rs2_val);
            BRANCH_BGEU: branch_condition = (rs1_val >= rs2_val);
            default:     branch_condition = 1'b0;
        endcase
    end

    // Compute next PC
    always_comb begin
        if (jump_op == JUMP_JAL || branch_condition) begin
            pc_taken = 1'b1;
            pc_next  = pc + imm;
        end else begin
            pc_taken = 1'b0;
            pc_next  = pc + 32'd4;
        end
    end

endmodule
