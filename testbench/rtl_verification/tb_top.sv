`include "uvm_macros.svh"
import uvm_pkg::*;

`include "tb/interface.sv"
`include "env/agent/transaction.sv"
`include "env/agent/sequencer.sv"
`include "env/agent/sequence.sv"
`include "env/agent/driver.sv"
`include "env/agent/monitor.sv"
`include "env/scoreboard.sv"
`include "env/env.sv"
`include "test/test.sv"

module top;
    bit clk;
    bit reset;
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // clock period 10ns
    end
    
    // Reset signal
    initial begin
        reset = 1;
        repeat(5) @(posedge clk);
        reset = 0;
    end
    
    if intf(.clk(clk), .reset(reset));
    
    // DUT instantiation
    RISCVPipelined dut(
        .clk(clk),
        .reset(reset)
    );
    
    // Connect DUT and interface signals
    // This depends on your interface definition and DUT signals
    // Example connections might be:
    assign intf.monitor_pc = dut.PC_F;
    assign intf.monitor_instr = dut.instruction_F;
    assign intf.monitor_result = dut.result_W;
    
    // Start UVM testbench
    initial begin
        // Register interface with UVM config database
        uvm_config_db#(virtual if)::set(null, "*", "vif", intf);
        
        // Run the test
        run_test();
    end
    
    // Optional: Add waveform dumping
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top);
    end
endmodule