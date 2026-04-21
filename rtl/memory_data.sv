`include "definitions.svh"

module memory_data 
#(
    parameter int ADDRESS_LENGTH = 10, // word index bit sayısı
    parameter int BYTE_OFFSET    = 2   // 2^2 = 4 byte (32-bit word)
)
(
    input  logic        clk,   
    input  logic [3:0]  memory_op,    
    input  logic [31:0] address,         
    input  logic [31:0] data_write,         
    output logic [31:0] data_read
);

    localparam int MEM_SIZE_WORD = 2**ADDRESS_LENGTH;

    logic [31:0] ram [0:MEM_SIZE_WORD-1];    
    
    
    logic [ADDRESS_LENGTH-1:0] addr_word;
    assign addr_word = address[ADDRESS_LENGTH + BYTE_OFFSET - 1 : BYTE_OFFSET];

    logic [31:0] word;
    assign word = ram[addr_word];

    // READ 
    always_comb begin
        data_read = 32'd0;

        case (memory_op)
            
            LOAD_LB: begin
                case (address[1:0])
                    2'b00: data_read = {{24{word[7]}},  word[7:0]};
                    2'b01: data_read = {{24{word[15]}}, word[15:8]};
                    2'b10: data_read = {{24{word[23]}}, word[23:16]};
                    2'b11: data_read = {{24{word[31]}}, word[31:24]};
                    default: data_read = 32'd0;
                endcase
            end

            LOAD_LH: begin
                if (address[1])
                    data_read = {{16{word[31]}}, word[31:16]};
                else
                    data_read = {{16{word[15]}}, word[15:0]};
            end 

            LOAD_LW: data_read = word;

            LOAD_LBU: begin
                case (address[1:0])
                    2'b00: data_read = {24'd0, word[7:0]};
                    2'b01: data_read = {24'd0, word[15:8]};
                    2'b10: data_read = {24'd0, word[23:16]};
                    2'b11: data_read = {24'd0, word[31:24]};
                    default: data_read = 32'd0;
                endcase
            end

            LOAD_LHU: begin
                if (address[1])
                    data_read = {16'd0, word[31:16]};
                else
                    data_read = {16'd0, word[15:0]};
            end 

            default: data_read = 32'd0;
        endcase
    end

    // WRITE 
    always_ff @(posedge clk) begin
        case (memory_op)

            STORE_SB: begin
                case (address[1:0])
                    2'b00: ram[addr_word][7:0]   <= data_write[7:0];
                    2'b01: ram[addr_word][15:8]  <= data_write[7:0];
                    2'b10: ram[addr_word][23:16] <= data_write[7:0];
                    2'b11: ram[addr_word][31:24] <= data_write[7:0];
                endcase
            end

            STORE_SH: begin
                if (address[1])
                    ram[addr_word][31:16] <= data_write[15:0];
                else
                    ram[addr_word][15:0]  <= data_write[15:0];
            end
            
            STORE_SW: begin
                ram[addr_word] <= data_write;
            end

            default: ;
        endcase
    end

endmodule