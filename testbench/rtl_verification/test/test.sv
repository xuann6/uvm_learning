`ifndef RISCV_TEST_SV
`define RISCV_TEST_SV

class riscv_base_test extends uvm_test;
    `uvm_component_utils(riscv_base_test)
    
    riscv_env env;
    
    virtual if vif;
    
    function new(string name = "riscv_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Get interface from config DB
        if (!uvm_config_db#(virtual if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("TEST", "Could not get vif from config DB")
        end
        
        // Create environment
        env = riscv_env::type_id::create("env", this);
        
        // Pass interface to environment
        uvm_config_db#(virtual if)::set(this, "env", "vif", vif);
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info("TEST", $sformatf("\n\n********************************************"), UVM_LOW)
        `uvm_info("TEST", $sformatf("RUNNING TEST: %s", get_type_name()), UVM_LOW)
        `uvm_info("TEST", $sformatf("********************************************\n"), UVM_LOW)
        
        #100;
        
        phase.drop_objection(this);
    endtask
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info("TEST", $sformatf("\n\n********************************************"), UVM_LOW)
        `uvm_info("TEST", $sformatf("TEST COMPLETE: %s", get_type_name()), UVM_LOW)
        `uvm_info("TEST", $sformatf("********************************************\n"), UVM_LOW)
    endfunction
endclass

// R-Type Instructions Test, 
// all the following functions are derived from riscv_base_test
class riscv_r_type_test extends riscv_base_test;
    `uvm_component_utils(riscv_r_type_test)
    
    function new(string name = "riscv_r_type_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    task run_phase(uvm_phase phase);
        r_type_seq seq;
        
        phase.raise_objection(this);
        
        `uvm_info("TEST", $sformatf("\n\n********************************************"), UVM_LOW)
        `uvm_info("TEST", $sformatf("RUNNING TEST: %s", get_type_name()), UVM_LOW)
        `uvm_info("TEST", $sformatf("********************************************\n"), UVM_LOW)
        
        #100;
        
        seq = r_type_seq::type_id::create("seq");
        seq.start(env.drv.sequencer);
        
        #200;
        
        phase.drop_objection(this);
    endtask
endclass

// I-Type Instructions Test
class riscv_i_type_test extends riscv_base_test;
    `uvm_component_utils(riscv_i_type_test)
    
    function new(string name = "riscv_i_type_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    task run_phase(uvm_phase phase);
        i_type_seq seq;
        
        phase.raise_objection(this);
        
        `uvm_info("TEST", $sformatf("\n\n********************************************"), UVM_LOW)
        `uvm_info("TEST", $sformatf("RUNNING TEST: %s", get_type_name()), UVM_LOW)
        `uvm_info("TEST", $sformatf("********************************************\n"), UVM_LOW)
        
        #100;
        
        seq = i_type_seq::type_id::create("seq");
        seq.start(env.drv.sequencer);
        
        #200;
        
        phase.drop_objection(this);
    endtask
endclass

// Load/Store Instructions Test
class riscv_load_store_test extends riscv_base_test;
    `uvm_component_utils(riscv_load_store_test)
    
    function new(string name = "riscv_load_store_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    task run_phase(uvm_phase phase);
        load_store_seq seq;
        
        phase.raise_objection(this);
        
        `uvm_info("TEST", $sformatf("\n\n********************************************"), UVM_LOW)
        `uvm_info("TEST", $sformatf("RUNNING TEST: %s", get_type_name()), UVM_LOW)
        `uvm_info("TEST", $sformatf("********************************************\n"), UVM_LOW)
        
        #100;
        
        seq = load_store_seq::type_id::create("seq");
        seq.start(env.drv.sequencer);
        
        #200;
        
        phase.drop_objection(this);
    endtask
endclass

`endif