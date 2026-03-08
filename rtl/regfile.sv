module regfile 
//  asynch read 
//  sync write ( will be active in regfile at next posedge)
(
    input  logic        clk,   
    input  logic        WE3,   // write enable (not active at sw ,beq) 

    // rd1 <= RegFile[a1]
    // rd2 <= RegFile[a2]
    // RegFile[a3] <= wd3

    input  logic [4:0]  A1,    
    input  logic [4:0]  A2,    
    input  logic [4:0]  A3,    
    input  logic [31:0] WD3,   

    output logic [31:0] RD1,   
    output logic [31:0] RD2    
);


    logic [31:0] rf [31:0]; // 32 bit width , 32 registers

    always_ff @(posedge clk) begin
        if (WE3) begin
            if (A3 != 5'd0) rf[A3] <= WD3;
        end
    end

    assign RD1 = (A1 != 5'd0) ? rf[A1] : 32'd0;
    assign RD2 = (A2 != 5'd0) ? rf[A2] : 32'd0;

endmodule