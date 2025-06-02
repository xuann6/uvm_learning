`ifndef RISCV_MONITOR_SV
`define RISCV_MONITOR_SV

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    virtual riscv_if vif;
    
    uvm_analysis_port #(transaction) analysis_port;
    
    bit [31:0] current_instr;
    bit [31:0] current_pc;
    
    // Instruction to transaction mapping (for tracking instruction execution)
    // Address (PC) → Transaction
    transaction instr_map[bit[31:0]];
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction
    
    // Build phase - get interface from config db
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual riscv_if)::get(this, "", "vif", vif))
        `uvm_fatal("MONITOR", "Could not get vif")
    endfunction
    
    // Run phase - monitor DUT activity
    virtual task run_phase(uvm_phase phase);
        transaction tx;
        
        @(negedge vif.reset);
        
        // TODO - this needs to be modified in the future, 
        //        currently the length of this repeat requires to be modified
        //        based on the length of the test case
        repeat(10) begin
            begin

                `uvm_info("MONITOR_DEBUG", $sformatf("monitor_instr=0x%8h, monitor_pc=0x%8h", 
                            vif.monitor_cb.monitor_instr, vif.monitor_cb.monitor_pc), UVM_LOW)

                // Monitor register file writes
                if (vif.monitor_cb.monitor_regwrite && vif.monitor_cb.monitor_rd != 0) begin
                    // transaction for the result
                    tx = create_result_transaction();
                    
                    // send to the scoreboard
                    analysis_port.write(tx);
                end
            
                // Monitor for new instructions
                if (vif.monitor_cb.monitor_instr != 32'h0) begin
                    // Track new instruction
                    track_new_instruction();
                end
                
                // Monitor memory operations
                monitor_memory_operations();
                
                // Wait for next clock edge
                @(vif.monitor_cb);
            end
        end
    
    endtask
    
    // Create a transaction representing an execution result
    function transaction create_result_transaction();
        transaction tx = transaction::type_id::create("tx");
        
        // Gather instruction information if available
        if (instr_map.exists(vif.monitor_cb.monitor_pc)) begin
            tx = instr_map[vif.monitor_cb.monitor_pc];
            
            // Add result information
            tx.result = vif.monitor_cb.monitor_result;
            tx.result_reg = vif.monitor_cb.monitor_rd;
            
            `uvm_info("MONITOR", $sformatf("Observed result: x%0d = 0x%8h for instruction %s at PC=0x%8h", 
                        tx.result_reg, tx.result, tx.instr_name, tx.pc), UVM_MEDIUM)
            
            // Remove from tracking map
            instr_map.delete(vif.monitor_cb.monitor_pc);
        end
        else begin
            // No tracked instruction, create minimal transaction
            tx.pc = vif.monitor_cb.monitor_pc;
            tx.result_reg = vif.monitor_cb.monitor_rd;
            tx.result = vif.monitor_cb.monitor_result;
            
            `uvm_info("MONITOR", $sformatf("Observed untracked result: x%0d = 0x%8h at PC=0x%8h", 
                        tx.result_reg, tx.result, tx.pc), UVM_MEDIUM)
        end
        
        return tx;
    endfunction
    
    // Track a new instruction entering the pipeline
    task track_new_instruction();
        transaction tx = transaction::type_id::create("tx");
        
        // Capture instruction and PC
        tx.instruction = vif.monitor_cb.monitor_instr;
        tx.pc = vif.monitor_cb.monitor_pc;
        
        // Decode instruction fields
        tx.decode_instruction();
        
        // Store in tracking map
        instr_map[tx.pc] = tx;
        
        `uvm_info("MONITOR", $sformatf("Tracking new instruction: %s at PC=0x%8h", tx.instr_name, tx.pc), UVM_MEDIUM)
    endtask
    
    // Monitor memory operations
    task monitor_memory_operations();
        // Monitor memory writes
        if (vif.monitor_cb.dmem_write) begin
        bit [31:0] addr = {18'b0, vif.monitor_cb.dmem_addr};
        
        `uvm_info("MONITOR", $sformatf("Observed memory write: Addr=0x%8h, Data=0x%8h",
                    addr, vif.monitor_cb.dmem_wdata), UVM_MEDIUM)
                    
        // Here you would tie this memory write to a specific instruction
        // if you can correlate it to a PC value
        end
    endtask

endclass

`endif