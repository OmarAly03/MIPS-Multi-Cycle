module mux2to1 #(parameter WIDTH = 32) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input sel,
    output reg [WIDTH-1:0] out
);

always @(*) begin
    case(sel)
        1'b0: out = a;
        1'b1: out = b;
        default: out = {WIDTH{1'bx}};
    endcase
end
endmodule