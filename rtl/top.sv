`include "definitions.svh"

module top (
    input  logic        clk,
    input  logic        reset,

    // these ports are just for testing purposes
    output logic [31:0] Instruction_TEST,
    output logic [31:0] DataRead_TEST,
    output logic [31:0] Pc_TEST,
    output logic [31:0] DataAdress_TEST,
    output logic [31:0] DataWrite_TEST,
    output logic [3:0]  MemoryOp_TEST
);

    // wires that connects processor to memories
    logic [31:0] instruction;
    logic [31:0] data_read;
    logic [31:0] pc;
    logic [31:0] data_adress;
    logic [31:0] data_write;
    logic [3:0]  memory_op;

    processor u_processor (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .data_read(data_read),
        .pc(pc),
        .alu_result(data_adress),
        .data_write(data_write),
        .memory_op(memory_op)
    );

    memory_instruction u_imem (
        .address(pc),
        .instruction(instruction)
    );

    memory_data #(
        .ADDRESS_LENGTH(10),
        .BYTE_OFFSET(2)
    ) u_dmem (
        .clk(clk),
        .memory_op(memory_op),
        .address(data_adress),
        .data_write(data_write),
        .data_read(data_read)
    );

    // test ports , could be safely removed .
    assign Instruction_TEST = instruction;
    assign DataRead_TEST    = data_read;
    assign Pc_TEST          = pc;
    assign DataAdress_TEST  = data_adress;
    assign DataWrite_TEST   = data_write;
    assign MemoryOp_TEST    = memory_op;

endmodule