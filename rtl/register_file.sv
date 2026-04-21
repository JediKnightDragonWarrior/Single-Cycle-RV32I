`include "definitions.svh"

module register_file 
(
    input logic        clk,   
    input logic [4:0]  rs1,    
    input logic [4:0]  rs2,    
    input logic [4:0]  rd,

    input logic [2:0]  reg_write_src,   
    input logic [31:0] alu_result,   
    input logic [31:0] data_read,   
    input logic [31:0] pc,   
    input logic [31:0] u_result,   

    output logic [31:0] rs1_val,   
    output logic [31:0] rs2_val    
);

    logic [31:0] registers [31:0]; 

    logic  write_enabled;
    assign write_enabled = (reg_write_src != REG_INV);
    
    logic [31:0] write_data;
    always_comb begin 
        case (reg_write_src)
            REG_ALU:    write_data = alu_result; 
            REG_DATA:   write_data = data_read;
            REG_PC:     write_data = pc+4;
            REG_U:      write_data = u_result;
            default:    write_data = 32'x; 
        endcase
        
    end

    always_ff @(posedge clk) begin
        if (write_enabled) begin
            if (rd != 5'd0) registers[rd] <= write_data;
        end
    end

    assign rs1_val = (rs1 != 5'd0) ? registers[rs1] : 32'd0;
    assign rs2_val = (rs2 != 5'd0) ? registers[rs2] : 32'd0;

endmodule