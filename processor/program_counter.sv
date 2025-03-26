module PC(
    input clk, reset,
    input stall,
    input [31:0] PC_next, // from either jump/branch or PC+4
                          // there's a mux before this module
    output reg [31:0] PC,
);

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            PC <= 32'b0;
        end
        else if (stall == 1'b0) begin
            PC <= PC_next;
        end
    end
endmodule