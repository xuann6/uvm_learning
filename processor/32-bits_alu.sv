`timescale 1ns/1ps

// The encoding method is referenced from the RISC-V Sodor processor 
// developed at UC Berkeley: https://github.com/ucb-bar/riscv-sodor

`define OP_ALU_ADD  5'b00000  // Add
`define OP_ALU_SUB  5'b01010  // Subtract
`define OP_ALU_AND  5'b00111  // Bitwise AND
`define OP_ALU_OR   5'b00110  // Bitwise OR
`define OP_ALU_XOR  5'b00100  // Bitwise XOR
`define OP_ALU_SLT  5'b01100  // SLT (Set Less Than (signed))
`define OP_ALU_SLTU 5'b01110  // SLTU (Set Less Than Unsigned)
`define OP_ALU_SLL  5'b00001  // SLL (Shift Left Logical)
`define OP_ALU_SRL  5'b00101  // SRL (Shift Right Logical)
`define OP_ALU_SRA  5'b01011  // SRA (Shift Right Arithmetic)

module ALU(
    input [31:0] a,
    input [31:0] b,
    input [4:0] alu_op, // make it 5 bits for future extension
    output reg [31:0] result,
<<<<<<< HEAD
<<<<<<< HEAD
    output reg zero
=======
    output reg zero,
>>>>>>> 681e85c (1. Completed top.sv, entering the debugging phase.)
=======
    output reg zero
>>>>>>> 32b7cfd (1. Passed all the unit test.)
);

    always @(*) begin
        case(alu_op)
            `OP_ALU_ADD  : result = a + b;
            `OP_ALU_SUB  : result = a - b;
            `OP_ALU_AND  : result = a & b;
            `OP_ALU_OR   : result = a | b;
            `OP_ALU_XOR  : result = a ^ b;
            `OP_ALU_SLTU : result = (a < b) ? 32'd1 : 32'd0;
            `OP_ALU_SLT  : result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            `OP_ALU_SLL  : result = a << b[4:0];
            `OP_ALU_SRL  : result = a >> b[4:0];
            `OP_ALU_SRA  : result = $signed(a) >>> b[4:0];
            default: result = 0;
        endcase

        zero = (result == 32'd0);
    end
endmodule