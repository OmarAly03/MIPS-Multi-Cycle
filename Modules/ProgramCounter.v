module ProgramCounter(
    input clk,
    input reset,
    input PCWrite,
    input [31:0] PC_next,

    output reg [31:0] PC
);

    always @(posedge clk or posedge reset)
        begin
            if (reset)
                PC <= 32'h00000400; // 1024
            else if(PCWrite)
                PC <= PC_next;
            else
                PC <= PC;
        end
endmodule
