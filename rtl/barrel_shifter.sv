module barrel_shifter (
    input  logic [1:0]  mode,
    input  logic [4:0]  shamt, 
    input  logic [31:0] Src,       //  operand1 always comes from rs1
    output logic [31:0] Result
);

    logic           fill_bit;
    logic   [31:0]  reverse_in,reverse_out;
    logic   [31:0]  ready,s0,s1,s2,s3,s4;

    assign fill_bit = (mode == 2'b00) ? Src[31] : 1'b0;
    assign ready    = (mode == 2'b10) ? reverse_in : Src;
    assign Result   = (mode == 2'b10) ? reverse_out : s4;
    
    always_comb begin
        for (int i = 0; i < 32; i++) reverse_in[i] = Src[31-i]; 
    end

    always_comb begin
        for (int i = 0; i < 32; i++) reverse_out[i] = s4[31-i]; 
    end

    assign s0 = shamt[4] ? {{16{fill_bit}},ready[31:16]} : ready ;
    assign s1 = shamt[3] ? {{8{fill_bit}},s0[31:8]}      : s0 ;
    assign s2 = shamt[2] ? {{4{fill_bit}},s1[31:4]}      : s1 ;
    assign s3 = shamt[1] ? {{2{fill_bit}},s2[31:2]}      : s2 ;
    assign s4 = shamt[0] ? {{1{fill_bit}},s3[31:1]}      : s3 ;

    
endmodule