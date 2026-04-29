`include "definitions.svh"

module processor (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instruction,
    input  logic [31:0] data_read,
    
    output logic [31:0] pc,
    output logic [31:0] alu_result,
    output logic [31:0] data_write,
    output logic [3:0]  memory_op
);

    // wires that connects "control signals" from "Main Decoder" to "Datapath"
    logic [4:0]  rs1, rs2, rd;
    logic [31:0] imm;
    logic [3:0]  alu_op;
    logic [3:0]  branch_op;
    logic [3:0]  u_op;
    logic [3:0]  jump_op;
    logic [2:0]  reg_write_src;
    logic [1:0]  alu_src;

    // ========== Main Decoder ==========
    decoder_main u_decoder_main (
        .instr(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm),
        .alu_op(alu_op),
        .memory_op(memory_op),
        .branch_op(branch_op),
        .u_op(u_op),
        .jump_op(jump_op),
        .reg_write_src(reg_write_src),
        .alu_src(alu_src)
    );

    // ========== Datapath ==========
    datapath u_datapath (
        .clk(clk),
        .reset(reset),
        .read_data(data_read),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm),
        .alu_op(alu_op),
        .branch_op(branch_op),
        .u_op(u_op),
        .jump_op(jump_op),
        .reg_write_src(reg_write_src),
        .alu_src(alu_src),
        .pc(pc),
        .alu_result(alu_result),
        .rs2_val(data_write),
        .zero()                         // zero flag is internal to the processor logic for now
    );

endmodule