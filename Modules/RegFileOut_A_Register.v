module RegFileOut_A_Register(
    input clk,
    input reset,
    input [31:0] RegFileOut_A_next,

    output reg [31:0] RegFileOut_A
);

    always @(posedge clk or posedge reset)
        begin
            if (reset)
                RegFileOut_A <= 32'd0;
            else
                RegFileOut_A <= RegFileOut_A_next;
        end
endmodule
