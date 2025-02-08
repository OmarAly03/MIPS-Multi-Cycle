module sign_extend(
    input [15:0] immediate,     // 16-bit immediate from instruction
    output [31:0] extended      // 32-bit sign extended output
);

    // Sign extension done by replicating the MSB (bit 15)
    assign extended = {{16{immediate[15]}}, immediate};

endmodule
