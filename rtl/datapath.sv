module datapath (
    input  logic        clk,
    input  logic        reset,
    
    // --- DIŞARIYLA (HAFIZA) OLAN BAĞLANTILAR ---
    output logic [31:0] pc,            // Program Counter çıkışı (IMEM 'A' girişine gider)
    input  logic [31:0] instr,         // Komut (IMEM 'RD' çıkışından gelir)
    output logic [31:0] aluout,        // ALU hesaplama sonucu (DMEM 'A' Adres girişine gider)
    output logic [31:0] writedata,     // Veri hafızasına yazılacak değer (DMEM 'WD' girişine gider)
    input  logic [31:0] readdata,      // Veri hafızasından okunan değer (DMEM 'RD' çıkışından gelir)
    
    // --- KONTROL BİRİMİ İLE OLAN BAĞLANTILAR ---
    input  logic        pcsrc,         // PC Seçici (0: PC+4, 1: PCTarget)
    input  logic        resultsrc,     // Result MUX Seçici (0: ALUResult, 1: ReadData)
    input  logic        alusrc,        // ALU MUX Seçici (0: rs2, 1: ImmExt)
    input  logic [1:0]  immsrc,        // Sayı Uzatıcı Tipi 
    input  logic        regwrite,      // Register File yazma izni (WE3)
    input  logic [2:0]  alucontrol,    // ALU işlem kontrolü
    output logic        zero           // ALU'nun Zero bayrağı (Control Unit'e geri gider)
);

    // --- İÇ KABLOLAR ---
    logic [31:0] pc_next, pc_plus_4, pc_target;
    logic [31:0] immext;
    logic [31:0] srca, srcb;     
    logic [31:0] result;         

    // ------------------------------------------
    // 1. PC ve Adres Hesaplamaları (Sol Kısım)
    // ------------------------------------------
    pc_reg pcreg_inst (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    // Şemadaki alttaki toplayıcı (PCPlus4)
    assign pc_plus_4 = pc + 32'd4;
    
    // Şemadaki sağ ortadaki toplayıcı (PCTarget)
    assign pc_target = pc + immext;

    // Şemadaki en soldaki PC MUX
    assign pc_next = pcsrc ? pc_target : pc_plus_4; 


    // ------------------------------------------
    // 2. Modüller ve Veri Yolu Ağı (Sağ Kısım)
    // ------------------------------------------
    
    // Extend (İşaret Uzatıcı)
    signextend signext_inst (
        .instr(instr),           // Aslında şemadaki gibi [31:7] gönderilebilir ama modül içinden kırpıldı
        .immsrc(immsrc),
        .immext(immext)
    );

    // Register File
    regfile rf_inst (
        .clk(clk),
        .we3(regwrite),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .wd3(result),            // En sağdaki MUX'tan dönen Result kablosu
        .rd1(srca),              // Şemadaki SrcA kablosu
        .rd2(writedata)          // Şemadaki WriteData kablosu
    );

    // ALU MUX (Şemadaki ortadaki MUX)
    // 0: RD2 (writedata), 1: ImmExt
    assign srcb = alusrc ? immext : writedata;

    // ALU
    alu alu_inst (
        .a(srca),
        .b(srcb),
        .alucontrol(alucontrol),
        .result(aluout),         // Şemadaki ALUResult kablosu
        .zero(zero)              // Şemadaki Zero (Control Unit'e giden kablo)
    );

    // Result MUX (Şemadaki en sağdaki MUX)
    // 0: ALUResult, 1: ReadData
    assign result = resultsrc ? readdata : aluout;

endmodule