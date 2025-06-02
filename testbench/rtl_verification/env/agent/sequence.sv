`ifndef RISCV_SEQUENCES_SV
`define RISCV_SEQUENCES_SV

class base_seq extends uvm_sequence #(transaction);
    `uvm_object_utils(base_seq)
    
    function new(string name = "base_seq");
        super.new(name);
    endfunction
    
    // Helper function to create basic instruction transaction
    virtual function transaction create_instr(bit [31:0] instr_code, string instr_name);
        transaction tx;
        tx = transaction::type_id::create("tx");
        tx.instruction = instr_code;
        tx.decode_instruction(); // got instr_name, rd, rs1, rs2, and all the other things
        return tx;
    endfunction
    
    // Helper function to send transaction to driver
    virtual task send_tx(transaction tx);
        start_item(tx);
        finish_item(tx);
    endtask
endclass

// NOP for base test 
class nop_seq extends base_seq;
    `uvm_object_utils(nop_seq)
    
    function new(string name = "nop_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        transaction tx;
        
        `uvm_info("NOP_SEQ", "Sending NOP instruction for base test", UVM_MEDIUM)
        
        // ADDI x0, x0, 0 (NOP - does nothing)
        tx = create_instr(32'h00000013, "NOP");
        send_tx(tx);
    endtask
endclass

// R-Type Instructions Sequence
class r_type_seq extends base_seq;
    `uvm_object_utils(r_type_seq)
    
    function new(string name = "r_type_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        transaction tx;
        
        // ADD x5, x1, x2 (x5 = x1 + x2 = 5 + 10 = 15)
        `uvm_info("R_TYPE_SEQ", "Testing ADD instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000001000001000001010110011, "ADD");
        send_tx(tx);
        
        // SUB x6, x2, x1 (x6 = x2 - x1 = 10 - 5 = 5)
        `uvm_info("R_TYPE_SEQ", "Testing SUB instruction", UVM_MEDIUM)
        tx = create_instr(32'b01000000000100010000001100110011, "SUB");
        send_tx(tx);
        
        // AND x7, x2, x3 (x7 = x2 & x3 = 0xA & 0xFFFFFFFF = 0xA)
        `uvm_info("R_TYPE_SEQ", "Testing AND instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000001100010111001110110011, "AND");
        send_tx(tx);
        
        // OR x8, x1, x2 (x8 = x1 | x2 = 5 | 10 = 15)
        `uvm_info("R_TYPE_SEQ", "Testing OR instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000001000001110010000110011, "OR");
        send_tx(tx);
        
        // XOR x9, x1, x2 (x9 = x1 ^ x2 = 5 ^ 10 = 15)
        `uvm_info("R_TYPE_SEQ", "Testing XOR instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000001000001100010010110011, "XOR");
        send_tx(tx);
        
        // SLT x10, x1, x2 (x10 = (x1 < x2) ? 1 : 0 = 1)
        `uvm_info("R_TYPE_SEQ", "Testing SLT instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000001000001010010100110011, "SLT");
        send_tx(tx);
        
        // SLL x11, x1, x4 (x11 = x1 << x4 = 5 << 3 = 40)
        `uvm_info("R_TYPE_SEQ", "Testing SLL instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000010000001001010110110011, "SLL");
        send_tx(tx);
        
        // SRL x12, x2, x4 (x12 = x2 >> x4 = 10 >> 3 = 1)
        `uvm_info("R_TYPE_SEQ", "Testing SRL instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000010000010101011000110011, "SRL");
        send_tx(tx);
        
        // SRA x13, x3, x4 (x13 = x3 >> x4 = -1 >> 3 = -1)
        `uvm_info("R_TYPE_SEQ", "Testing SRA instruction", UVM_MEDIUM)
        tx = create_instr(32'b01000000010000011101011010110011, "SRA");
        send_tx(tx);
    endtask
endclass

// I-Type Instructions Sequence
class i_type_seq extends base_seq;
    `uvm_object_utils(i_type_seq)
    
    function new(string name = "i_type_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        transaction tx;
        
        // ADDI x14, x1, 20 (x14 = x1 + 20 = 5 + 20 = 25)
        `uvm_info("I_TYPE_SEQ", "Testing ADDI instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000001010000001000011100010011, "ADDI");
        send_tx(tx);
        
        // ANDI x15, x2, 7 (x15 = x2 & 7 = 10 & 7 = 2)
        `uvm_info("I_TYPE_SEQ", "Testing ANDI instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000011100010111011110010011, "ANDI");
        send_tx(tx);
        
        // ORI x16, x1, 10 (x16 = x1 | 10 = 5 | 10 = 15)
        `uvm_info("I_TYPE_SEQ", "Testing ORI instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000101000001110100000010011, "ORI");
        send_tx(tx);
        
        // XORI x17, x1, 10 (x17 = x1 ^ 10 = 5 ^ 10 = 15)
        `uvm_info("I_TYPE_SEQ", "Testing XORI instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000101000001100100010010011, "XORI");
        send_tx(tx);
        
        // SLTI x18, x1, 10 (x18 = (x1 < 10) ? 1 : 0 = 1)
        `uvm_info("I_TYPE_SEQ", "Testing SLTI instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000101000001010100100010011, "SLTI");
        send_tx(tx);
        
        // SLLI x19, x1, 4 (x19 = x1 << 4 = 5 << 4 = 80)
        `uvm_info("I_TYPE_SEQ", "Testing SLLI instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000010000001001100110010011, "SLLI");
        send_tx(tx);
        
        // SRLI x20, x2, 2 (x20 = x2 >> 2 = 10 >> 2 = 2)
        `uvm_info("I_TYPE_SEQ", "Testing SRLI instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000001000010101101000010011, "SRLI");
        send_tx(tx);
        
        // SRAI x21, x3, 4 (x21 = x3 >> 4 = -1 >> 4 = -1)
        `uvm_info("I_TYPE_SEQ", "Testing SRAI instruction", UVM_MEDIUM)
        tx = create_instr(32'b01000000010000011101101010010011, "SRAI");
        send_tx(tx);
    endtask
endclass

// Load/Store Instructions Sequence
class load_store_seq extends base_seq;
    `uvm_object_utils(load_store_seq)
    
    function new(string name = "load_store_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        transaction tx;
        
        // SW x2, 0(x0) (Store x2 to mem[0])
        `uvm_info("LOAD_STORE_SEQ", "Testing SW instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000000001000000010000000100011, "SW");
        send_tx(tx);
        
        // Add a few NOPs to avoid hazards
        for (int i = 0; i < 3; i++) begin
            tx = create_instr(32'h00000013, "NOP");  // ADDI x0, x0, 0
            send_tx(tx);
        end
        
        // LW x22, 5*4(x0) (Load from mem[5] to x22)
        `uvm_info("LOAD_STORE_SEQ", "Testing LW instruction", UVM_MEDIUM)
        tx = create_instr(32'b00000001010000000010101100000011, "LW");
        send_tx(tx);
    endtask
endclass

// Branch Instructions Sequence
class branch_seq extends base_seq;
    `uvm_object_utils(branch_seq)
    
    function new(string name = "branch_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        transaction tx;
        
        // BEQ branch taken test
        `uvm_info("BRANCH_SEQ", "Testing BEQ (Branch Taken)", UVM_MEDIUM)
        
        // ADDI x23, x0, 5    # x23 = 5
        tx = create_instr(32'b00000000010100000000101110010011, "ADDI");
        send_tx(tx);
        
        // ADDI x24, x0, 5    # x24 = 5 (same as x23)
        tx = create_instr(32'b00000000010100000000110000010011, "ADDI");
        send_tx(tx);
        
        // BEQ x23, x24, 12   # Branch to PC+12 if x23 == x24
        tx = create_instr(32'b00000001100010111000001100100011, "BEQ");
        send_tx(tx);
        
        // ADDI x25, x0, 10  # x25 = 10 (should not execute)
        tx = create_instr(32'b00000000101000000000110010010011, "ADDI");
        send_tx(tx);
        
        // ADDI x25, x0, 20  # x25 = 20 (should not execute)
        tx = create_instr(32'b00000001010000000000110010010011, "ADDI");
        send_tx(tx);
        
        // ADDI x25, x0, 30  # x25 = 30 (should execute after branch)
        tx = create_instr(32'b00000001111000000000110010010011, "ADDI");
        send_tx(tx);
        
        // BNE branch taken test
        `uvm_info("BRANCH_SEQ", "Testing BNE (Branch Taken)", UVM_MEDIUM)
        
        // ADDI x23, x0, 5    # x23 = 5
        tx = create_instr(32'b00000000010100000000101110010011, "ADDI");
        send_tx(tx);
        
        // ADDI x24, x0, 10   # x24 = 10 (different from x23)
        tx = create_instr(32'b00000000101000000000110000010011, "ADDI");
        send_tx(tx);
        
        // BNE x23, x24, 12   # Branch to PC+12 if x23 != x24
        tx = create_instr(32'b00000001100010111001001100100011, "BNE");
        send_tx(tx);
        
        // ADDI x26, x0, 10  # x26 = 10 (should not execute)
        tx = create_instr(32'b00000000101000000000110100010011, "ADDI");
        send_tx(tx);
        
        // ADDI x26, x0, 20  # x26 = 20 (should not execute)
        tx = create_instr(32'b00000001010000000000110100010011, "ADDI");
        send_tx(tx);
        
        // ADDI x26, x0, 40  # x26 = 40 (should execute after branch)
        tx = create_instr(32'b00000010100000000000110100010011, "ADDI");
        send_tx(tx);
    endtask
endclass

// U-Type Instructions Sequence
class u_type_seq extends base_seq;
    `uvm_object_utils(u_type_seq)
    
    function new(string name = "u_type_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        transaction tx;
        
        // LUI x27, 0xABCDE (x27 = 0xABCDE000)
        `uvm_info("U_TYPE_SEQ", "Testing LUI instruction", UVM_MEDIUM)
        tx = create_instr(32'b10101011110011011110110110110111, "LUI");
        send_tx(tx);
    endtask
endclass

// Complete Test Sequence (combines all instruction types)
class complete_test_seq extends base_seq;
    `uvm_object_utils(complete_test_seq)
    
    function new(string name = "complete_test_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        r_type_seq r_seq;
        i_type_seq i_seq;
        load_store_seq ls_seq;
        branch_seq b_seq;
        u_type_seq u_seq;
        
        `uvm_info("COMPLETE_SEQ", "Starting complete test sequence", UVM_LOW)
        
        r_seq = r_type_seq::type_id::create("r_seq");
        i_seq = i_type_seq::type_id::create("i_seq");
        ls_seq = load_store_seq::type_id::create("ls_seq");
        b_seq = branch_seq::type_id::create("b_seq");
        u_seq = u_type_seq::type_id::create("u_seq");
        
        // Initialize and run sequences
        r_seq.start(m_sequencer);
        #100;
        i_seq.start(m_sequencer);
        #100;
        ls_seq.start(m_sequencer);
        #100;
        b_seq.start(m_sequencer);
        #100;
        u_seq.start(m_sequencer);
    endtask
endclass

`endif