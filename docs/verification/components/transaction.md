# Transaction Component

## What is Transaction Class?
One transaction represents one instruction that flows through the entire verification environment. The transaction class contains different fields and methods used by various components (sequences, driver, monitor, scoreboard) to complete their verification tasks. 

Based on the figure below, after having this class, we basically have the ability to create an actual transaction in sequencer, which is the very first part of the entire flow. In other components as driver and monitor, we will demonstrate and show how the entire flow is completed.


## Transaction Flow (from Cluade AI)
```
SEQUENCE                    DRIVER                    DUT
   |                           |                       |
   |-- Create transaction      |                       |
   |-- Randomize instruction   |                       |
   |-- Decode instruction      |                       |
   |-- Send to driver -------->|                       |
                               |-- Set PC              |
                               |-- Drive instruction ->|
                                                        |
                                                        v
SCOREBOARD              MONITOR                     (Execute)
   |                       |                           |
   |<-- Send result -------|<-- Observe outputs -------|
   |-- Check expected      |
   |    vs actual          |
   |-- Report PASS/FAIL    |
```

## Key Fields

**Input:**
These fields represent the instruction stimulus sent to the DUT.
- `instruction` - Randomizable 32-bit RISC-V instruction (the main stimulus)
- `pc` - Program counter (used by driver and monitor to track instruction execution)

**Decoded:**
Automatically extracted from the instruction by `decode_instruction()` function.
- `opcode`, `rd`, `rs1`, `rs2`, `funct3`, `funct7` - Instruction fields
- `imm` - Immediate value
- `instr_type` - R_TYPE, I_TYPE, S_TYPE, B_TYPE, U_TYPE, J_TYPE
- `instr_name` - "ADD", "LW", "BEQ", etc.

**Expected Results:**
Used by the scoreboard to verify that DUT outputs match expectations.
- `result` - Expected value
- `result_reg` - Which register gets the result
- `reg_write` - Should write to register?
- `mem_write` - Should write to memory?

## Key Methods

### decode_instruction()
Parses the 32-bit instruction to extract all relevant information.

**Usage:**
```systemverilog=
transaction tx = transaction::type_id::create("tx");
tx.randomize();
tx.decode_instruction();
```

### convert2string()
Creates human-readable output for debugging.

**Usage:**
```systemverilog=
`uvm_info("SCOREBOARD", tx.convert2string(), UVM_MEDIUM);
```