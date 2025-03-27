`timescale 1ns/1ps

module inst_memory(
    input [11:0] addr,
    output reg [31:0] inst
);
  
    reg [31:0] inst_mem [0:1<<10-1]; // inst memory size 4KB
    wire [9:0] word_addr = addr[11:2];

    always @(*) begin
        inst = inst_mem[word_addr];
    end

endmodule