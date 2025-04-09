`ifndef RISCV_ENV_SV
`define RISCV_ENV_SV

class riscv_env extends uvm_env;
    `uvm_component_utils(riscv_env)
    
    driver       drv;
    monitor      mon;
    scoreboard   scb;
    
    virtual if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Get interface from config DB
        if (!uvm_config_db#(virtual if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("ENV", "Could not get vif from config DB")
        end
        
        // Create components
        drv = driver::type_id::create("drv", this);
        mon = monitor::type_id::create("mon", this);
        scb = scoreboard::type_id::create("scb", this);
        
        // Set interface for components
        uvm_config_db#(virtual if)::set(this, "drv", "vif", vif);
        uvm_config_db#(virtual if)::set(this, "mon", "vif", vif);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Connect monitor to scoreboard
        mon.analysis_port.connect(scb.analysis_imp);
    endfunction
    
    task reset_phase(uvm_phase phase);
        phase.raise_objection(this); // does reset_phase needs this?
        
        // Do all the initialization
        scb.reset_models();
        initialize_default_registers();
        initialize_default_memory();
        
        phase.drop_objection(this);
    endtask
    
    // Helper method to initialize registers with default values
    function void initialize_default_registers();
        // The following values are modified according to the test cases
        scb.set_initial_reg_value(1, 32'h00000005);  // x1 = 5
        scb.set_initial_reg_value(2, 32'h0000000A);  // x2 = 10
        scb.set_initial_reg_value(3, 32'hFFFFFFFF);  // x3 = -1
        scb.set_initial_reg_value(4, 32'h00000003);  // x4 = 3
    endfunction
    
    // Helper method to initialize memory with default values
    function void initialize_default_memory();
        // The following values are modified according to the test cases
        scb.set_initial_mem_value(32'h00000014, 32'hABCDEF01); // Memory address 5*4 (20)
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("ENV", $sformatf("\n--- RISCV Pipelined Processor Verification ---\n"), UVM_LOW)
    endfunction
endclass

`endif