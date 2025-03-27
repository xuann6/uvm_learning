`timescale 1ns/1ps

module IFID(
  input clk,
  input reset,
  input [31:0] instruction,
  input [31:0] PC, // default DC is 64 bits
  input [31:0] PC_plus4,
  input stall,
  input flush,
  output reg [31:0] inst,
  output reg [31:0] PC_out,
  output reg [31:0] PC_plus4_out
);

    always @(posedge clk) begin
        if (reset == 1'b1 || flush == 1'b1) begin
            inst <= 32'b0;
            PC_out <= 32'b0;
            PC_plus4_out <= 32'b0;
        end 
        else if (stall==1'b0) begin
            inst <= instruction;
            PC_out <= PC;
            PC_plus4_out <= PC_plus4;
        end
        // if stall value is HIGH, the output reg is stalled
  end
endmodule