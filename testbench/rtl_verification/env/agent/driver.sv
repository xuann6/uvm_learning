`ifndef RISCV_DRIVER_SV
`define RISCV_DRIVER_SV

class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)
  
    virtual if vif;
  
     bit [31:0] instr_mem[int]; // datatype is 32 bits, and the keys are int datatype
                                // (since we use current_instr_idx as address)
    bit [31:0] data_mem[int];
  
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
  
    // Reset phase - initialize memories and signals
    task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        // Clear instruction memory
        instr_mem.delete();
        current_instr_idx = 0;
        
        // Clear data memory
        data_mem.delete();
        
        // Wait for reset to be asserted and deasserted
        @(posedge vif.reset);
        @(negedge vif.reset);
        
        phase.drop_objection(this);
    endtask
  
    // Run phase - get transactions from sequencer and drive them
    virtual task run_phase(uvm_phase phase);
        transaction tx;
        
        forever begin
            seq_item_port.get_next_item(tx);
            
            // store instruction in mem
            instr_mem[current_instr_idx] = tx.instruction;
            
            // write to DUT instruction memory
            // (driver cb output to DUT)
            vif.driver_cb.imem_write <= 1;
            vif.driver_cb.imem_addr <= current_instr_idx[11:0];
            vif.driver_cb.imem_wdata <= tx.instruction;
            @(vif.driver_cb); // wait for the next sample defined by cb,
                              // which is synchronized to the posedge clock
            vif.driver_cb.imem_write <= 0;
            
            current_instr_idx++;
            
            // finish this transaction
            seq_item_port.item_done();
        end
    endtask
  
    // helper function for initializing mem
    task init_data_memory(input int addr, input bit [31:0] data);
        data_mem[addr] = data;
        
        // write to DUT data mem
        vif.driver_cb.dmem_write <= 1;
        vif.driver_cb.dmem_addr <= addr[13:0];
        vif.driver_cb.dmem_wdata <= data;
        @(vif.driver_cb);
        vif.driver_cb.dmem_write <= 0;
    endtask
  
    // helper function to initialize the reg file
    task init_register_file(input int reg_num, input bit [31:0] value);
        `uvm_info("DRIVER", $sformatf("Initializing register x%0d to 0x%h", reg_num, value), UVM_MEDIUM)
        
        // Todo
        //   do not have the interface to init the reg file throught uvm env,
        //   the initialization here might be replaced by load inst,
        //   or just hard code the transaction of initialization in this function
    endtask
  
endclass

`endif