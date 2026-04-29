`include "definitions.svh"

module datapath (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] read_data,
    
    // Control signals from controller (decoder)
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] imm,
    input  logic [3:0]  alu_op,
    input  logic [3:0]  branch_op,
    input  logic [3:0]  u_op,
    input  logic [3:0]  jump_op,
    input  logic [2:0]  reg_write_src,
    input  logic [1:0]  alu_src,
    
    // Output signals
    output logic [31:0] pc,
    output logic [31:0] alu_result,
    output logic [31:0] rs2_val,
    output logic        zero
);

    // Register file outputs 
    logic [31:0] rs1_val;

    // ALU second operand (mux output)
    logic [31:0] alu_operand2;

    // PC control signals
    logic [31:0] pc_next;
    logic [31:0] u_result;  
    logic        pc_taken;  // ? not used currently , could be used for testing 


    // ========== PC Register ==========
    pc_register pc_reg (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );
    
    // ========== PC Control ==========
    pc_control pc_ctrl (
        .pc(pc),
        .imm(imm),
        .branch_op(branch_op),
        .jump_op(jump_op),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val),
        .pc_next(pc_next),
        .pc_taken(pc_taken)
    );

    // ========== Register File Write Data Multiplexer ==========
    logic [31:0] reg_write_data;
    logic        reg_write_enable;

    assign reg_write_enable = (reg_write_src != REG_INV);

    always_comb begin 
        case (reg_write_src)
            REG_ALU:    reg_write_data = alu_result; 
            REG_DATA:   reg_write_data = read_data;
            REG_PC:     reg_write_data = pc + 4;
            REG_U:      reg_write_data = u_result;
            default:    reg_write_data = 'x; 
        endcase
    end

    // ========== Register File ==========
    register_file regfile (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_enable(reg_write_enable),
        .write_data(reg_write_data),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val)
    );

    // ========== ALU Source Multiplexer ==========
    always_comb begin
        case (alu_src)
            ALSRC_R:    alu_operand2 = rs2_val;
            ALSRC_I:    alu_operand2 = imm;
            default:    alu_operand2 = 'x;
        endcase
    end

    // ========== ALU ==========
    alu alu_inst (
        .alu_op(alu_op),
        .rs1(rs1_val),
        .rs2(alu_operand2),         // comes from (rs2 or imm)
        .alu_result(alu_result)
    );

    // ========== Upper Immediate Unit ==========
    upper_imm upper_imm_unit (
        .u_op(u_op),
        .imm(imm),
        .pc(pc),
        .upper_imm_result(u_result)
    );

    // Zero flag: ALU sonucu sıfırsa
    assign zero = (alu_result == 32'd0) ? 1'b1 : 1'b0;

endmodule
