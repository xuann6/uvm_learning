`timescale 1ns/1ps

module inst_memory(
    input [11:0] addr,
    output reg [31:0] inst
);
  
    reg [31:0] inst_mem [0:1<<10-1]; // inst memory size 4KB
    wire [9:0] word_addr = addr[11:2];

    // for testing if the instruction memory can be read correctly
    initial begin
        for (int i = 0; i < (1<<10); i++) begin
            inst_mem[i] = 32'h00000000;
        end
        
        inst_mem[0] = 32'h00000013;
        inst_mem[1] = 32'h00000013;
        inst_mem[2] = 32'h00000013;
    end

    always @(*) begin
        inst = inst_mem[word_addr];
    end

endmodule