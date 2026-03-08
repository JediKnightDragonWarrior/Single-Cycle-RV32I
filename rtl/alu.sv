module alu (
    input  logic [2:0]  ALUControl, //  specific operation of alu    
    input  logic [31:0] SrcA,       //  operand1 always comes from rs1
    input  logic [31:0] SrcB,       //  operand2 from rs2 or Imm   

    output logic [31:0] ALUResult,     
    output logic        Zero        //  if ALUResult is zero , used for beq            
);

    always_comb begin
        case (ALUControl)
            3'b000: ALUResult = SrcA + SrcB;                                    //  ADD
            3'b001: ALUResult = SrcA - SrcB;                                    //  SUB
            3'b010: ALUResult = SrcA & SrcB;                                    //  AND
            3'b011: ALUResult = SrcA | SrcB;                                    //  OR
            3'b100: ALUResult = SrcA ^ SrcB;                                    //  XOR
            3'b101: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;      //  SLT                                                 //  SLT
            default: ALUResult = 'x;                          
        endcase
    end

    assign Zero = (ALUResult == 32'b0);

endmodule