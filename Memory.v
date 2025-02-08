module Memory ( 
    input clk,
    input WE,                              
    input [31:0] WD,            
    input [31:0] Address,       
    output reg [31:0] RD
);
    reg [31:0] Memory [2047:0]; // Unified memory: 2048 words

    // Initialize memory for instructions (text segment)
    initial begin
        Memory[1024] = 32'h20020005;  // addi $2, $0, 5
        Memory[1028] = 32'h2003000C;  // addi $3, $0, 12
        Memory[1032] = 32'h2067FFF7;  // add $1, $2, $3
        Memory[1036] = 32'h00E22025;  // add $4, $7, $2
        Memory[1040] = 32'h00642824;  // or $5, $3, $4
        Memory[1044] = 32'h00A42820;  // and $5, $3, $4
        Memory[1048] = 32'h00A52820;  // add $5, $5, $4
        Memory[1052] = 32'h00A52820;  // add $5, $5, $4
        Memory[1056] = 32'h0064202A;  // slt $4, $3, $4
        Memory[1060] = 32'h0064202A;  // slt $4, $3, $4
        Memory[1064] = 32'h20050000;  // addi $5, $0, 0
        Memory[1068] = 32'h00E2202A;  // slt $4, $7, $2
        Memory[1072] = 32'h00853820;  // add $7, $4, $5
        Memory[1076] = 32'h00E23822;  // sub $7, $7, $2
        Memory[1080] = 32'hAC670044;  // sw $7, 68($3)
        Memory[1084] = 32'h8C020050;  // lw $2, 80($0)
        Memory[1088] = 32'h08000112;  // j end
        Memory[1092] = 32'h20020001;  // addi $2, $0, 1
        Memory[1096] = 32'hAC020054;  // sw $2, 84($0)
    end


    // Combinational read
    always @(*) begin
        if (Address >= 32'h00000400 && Address < 32'h00000800) 
            // Instruction fetch: Access directly (word-aligned address)
            RD = Memory[Address];
        else 
            // Data access: Word-aligned by shifting right by 2
            RD = Memory[Address[31:2]];
    end

    // Synchronous write
    always @(posedge clk) begin
        if (WE) begin
            // Data memory write: Word-aligned address
            Memory[Address[31:2]] <= WD;
        end
    end
endmodule
