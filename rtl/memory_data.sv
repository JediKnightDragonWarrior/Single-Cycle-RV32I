`include "definitions.svh"

module memory_data 
#(
    parameter int ADDRESS_LENGTH = 10, // word index bit sayısı
    parameter int BYTE_OFFSET    = 2   // 2^2 = 4 read_byte (32-bit word)
)
(
    input  logic         clk,   
    input  logic [3:0]   memory_op,    
    input  logic [31:0]  address,         
    input  logic [31:0]  data_write,         
    output logic [31:0]  data_read
);

    localparam int MEM_SIZE_WORD = 2**ADDRESS_LENGTH;
    localparam [1:0] OFFSET_0 = 2'd0,OFFSET_1 = 2'd1,OFFSET_2 = 2'd2,OFFSET_3 = 2'd3; 

    logic [31:0] ram [0:MEM_SIZE_WORD-1];    
    
    // Address decoding
    logic [ADDRESS_LENGTH-1:0] addr_word;
    assign addr_word = address[ADDRESS_LENGTH + BYTE_OFFSET - 1 : BYTE_OFFSET];


    // READ LOGIC

    // Fetch the raw word from RAM
    logic [31:0] read_word;
    assign read_word = ram[addr_word];

    logic [7:0]  read_byte0, read_byte1, read_byte2, read_byte3;
    logic [15:0] read_half0, read_half1;
    
    assign read_byte0 = read_word[7:0];
    assign read_byte1 = read_word[15:8];
    assign read_byte2 = read_word[23:16];
    assign read_byte3 = read_word[31:24];
    
    assign read_half0 = read_word[15:0];
    assign read_half1 = read_word[31:16];

    always @* begin
        data_read = 32'd0; 

        case (memory_op)
            LOAD_LB: begin
                case (address[1:0])
                    OFFSET_0: data_read = {{24{read_byte0[7]}}, read_byte0};
                    OFFSET_1: data_read = {{24{read_byte1[7]}}, read_byte1};
                    OFFSET_2: data_read = {{24{read_byte2[7]}}, read_byte2};
                    OFFSET_3: data_read = {{24{read_byte3[7]}}, read_byte3};
                    default: data_read = 32'd0;
                endcase
            end

            LOAD_LH: begin
                if (address[1])
                    data_read = {{16{read_half1[15]}}, read_half1};
                else
                    data_read = {{16{read_half0[15]}}, read_half0};
            end 

            LOAD_LW: begin
                    data_read = read_word;
            end

            LOAD_LBU: begin
                case (address[1:0])
                    OFFSET_0: data_read = {24'd0, read_byte0};
                    OFFSET_1: data_read = {24'd0, read_byte1};
                    OFFSET_2: data_read = {24'd0, read_byte2};
                    OFFSET_3: data_read = {24'd0, read_byte3};
                    default: data_read = 32'd0;
                endcase
            end

            LOAD_LHU: begin
                if (address[1]) data_read = {16'd0, read_half1};
                else            data_read = {16'd0, read_half0};
            end 

            default: data_read = 32'd0;

        endcase
    end

    // WRITE LOGIC

    logic [7:0]  write_byte;
    logic [15:0] write_half;    
    assign write_byte = data_write[7:0];
    assign write_half = data_write[15:0];

    always_ff @(posedge clk) begin
        case (memory_op)
            STORE_SB: begin
                case (address[1:0])
                    OFFSET_0:   ram[addr_word][7:0]   <= write_byte;
                    OFFSET_1:   ram[addr_word][15:8]  <= write_byte;
                    OFFSET_2:   ram[addr_word][23:16] <= write_byte;
                    OFFSET_3:   ram[addr_word][31:24] <= write_byte;
                endcase
            end

            STORE_SH: begin
                if (address[1]) ram[addr_word][31:16] <= write_half;
                else            ram[addr_word][15:0]  <= write_half;
            end
            
            STORE_SW: begin
                ram[addr_word] <= data_write;
            end

            default: ;
        endcase
    end

endmodule