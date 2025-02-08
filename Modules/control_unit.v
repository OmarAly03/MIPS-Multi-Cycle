module control_unit (
    input clk,
    //input [5:0] funct,
    input [5:0] opcode,
    
    // Memory controls
    output reg IorD,
    output reg MemWrite,
    output reg IRWrite,
    output reg PCWrite,
    output reg Branch,
    output reg [1:0] PCSrc,
    output reg [1:0] ALUOp,
    output reg [1:0] ALUSrcB,
    output reg ALUSrcA,
    output reg RegWrite,
    output reg RegDst,
    output reg MemtoReg
);

    parameter S0_Fetch = 4'd0;
    parameter S1_Decode = 4'd1;
    parameter S2_MemAdr = 4'd2;
    parameter S3_MemRead = 4'd3;
    parameter S4_MemWriteback = 4'd4;
    parameter S5_MemWrite = 4'd5;
    parameter S6_Execute = 4'd6;
    parameter S7_ALUWriteback = 4'd7;
    parameter S8_Branch = 4'd8;
    parameter S9_ADDIExecute = 4'd9;
    parameter S10_ADDIWriteback = 4'd10;
    parameter S11_Jump = 4'd11;
    parameter S12_DecodeBranch = 4'd12;

    reg [3:0] state;
    always @(posedge clk)
        begin
            case(state)
                S0_Fetch:            
                    state <= S1_Decode;
                S1_Decode: 
                    begin
                        case(opcode)
                            6'd35: state <= S2_MemAdr;
                            6'd43: state <= S2_MemAdr;
                            6'd0: state <= S6_Execute;
                            6'd8: state <= S9_ADDIExecute;
                            6'd2: state <= S11_Jump;
                            6'd4: state <= S8_Branch;
                        endcase
                    end
                S8_Branch: state <= S0_Fetch;
                S2_MemAdr:
                    case(opcode)
                        6'd35: state <= S3_MemRead;
                        6'd43: state <= S5_MemWrite;
                    endcase
                S3_MemRead: state <= S4_MemWriteback;
                S4_MemWriteback: state <= S0_Fetch;
                S5_MemWrite: state <= S0_Fetch;
                S6_Execute: state <= S7_ALUWriteback;
                S7_ALUWriteback: state <= S0_Fetch;
                S9_ADDIExecute: state <= S10_ADDIWriteback;
                S10_ADDIWriteback: state <= S0_Fetch;
                S11_Jump: state <= S0_Fetch;

                default: state <= S0_Fetch;
            endcase
        end

    always @(*)
        begin
            case(state)
                S0_Fetch:
                    begin
                        IorD = 0;
                        MemWrite = 0; 
                        IRWrite = 1;
                        PCWrite = 1;
                        Branch = 0;
                        PCSrc = 2'b00;
                        ALUOp = 2'b00;
                        ALUSrcB = 2'b01;
                        ALUSrcA = 0;
                        RegWrite = 0;
                        RegDst = 0;
                        MemtoReg = 0;
                    end
                S1_Decode:
                    begin
                        IorD = 0;
                        MemWrite = 0; 
                        IRWrite = 0;
                        PCWrite = 0;
                        Branch = 0;
                        PCSrc = 2'b00;
                        ALUOp = 2'b00;
                        ALUSrcB = 2'b01;
                        ALUSrcA = 0;
                        RegWrite = 0;
                        RegDst = 0;
                        MemtoReg = 0;
                    end
                S2_MemAdr:
                    begin
                        IorD = 0;
                        MemWrite = 0; 
                        IRWrite = 0;
                        PCWrite = 0;
                        Branch = 0;
                        PCSrc = 2'b00;
                        ALUOp = 2'b00;
                        ALUSrcB = 2'b10;
                        ALUSrcA = 1;
                        RegWrite = 0;
                        RegDst = 0;
                        MemtoReg = 0;
                    end
                S3_MemRead:
                    begin
                        IorD = 1;
                        MemWrite = 0; 
                        IRWrite = 0;
                        PCWrite = 0;
                        Branch = 0;
                        PCSrc = 2'b00;
                        ALUOp = 2'b00;
                        ALUSrcB = 2'b10;
                        ALUSrcA = 1;
                        RegWrite = 0;
                        RegDst = 0;
                        MemtoReg = 0;
                    end
                S4_MemWriteback:
                    begin
                        IorD = 0;
                        MemWrite = 0; 
                        IRWrite = 0;
                        PCWrite = 0;
                        Branch = 0;
                        PCSrc = 2'b00;
                        ALUOp = 2'b00;
                        ALUSrcB = 2'b10;
                        ALUSrcA = 1;
                        RegWrite = 1;
                        RegDst = 0;
                        MemtoReg = 1;
                    end
                S5_MemWrite:
                    begin
                        IorD = 1;
                        MemWrite = 1; 
                        IRWrite = 0;
                        PCWrite = 0;
                        Branch = 0;
                        PCSrc = 2'b00;
                        ALUOp = 2'b00;
                        ALUSrcB = 2'b10;
                        ALUSrcA = 1;
                        RegWrite = 0;
                        RegDst = 0;
                        MemtoReg = 0;
                    end
                S6_Execute:
                    begin
                        IorD = 0;
                        MemWrite = 0; 
                        IRWrite = 0;
                        PCWrite = 0;
                        Branch = 0;
                        PCSrc = 2'b00;
                        ALUOp = 2'b10;
                        ALUSrcB = 2'b00;
                        ALUSrcA = 1;
                        RegWrite = 0;
                        RegDst = 0;
                        MemtoReg = 0;
                    end
                S7_ALUWriteback:
                    begin
                        IorD = 0;
                        MemWrite = 0; 
                        IRWrite = 0;
                        PCWrite = 0;
                        Branch = 0;
                        PCSrc = 2'b00;
                        ALUOp = 2'b00;
                        ALUSrcB = 2'b10;
                        ALUSrcA = 1;
                        RegWrite = 1;
                        RegDst = 1;
                        MemtoReg = 0;
                    end
                S8_Branch:
                    begin
                        IorD = 0;
                        MemWrite = 0; 
                        IRWrite = 0;
                        PCWrite = 0;
                        Branch = 1;
                        PCSrc = 2'b01;
                        ALUOp = 2'b01;
                        ALUSrcB = 2'b00;
                        ALUSrcA = 1;
                        RegWrite = 0;
                        RegDst = 0;
                        MemtoReg = 0;
                    end
                S9_ADDIExecute:
                    begin
                        IorD = 0;
                        MemWrite = 0; 
                        IRWrite = 0;
                        PCWrite = 0;
                        Branch = 0;
                        PCSrc = 2'b00;
                        ALUOp = 2'b00;
                        ALUSrcB = 2'b10;
                        ALUSrcA = 1;
                        RegWrite = 0;
                        RegDst = 0;
                        MemtoReg = 0;
                    end
                S10_ADDIWriteback:
                    begin
                        IorD = 0;
                        MemWrite = 0; 
                        IRWrite = 0;
                        PCWrite = 0;
                        Branch = 0;
                        PCSrc = 2'b00;
                        ALUOp = 2'b00;
                        ALUSrcB = 2'b10;
                        ALUSrcA = 1;
                        RegWrite = 1;
                        RegDst = 0;
                        MemtoReg = 0;
                    end
                S11_Jump:
                    begin
                        IorD = 0;
                        MemWrite = 0; 
                        IRWrite = 0;
                        PCWrite = 1;
                        Branch = 0;
                        PCSrc = 2'b10;
                        ALUOp = 2'b00;
                        ALUSrcB = 2'b10;
                        ALUSrcA = 1;
                        RegWrite = 0;
                        RegDst = 0;
                        MemtoReg = 0;
                    end
            endcase
        end
endmodule