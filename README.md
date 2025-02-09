# MIPS Multi-Cycle Processor

This repository contains an educational implementation of a MIPS multi-cycle processor using Verilog. The project is structured in modular form, with each file representing a key hardware component such as the ALU, control units, registers, memory, and various multiplexers. This modular architecture makes it easy to understand, modify, and extend the design.

The goal of this project is to provide a clear and concise reference for anyone who wants to implement a MIPS multi-cycle processor from scratch. Each module is briefly explained to keep the documentation focused and accessible without overwhelming the reader.

![MIPS_Multicycle_Processor_Schematic](https://github.com/user-attachments/assets/56d4d178-b7d8-49ef-8be7-21b03c928a29)

Feel free to explore the code, experiment with different configurations, and learn how a multi-cycle processor works at a hardware description level.

---

## ALU Module
The ALU (Arithmetic Logic Unit) performs arithmetic and logic operations on two operands based on a control signal.
- **Arithmetic Operations:** Add, Subtract, etc.
- **Logic Operations:** AND, OR, etc.
- **Result Output:** Provides computed results for further processing.

---

## Sign Extension Module
Converts a 16-bit immediate into a 32-bit signed value by replicating the sign bit.
- **Usage:** Extends immediate values for arithmetic instructions.

---

## Shift Left 2 Module
Shifts a 32-bit value left by 2 positions (multiplying by 4) to calculate branch and jump target addresses.
- **Usage:** Helps align addresses for memory accesses.

---

## Multiplexers
Multiplexers select one of several inputs based on control signals:
- **2-to-1 Mux:** Selects between two 32-bit inputs.
- **3-to-1 Mux:** Chooses one of three 32-bit inputs.
- **4-to-1 Mux:** Routes one of four inputs using a 2-bit selector.

---

## Register File
Holds 32 registers (each 32-bit wide) for processor operations.
- **Features:** Supports asynchronous reads, synchronous writes, and maintains a constant zero register.

---

## Data Register
Temporarily stores data to be passed between processor stages.
- **Features:** Synchronously updates with the clock and can be reset to zero.

---

## Register File Output Registers
Latches outputs from the register file for stable data between stages.
- **RegFileOut_A:** Stores the first read port output.
- **RegFileOut_B:** Stores the second read port output.

---

## Program Counter
Maintains the address of the current instruction.
- **Features:** Updates on each clock cycle, supports reset, and initializes to a preset address.

---

## Memory
Implements unified storage for both instructions and data.
- **Operations:** Supports combinational read and synchronous write with word-aligned addressing.

---

## Instruction Register
Holds the instruction fetched from memory.
- **Features:** Synchronously updated with the clock and resets to zero.

---

## ALU Out Register
Stores the output from the ALU for subsequent processing stages.
- **Features:** Captures ALU results on the clock edge and supports reset functionality.

---

## Control Unit
Generates control signals required for the execution of instructions via a finite state machine.
- **States:** Transitions through fetch, decode, execute, memory access, and write-back stages.

---

## ALU Control Module
Decodes the ALU operation based on the main control and function fields.
- **Inputs:** ALUOp and function bits.
- **Output:** 4-bit control signal used by the ALU.

---

## Top-Level Module
Integrates all submodules (control unit, ALU, registers, memory, multiplexers, etc.) into a complete multi-cycle processor.
- **Function:** Connects the datapath and control signals to implement the processor's operation.

---

## Testbench Module
Verifies that the processor operates correctly through simulation.
- **Function:** Instantiates the design, generates clock/reset signals, applies test stimuli, and monitors key signals.

---

## Test Program
Below is a table summarizing the test program instructions loaded into memory in the text section:

| Memory Address | Instruction Hex | Assembly Instruction   |
|----------------|-----------------|------------------------|
| 1024           | 20020005        | addi $2, $0, 5         |
| 1028           | 2003000C        | addi $3, $0, 12        |
| 1032           | 2067FFF7        | add $1, $2, $3         |
| 1036           | 00E22025        | add $4, $7, $2         |
| 1040           | 00642824        | or $5, $3, $4          |
| 1044           | 00A42820        | and $5, $3, $4         |
| 1048           | 00A52820        | add $5, $5, $4         |
| 1052           | 00A52820        | add $5, $5, $4         |
| 1056           | 0064202A        | slt $4, $3, $4         |
| 1060           | 0064202A        | slt $4, $3, $4         |
| 1064           | 20050000        | addi $5, $0, 0         |
| 1068           | 00E2202A        | slt $4, $7, $2         |
| 1072           | 00853820        | add $7, $4, $5         |
| 1076           | 00E23822        | sub $7, $7, $2         |
| 1080           | AC670044        | sw $7, 68($3)          |
| 1084           | 8C020050        | lw $2, 80($0)          |
| 1088           | 08000112        | j end                  |
| 1092           | 20020001        | addi $2, $0, 1         |
| 1096           | AC020054        | sw $2, 84($0)          |
