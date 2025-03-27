`timescale 1ns/1ps

module ControlUnit(
    input [6:0] opcode,
    input [2:0] funct3,
    input funct7_bit5,
    
    // Control outputs
    output reg regWrite_D,
    output reg [1:0] resultSrc_D,
    output reg memWrite_D,
    output reg jump_D,
    output reg branch_D,
    output reg [4:0] ALUControl_D, // make this 5-bits for future extension
    output reg ALUSrc_D,
<<<<<<< HEAD
<<<<<<< HEAD
    output reg [1:0] immSrc_D
=======
    output reg [1:0] immSrc_D,
>>>>>>> 681e85c (1. Completed top.sv, entering the debugging phase.)
=======
    output reg [1:0] immSrc_D
>>>>>>> 32b7cfd (1. Passed all the unit test.)
);

    // Define instruction opcodes (RISC-V)
    // RV32I ISA source: https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html
    localparam OPCODE_LOAD    = 7'b0000011;
    localparam OPCODE_STORE   = 7'b0100011;
    localparam OPCODE_BRANCH  = 7'b1100011;
    localparam OPCODE_JALR    = 7'b1100111;
    localparam OPCODE_JAL     = 7'b1101111;
    localparam OPCODE_OP_IMM  = 7'b0010011;
    localparam OPCODE_OP      = 7'b0110011;
    localparam OPCODE_AUIPC   = 7'b0010111;
    localparam OPCODE_LUI     = 7'b0110111;
    
    // Define ALU operations
    localparam ALU_ADD  = 5'b00000;
    localparam ALU_SUB  = 5'b01010;
    localparam ALU_AND  = 5'b00111;
    localparam ALU_OR   = 5'b00110;
    localparam ALU_XOR  = 5'b00100;
    localparam ALU_SLT  = 5'b01100;
    localparam ALU_SLL  = 5'b00001;
    localparam ALU_SRL  = 5'b00101;
    localparam ALU_SRA  = 5'b01011;
    
    // Define immediate format types
    localparam IMM_I = 2'b00;  // I-type
    localparam IMM_S = 2'b01;  // S-type
    localparam IMM_B = 2'b10;  // B-type
    localparam IMM_J = 2'b11;  // J-type/U-type
    
    // Define result sources
    localparam RESULT_ALU    = 2'b00;
    localparam RESULT_MEM    = 2'b01;
    localparam RESULT_PC4    = 2'b10;
    localparam RESULT_PC_IMM = 2'b11;
    
    // Main control logic
    always @(*) begin
        regWrite_D = 1'b0;
        resultSrc_D = RESULT_ALU;
        memWrite_D = 1'b0;
        jump_D = 1'b0;
        branch_D = 1'b0;
        ALUControl_D = ALU_ADD;
        ALUSrc_D = 1'b0;
        immSrc_D = IMM_I;
        
        case(opcode)
            OPCODE_LOAD: begin
                regWrite_D = 1'b1;
                resultSrc_D = RESULT_MEM;
                ALUSrc_D = 1'b1;
                immSrc_D = IMM_I;
            end
            
            OPCODE_STORE: begin
                memWrite_D = 1'b1;
                ALUSrc_D = 1'b1;     // Use immediate
                immSrc_D = IMM_S;    // S-type immediate
            end
            
            OPCODE_BRANCH: begin
                branch_D = 1'b1;
                ALUSrc_D = 1'b0;
                immSrc_D = IMM_B;
                
                case(funct3)
                    3'b000: ALUControl_D = ALU_SUB;  // BEQ
                    3'b001: ALUControl_D = ALU_SUB;  // BNE
                    3'b100: ALUControl_D = ALU_SLT;  // BLT
                    3'b101: ALUControl_D = ALU_SLT;  // BGE
                    3'b110: ALUControl_D = ALU_SLT;  // BLTU
                    3'b111: ALUControl_D = ALU_SLT;  // BGEU
                    default: ALUControl_D = ALU_SUB;
                endcase
            end
            
            OPCODE_JAL: begin
                regWrite_D = 1'b1;
                resultSrc_D = RESULT_PC4;
                jump_D = 1'b1;
                immSrc_D = IMM_J;
            end
            
            OPCODE_JALR: begin
                regWrite_D = 1'b1;
                resultSrc_D = RESULT_PC4;
                jump_D = 1'b1;
                ALUSrc_D = 1'b1;
                immSrc_D = IMM_I;
            end
            
            OPCODE_OP_IMM: begin
                regWrite_D = 1'b1;
                ALUSrc_D = 1'b1;
                immSrc_D = IMM_I;
                
                case(funct3)
                    3'b000: ALUControl_D = ALU_ADD;  // ADDI
                    3'b010: ALUControl_D = ALU_SLT;  // SLTI
                    3'b011: ALUControl_D = ALU_SLT;  // SLTIU
                    3'b100: ALUControl_D = ALU_XOR;  // XORI
                    3'b110: ALUControl_D = ALU_OR;   // ORI
                    3'b111: ALUControl_D = ALU_AND;  // ANDI
                    3'b001: ALUControl_D = ALU_SLL;  // SLLI
<<<<<<< HEAD
<<<<<<< HEAD
                    3'b101: ALUControl_D = funct7_bit5 ? ALU_SRA : ALU_SRL; // SRLI/SRAI
=======
                    3'b101: ALUControl_D = funct7_bit5 ? ALU_SRL : ALU_SLL; // SRLI/SRAI
>>>>>>> 681e85c (1. Completed top.sv, entering the debugging phase.)
=======
                    3'b101: ALUControl_D = funct7_bit5 ? ALU_SRA : ALU_SRL; // SRLI/SRAI
>>>>>>> 32b7cfd (1. Passed all the unit test.)
                    default: ALUControl_D = ALU_ADD;
                endcase
            end
            
            OPCODE_OP: begin
                regWrite_D = 1'b1;
                ALUSrc_D = 1'b0;
                
                case(funct3)
                    3'b000: ALUControl_D = funct7_bit5 ? ALU_SUB : ALU_ADD; // ADD/SUB
                    3'b010: ALUControl_D = ALU_SLT;  // SLT
                    3'b011: ALUControl_D = ALU_SLT;  // SLTU
                    3'b100: ALUControl_D = ALU_XOR;  // XOR
                    3'b110: ALUControl_D = ALU_OR;   // OR
                    3'b111: ALUControl_D = ALU_AND;  // AND
                    3'b001: ALUControl_D = ALU_SLL;  // SLL
<<<<<<< HEAD
<<<<<<< HEAD
                    3'b101: ALUControl_D = funct7_bit5 ? ALU_SRA : ALU_SRL; // SRL/SRA
=======
                    3'b101: ALUControl_D = funct7_bit5 ? ALU_SRL : ALU_SLL; // SRL/SRA
>>>>>>> 681e85c (1. Completed top.sv, entering the debugging phase.)
=======
                    3'b101: ALUControl_D = funct7_bit5 ? ALU_SRA : ALU_SRL; // SRL/SRA
>>>>>>> 32b7cfd (1. Passed all the unit test.)
                    default: ALUControl_D = ALU_ADD;
                endcase
            end
            
            OPCODE_LUI: begin
                regWrite_D = 1'b1;
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 32b7cfd (1. Passed all the unit test.)
                resultSrc_D = RESULT_ALU;
                memWrite_D = 1'b0;
                jump_D = 1'b0;
                branch_D = 1'b0;
                ALUControl_D = ALU_ADD;
<<<<<<< HEAD
=======
>>>>>>> 681e85c (1. Completed top.sv, entering the debugging phase.)
=======
>>>>>>> 32b7cfd (1. Passed all the unit test.)
                ALUSrc_D = 1'b1;
                immSrc_D = IMM_J;
            end
            
            OPCODE_AUIPC: begin
                regWrite_D = 1'b1;
                resultSrc_D = RESULT_PC_IMM;
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 32b7cfd (1. Passed all the unit test.)
                memWrite_D = 1'b0;
                jump_D = 1'b0;
                branch_D = 1'b0;
                ALUControl_D = ALU_ADD;
<<<<<<< HEAD
=======
>>>>>>> 681e85c (1. Completed top.sv, entering the debugging phase.)
=======
>>>>>>> 32b7cfd (1. Passed all the unit test.)
                ALUSrc_D = 1'b1;
                immSrc_D = IMM_J;
            end
            
            default: begin
                regWrite_D = 1'b0;
                resultSrc_D = RESULT_ALU;
                memWrite_D = 1'b0;
                jump_D = 1'b0;
                branch_D = 1'b0;
                ALUControl_D = ALU_ADD;
                ALUSrc_D = 1'b0;
                immSrc_D = IMM_I;
            end
        endcase
    end
endmodule