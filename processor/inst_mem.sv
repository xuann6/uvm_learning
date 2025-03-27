`timescale 1ns/1ps

module inst_memory(
    input [9:0] addr,
    output reg [31:0] inst,
);
  
    reg [31:0] inst_mem [0:1<<8-1]; // inst memory size 1KB
    wire [7:0] word_addr = addr[9:2];

    always @(*) begin
        inst = inst_mem[word_addr];
    end

endmodule