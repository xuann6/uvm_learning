`timescale 1ns/1ps

module registerFile(
    input clk,
    input reset,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input w_enable,
    input [31:0] w_data,
    output reg [31:0] r_data1,
    output reg [31:0] r_data2,
);
    reg [31:0] r_file [0:31];
 
    always @(*) begin
        if (reset==1'b1) begin
                r_data1 = 32'd0;
                r_data2 = 32'd0;
            end
        else begin
            r_data1 = r_file[rs1];
            r_data2 = r_file[rs2];
        end
    end

    always @(posedge reset) begin // initialize the r_file value to all zero
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
            r_file[i] <= 32'd0;
        end
    end

    always @(negedge clk) begin
        if (w_enable==1'b1 && rd!=5'd0) // make sure x0 is always zero
            r_file[rd] = w_data;
    end

endmodule