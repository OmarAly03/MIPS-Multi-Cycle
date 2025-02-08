module dataRegister(
    input clk,
    input reset,
    input [31:0] data_next,

    output reg [31:0] data
);

    always @(posedge clk or posedge reset)
        begin
            if (reset)
                data <= 32'd0;
            else
                data <= data_next;
        end
endmodule
