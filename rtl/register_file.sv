`include "definitions.svh"

module register_file 
(
    input logic        clk,   
    input logic [4:0]  rs1,    
    input logic [4:0]  rs2,    
    input logic [4:0]  rd,

    input logic        write_enable,   
    input logic [31:0] write_data,   

    output logic [31:0] rs1_val,   
    output logic [31:0] rs2_val    
);

    logic [31:0] registers [31:0]; 

    always_ff @(posedge clk) begin
        if (write_enable) begin
            if (rd != 5'd0) registers[rd] <= write_data;
        end
    end

    assign rs1_val = (rs1 != 5'd0) ? registers[rs1] : 32'd0;
    assign rs2_val = (rs2 != 5'd0) ? registers[rs2] : 32'd0;

endmodule