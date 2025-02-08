module alu_control(
    input [1:0] ALUOp,          // From main control
    input [5:0] funct,          // From instruction[5:0]
    output reg [3:0] ALUCtrl    // To ALU
);

    // Control signals
    localparam ADD = 4'b0010;
    localparam SUB = 4'b0110;
    localparam AND = 4'b0000;
    localparam OR  = 4'b0001;
    localparam SLT = 4'b0111;

    // Function field codes
    localparam F_ADD = 6'b100000;
    localparam F_SUB = 6'b100010;
    localparam F_AND = 6'b100100;
    localparam F_OR  = 6'b100101;
    localparam F_SLT = 6'b101010;

    always @(*) begin
        case(ALUOp)
            2'b00: ALUCtrl = ADD;    // LW/SW/ADDI
            2'b01: ALUCtrl = SUB;    // BEQ
            2'b10: begin             // R-type
                case(funct)
                    F_ADD: ALUCtrl = ADD;
                    F_SUB: ALUCtrl = SUB;
                    F_AND: ALUCtrl = AND;
                    F_OR:  ALUCtrl = OR;
                    F_SLT: ALUCtrl = SLT;
                    default: ALUCtrl = 4'bxxxx;
                endcase
            end
            default: ALUCtrl = 4'bxxxx;
        endcase
    end
endmodule
