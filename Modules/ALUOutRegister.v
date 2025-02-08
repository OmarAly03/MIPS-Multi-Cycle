module ALUOutRegister(
    input clk,
    input reset,
    input [31:0] ALUOut_next,

    output reg [31:0] ALUOut
);

    always @(posedge clk or posedge reset)
        begin
            if (reset)
                ALUOut <= 32'd0;
            else
                ALUOut <= ALUOut_next;
        end
endmodule
