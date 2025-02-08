module shift_left_2(
    input [31:0] in,           // Input value
    output [31:0] out          // Shifted output
);

    // Shift left by 2 positions (multiply by 4)
    // Append 00 to LSB, shift out MSBs
    assign out = {in[29:0], 2'b00};

endmodule
