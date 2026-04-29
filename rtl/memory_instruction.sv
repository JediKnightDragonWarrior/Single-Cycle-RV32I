module memory_instruction
(
    input logic [31:0]  address,
    output logic [31:0] instruction
);

logic [31:0] ram [0:63];

initial $readmemh("test/program.hex", ram);

assign instruction = ram[address[7:2]]; // word aligned

endmodule