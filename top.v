module top(
    input clk,
    input reset
);

    // Control Signals
    wire IorD;
    wire MemWrite;
    wire IRWrite;
    wire PCWrite;
    wire Branch;
    wire [1:0] PCSrc;
    wire [1:0] ALUOp;
    wire [1:0] ALUSrcB;
    wire ALUSrcA;
    wire RegWrite;
    wire RegDst;
    wire MemtoReg;

    wire [31:0] PC, PC_next, PCJump;
    wire PCEn;
    wire [31:0] Address, Memory_out;
    wire [31:0] A, B;
    wire [31:0] SrcA, SrcB, ALU_out, ALUResult;
    wire Zero;
    wire [31:0] Instruction, Data;
    wire [31:0] WD3, RD1, RD2;
    wire [4:0] A3;
    wire [31:0] extendedImm, extendedImmShifted2;
    wire [31:0] Four;
    wire [3:0] ALUCtrl;
    
    assign Four = 32'd4;
    assign PCEn = ((Zero & Branch) | PCWrite);
    assign PCJump = {ALU_out[31:28], Instruction[25:0], 2'b00};

    control_unit cu (
        .clk(clk),
        .opcode(Instruction[31:26]),
        .IorD(IorD),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),
        .PCWrite(PCWrite),
        .Branch(Branch),
        .PCSrc(PCSrc),
        .ALUOp(ALUOp),
        .ALUSrcB(ALUSrcB),
        .ALUSrcA(ALUSrcA),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .MemtoReg(MemtoReg)
    );

    ProgramCounter pc(
        .clk(clk),
        .reset(reset),
        .PCWrite(PCEn),
        .PC_next(PC_next),
        .PC(PC)
    );

    mux2to1 iord(
        .a(PC),
        .b(ALU_out),
        .sel(IorD),
        .out(Address)
    );

    Memory memory(
        .clk(clk),
        .WE(MemWrite),
        .WD(B),
        .Address(Address),
        .RD(Memory_out)
    );    

    InstructionRegister ir(
        .clk(clk),
        .reset(reset),
        .IRWrite(IRWrite),
        .instruction_next(Memory_out),
        .instruction(Instruction)
    );

    dataRegister dr(
        .clk(clk),
        .reset(reset),
        .data_next(Memory_out),
        .data(Data)
    );

    mux2to1 #(5) regDst(
        .a(Instruction[20:16]),
        .b(Instruction[15:11]),
        .sel(RegDst),
        .out(A3)
    );

    mux2to1 memtoReg(
        .a(ALU_out),
        .b(Data),
        .sel(MemtoReg),
        .out(WD3)
    );

    register_file regFile(
        .clk(clk),
        .rst(reset),
        .read_reg1(Instruction[25:21]),
        .read_reg2(Instruction[20:16]),
        .write_reg(A3),
        .write_data(WD3),
        .reg_write(RegWrite),
        .read_data1(RD1),
        .read_data2(RD2)
    );

    sign_extend se(
        .immediate(Instruction[15:0]),
        .extended(extendedImm)
    );

    RegFileOut_A_Register regA(
        .clk(clk),
        .reset(reset),
        .RegFileOut_A_next(RD1),
        .RegFileOut_A(A)
    );

    RegFileOut_B_Register regB(
        .clk(clk),
        .reset(reset),
        .RegFileOut_B_next(RD2),
        .RegFileOut_B(B)
    );

    mux2to1 alusrcA(
        .a(PC),
        .b(A),
        .sel(ALUSrcA),
        .out(SrcA)
    );

    shift_left_2 sf2(
        .in(extendedImm),
        .out(extendedImmShifted2)
    );

    mux4to1 alusrcB(
        .a(B),
        .b(Four),
        .c(extendedImm),
        .d(extendedImmShifted2),
        .sel(ALUSrcB),
        .out(SrcB)
    );

    alu ALU(
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUCtrl(ALUCtrl),
        .ALUResult(ALUResult),
        .Zero(Zero)   
    );

    ALUOutRegister aluoutReg(
        .clk(clk),
        .reset(reset),
        .ALUOut_next(ALUResult),
        .ALUOut(ALU_out)
    );

    alu_control alucontrol(
        .ALUOp(ALUOp),
        .funct(Instruction[5:0]),
        .ALUCtrl(ALUCtrl)
    );

    mux3to1 pcsrc(
        .a(ALUResult),
        .b(ALU_out),
        .c(PCJump),
        .sel(PCSrc),
        .out(PC_next)
    );
endmodule
