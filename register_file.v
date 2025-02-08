module register_file (
    input clk,
    input rst,
    input [4:0] read_reg1,     // rs
    input [4:0] read_reg2,     // rt
    input [4:0] write_reg,     // rd
    input [31:0] write_data,
    input reg_write,           // Write enable
    output [31:0] read_data1,
    output [31:0] read_data2
);

    // Register array
    reg [31:0] registers [0:31];
    integer i;

    // Asynchronous read
    assign read_data1 = (read_reg1 == 0) ? 32'b0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 0) ? 32'b0 : registers[read_reg2];

    // Synchronous write
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (reg_write && write_reg != 0) begin
            registers[write_reg] <= write_data;
        end
    end

endmodule
