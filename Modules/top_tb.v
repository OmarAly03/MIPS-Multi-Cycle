module top_tb;
    reg clk;
    reg reset;

    // Instantiate top module
    top topmodule(
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize and reset
        reset = 1;
        #10;
        reset = 0;
        
        // Run simulation
        #1000;
        $display("Ended");
    end

  // Monitor signals
  initial begin
      // Display every 5 time units
      forever #5 
      $display("---------------------------------------------------------------------------------------------------------\n
  | Time = %0d | reset = %b   | state = %d    | PC = %h      | Instr = %h   |\n
  | Registers  | Reg2 = %h    | Reg3 = %h     | Reg1 = %h    | Reg5 = %h    | Reg7 = %h   |\n
  | Memory     | Mem[20] = %h | Mem[21] = %h  |\n 
  | Control    | IorD = %b    | MemWrite = %b | IRWrite = %b | PCWrite = %b | Branch = %b | PCSrc = %b    |\n
              | ALUOp = %b   | ALUSrcB = %b  | ALUSrcA = %b | RegWrite=%b  | RegDst=%b   | MemtoReg = %b |\n
  ---------------------------------------------------------------------------------------------------------\n",
          $time,
          reset,
          topmodule.cu.state,
          topmodule.PC,
          topmodule.Instruction,
          topmodule.regFile.registers[2],
          topmodule.regFile.registers[3],
          topmodule.regFile.registers[1],
          topmodule.regFile.registers[5],
          topmodule.regFile.registers[7],
          topmodule.memory.Memory[20],
          topmodule.memory.Memory[21],
          topmodule.IorD,
          topmodule.MemWrite,
          topmodule.IRWrite,
          topmodule.PCWrite,
          topmodule.Branch,
          topmodule.PCSrc,
          topmodule.ALUOp,
          topmodule.ALUSrcB,
          topmodule.ALUSrcA,
          topmodule.RegWrite,
          topmodule.RegDst,
          topmodule.MemtoReg
      );
  end

  // If successful, it should write the value -4 to address 84
  always @(negedge clk) begin
    if(topmodule.MemWrite) begin
      if(topmodule.Address === 84 & topmodule.B === -4) begin
        #30;
        $display("Simulation succeeded");
        $stop;
      end
    end
  end
endmodule