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
    output logic [31:0] write_data,
    output logic        zero
);

    // Register file outputs
    logic [31:0] rs1_val, rs2_val;

    // ALU second operand (mux output)
    logic [31:0] alu_operand2;

    // PC control signals
    logic [31:0] pc_next;
    logic        pc_taken;
    logic [31:0] u_result;

    // ========== PC Register ==========
    logic [31:0] pc_current;
    
    pc_register pc_reg (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc_current)
    );
    
    assign pc = pc_current;

    // ========== Register File Write Data Multiplexer ==========
    logic [31:0] reg_write_data;
    logic        reg_write_enable;

    assign reg_write_enable = (reg_write_src != REG_INV);

    always_comb begin 
        case (reg_write_src)
            REG_ALU:    reg_write_data = alu_result; 
            REG_DATA:   reg_write_data = read_data;
            REG_PC:     reg_write_data = pc_current + 4;
            REG_U:      reg_write_data = u_result;
            default:    reg_write_data = 32'x; 
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
    // alu_src sinyalini kullanarak ALU'nun ikinci operandını seç
    // ALSRC_R (2'd0): rs2_val seç
    // ALSRC_I (2'd1): imm seç
    always_comb begin
        case (alu_src)
            ALSRC_R:    alu_operand2 = rs2_val;
            ALSRC_I:    alu_operand2 = imm;
            default:    alu_operand2 = 32'x;
        endcase
    end

    // ========== ALU ==========
    alu alu_inst (
        .alu_op(alu_op),
        .rs1(rs1_val),
        .rs2(alu_operand2),  // Muxten gelen operand (rs2 veya imm)
        .alu_result(alu_result)
    );

    // ========== Upper Immediate Unit ==========
    upper_imm upper_imm_unit (
        .u_op(u_op),
        .imm(imm),
        .pc(pc_current),
        .upper_imm_result(u_result)
    );

    // ========== PC Control Unit ==========
    pc_control pc_ctrl (
        .pc(pc_current),
        .imm(imm),
        .branch_op(branch_op),
        .jump_op(jump_op),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val),
        .pc_next(pc_next),
        .pc_taken(pc_taken)
    );

    // Write data: RS2 değeri (store işlemleri için)
    assign write_data = rs2_val;

    // Zero flag: ALU sonucu sıfırsa
    assign zero = (alu_result == 32'd0) ? 1'b1 : 1'b0;

endmodule
