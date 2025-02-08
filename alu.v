module alu(
    input [31:0] SrcA,          // First operand
    input [31:0] SrcB,          // Second operand
    input [3:0] ALUCtrl,        // Control signal
    output reg [31:0] ALUResult,// Result
    output Zero                 // Zero flag for branch
);

    // Control signals
    localparam ADD = 4'b0010;
    localparam SUB = 4'b0110;
    localparam AND = 4'b0000;
    localparam OR  = 4'b0001;
    localparam SLT = 4'b0111;

    always @(*) begin
        case(ALUCtrl)
            ADD: ALUResult = SrcA + SrcB;
            SUB: ALUResult = SrcA - SrcB;
            AND: ALUResult = SrcA & SrcB;
            OR:  ALUResult = SrcA | SrcB;
            SLT: ALUResult = ((SrcA) < (SrcB)) ? 32'd1 : 32'd0;
            default: ALUResult = 32'bx;
        endcase
    end

    assign Zero = (ALUResult == 32'd0);

endmodule
