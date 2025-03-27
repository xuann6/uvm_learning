`timescale 1ns/1ps

module HazardUnit(
    input logic [4:0] rs1_D, rs2_D, rs1_E, rs2_E, rd_E, rd_M, rd_W,
    input logic resultSrc_E, regWrite_M, regWrite_W, PCSrc_E,
    output logic [1:0] forwardA_E, forwardB_E,
    output logic stall_F, stall_D, flush_D, flush_E
);  
  
    always_comb begin
        if (rs1_E != 5'b0 && rs1_E == rd_M && regWrite_M) // write destination is equal to execution source,
                                                          // and we know that this data is written back
            forwardA_E = 2'b10;
        else if (rs1_E != 5'b0 && rs1_E == rd_W && regWrite_W) // same logic, but in WB stage
            forwardA_E = 2'b01;
        else
            forwardA_E = 2'b00;
            
        if (rs2_E != 5'b0 && rs2_E == rd_M && regWrite_M)
            forwardB_E = 2'b10;
        else if (rs2_E != 5'b0 && rs2_E == rd_W && regWrite_W)
            forwardB_E = 2'b01;
        else
            forwardB_E = 2'b00;
    end
    
    // signal for load-use hazard, which we need to stall for one cycle,
    // waiting for load to enter the MEM stage, and the following inst can 
    // get the correct value forward from MEM stage to EXE stage.
    logic lwStall;
    assign lwStall = resultSrc_E && ((rs1_D == rd_E) || (rs2_D == rd_E));
    
    // stall and flush
    assign stall_F = lwStall;
    assign stall_D = lwStall;
<<<<<<< HEAD
<<<<<<< HEAD
    assign flush_D = PCSrc_E;            // Flush if branch/jump
    assign flush_E = lwStall || PCSrc_E; // Flush if load-use hazard or branch/jump
=======
    assign flush_D = PCSrc_E;    // Flush if branch/jump
    assign flush_E = lwStall || PCSrc_E;  // Flush if load-use hazard or branch/jump
>>>>>>> 681e85c (1. Completed top.sv, entering the debugging phase.)
=======
    assign flush_D = PCSrc_E;            // Flush if branch/jump
    assign flush_E = lwStall || PCSrc_E; // Flush if load-use hazard or branch/jump
>>>>>>> 32b7cfd (1. Passed all the unit test.)
endmodule