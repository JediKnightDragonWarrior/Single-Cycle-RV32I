module pc_register (
    input  logic        clk,      
    input  logic        reset,     
    input  logic [31:0] pc_next,  
    output logic [31:0] pc        
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)  pc <= 32'd0;    
        else        pc <= PCNext;    
    end
        
endmodule