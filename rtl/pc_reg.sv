module pc_reg (
    input  logic        clk,      
    input  logic        reset,    // async reset 
    input  logic [31:0] PCNext,   // next pc (combinational)
    output logic [31:0] pc        // instruction_mem[PC] -> current inst
);

    always_ff @(posedge clk or posedge reset) 
        if (reset)  pc <= 32'd0;    // boot address
        else        pc <= PCNext;   // Gelmezse hesaplanan yeni adresi içine al
        

endmodule