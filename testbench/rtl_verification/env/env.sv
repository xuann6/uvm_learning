`ifndef RISCV_ENV_SV
`define RISCV_ENV_SV

class riscv_env extends uvm_env;
    `uvm_component_utils(riscv_env)
    
    driver       drv;
    sequencer    sqr;
    monitor      mon;
    scoreboard   scb;
    
    virtual riscv_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Get interface from config DB
        if (!uvm_config_db#(virtual riscv_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("ENV", "Could not get vif from config DB")
        end
        
        // Create components
        drv = driver::type_id::create("drv", this);
        sqr = sequencer::type_id::create("sqr", this);
        mon = monitor::type_id::create("mon", this);
        scb = scoreboard::type_id::create("scb", this);
        
        // Set interface for driver and monitor
        uvm_config_db#(virtual riscv_if)::set(this, "drv", "vif", vif);
        uvm_config_db#(virtual riscv_if)::set(this, "mon", "vif", vif);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Connect driver to sequencer
        drv.seq_item_port.connect(sqr.seq_item_export);

        // Connect monitor to scoreboard
        mon.analysis_port.connect(scb.analysis_imp);
    endfunction
    
    task reset_phase(uvm_phase phase);
        // We are using task here since we will consume simulation time
        // for all the initialization and reset. 

        phase.raise_objection(this);
        
        scb.reset_models();
        initialize_default_registers();
        initialize_default_memory();
        
        phase.drop_objection(this);
    endtask
    
    // Helper method to initialize registers with default values
    function void initialize_default_registers();
        
        // Todo:
        //   Modify based on test cases
        scb.set_initial_reg_value(1, 32'h00000005);  // x1 = 5
        scb.set_initial_reg_value(2, 32'h0000000A);  // x2 = 10
        scb.set_initial_reg_value(3, 32'hFFFFFFFF);  // x3 = -1
        scb.set_initial_reg_value(4, 32'h00000003);  // x4 = 3
    endfunction
    
    // Helper method to initialize memory with default values
    function void initialize_default_memory();
        // Todo:
        //   Modify based on test cases
        scb.set_initial_mem_value(32'h00000014, 32'hABCDEF01); // Memory address 5*4 (20)
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("ENV", $sformatf("\n--- RISCV Pipelined Processor Verification ---\n"), UVM_LOW)
    endfunction
endclass

`endif