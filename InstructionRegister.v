module InstructionRegister(
    input clk,
    input reset,
    input IRWrite,
    input [31:0] instruction_next,

    output reg [31:0] instruction
);

    always @(posedge clk or posedge reset)
        begin
            if (reset)
                instruction <= 32'd0;
            else if(IRWrite)
                instruction <= instruction_next;
            else
                instruction <= instruction;
        end
endmodule
