`ifndef RISCV_DRIVER_SV
`define RISCV_DRIVER_SV

class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)
    
    virtual riscv_if vif;
    int current_instr_idx;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        current_instr_idx = 0;
    endfunction
    
    // Build phase - get interface from config db
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual riscv_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRIVER", "Could not get vif")
    endfunction
    
    // Run phase - get transactions from sequencer and drive them
    virtual task run_phase(uvm_phase phase);
        transaction tx;
        
        // forever begin
        //     seq_item_port.get_next_item(tx);
            
        //     // Todo:
        //     //   This part needs to be cleaned up.
        //     //   Ideally we don't need to write the data beside instruction into DUT.

        //     vif.driver_cb.imem_write <= 1;
        //     vif.driver_cb.imem_addr <= current_instr_idx[11:0];
        //     vif.driver_cb.imem_wdata <= tx.instruction;
            
        //     @(vif.driver_cb); // wait for the next clock edge
            
        //     // Todo:
        //     //   Need to chekc this imem_write, if the time is sufficient.
        //     //   But again, if we only pass the instruction into DUT, 
        //     //   this will not be a problem.

        //     vif.driver_cb.imem_write <= 0;
        //     current_instr_idx++;
            
        //     seq_item_port.item_done();
        // end

        seq_item_port.get_next_item(tx);
        
        // Todo:
        //   This part needs to be cleaned up.
        //   Ideally we don't need to write the data beside instruction into DUT.

        vif.driver_cb.imem_write <= 1;
        vif.driver_cb.imem_addr <= current_instr_idx[11:0];
        vif.driver_cb.imem_wdata <= tx.instruction;
        
        @(vif.driver_cb); // wait for the next clock edge
        
        // Todo:
        //   Need to chekc this imem_write, if the time is sufficient.
        //   But again, if we only pass the instruction into DUT, 
        //   this will not be a problem.

        vif.driver_cb.imem_write <= 0;
        current_instr_idx++;
        
        seq_item_port.item_done();

    endtask

    task reset_phase(uvm_phase phase);
        
        current_instr_idx = 0;
        
        // Todo:
        //   Haven't thought of the way to reset yet..
        
        @(negedge vif.reset);

    endtask
    
endclass
`endif