`include "definitions.svh"

module top (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] WriteData,
    output logic [31:0] DataAdr,
    output logic [31:0] PC,
    output logic        MemWrite
);

    logic [31:0] instruction;
    logic [31:0] data_read;
    logic [3:0]  load_op;
    logic [3:0]  store_op;
    logic [3:0]  memory_op;

    // MemWrite flag for the testbench
    assign MemWrite = (store_op != STORE_INV);
    
    // Combine load and store operations into a single memory operation signal
    assign memory_op = (load_op != LOAD_INV) ? load_op : store_op;

    // ========== Processor Core ==========
    processor u_processor (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .data_read(data_read),
        .pc(PC),
        .address(DataAdr),
        .data_write(WriteData),
        .load_op(load_op),
        .store_op(store_op)
    );

    // ========== Instruction Memory ==========
    memory_instruction u_imem (
        .address(PC),
        .instruction(instruction)
    );

    // ========== Data Memory ==========
    memory_data #(
        .ADDRESS_LENGTH(10),
        .BYTE_OFFSET(2)
    ) u_dmem (
        .clk(clk),
        .memory_op(memory_op),
        .address(DataAdr),
        .data_write(WriteData),
        .data_read(data_read)
    );

endmodule
