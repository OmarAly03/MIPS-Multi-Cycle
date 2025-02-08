module RegFileOut_B_Register(
    input clk,
    input reset,
    input [31:0] RegFileOut_B_next,

    output reg [31:0] RegFileOut_B
);

    always @(posedge clk or posedge reset)
        begin
            if (reset)
                RegFileOut_B <= 32'd0;
            else
                RegFileOut_B <= RegFileOut_B_next;
        end
endmodule
