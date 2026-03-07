module riscvsingle(input  logic        clk, reset,
                   input  logic [31:0] Instr,
                   input  logic [31:0] ReadData,
                   output logic [31:0] PC,
                   output logic        MemWrite,
                   output logic [31:0] ALUResult, WriteData
);

  logic        PCSrc, ALUSrc, RegWrite, Zero;
  logic [1:0]  ResultSrc, ImmSrc;
  logic [2:0]  ALUControl;

    controller c (
        .op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7b5(Instr[30]),
        .Zero(Zero),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );
    
    datapath d (
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .Instr(Instr),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .Zero(Zero)
    );

endmodule