# RISC-V Processor Implementation and Verification

## Implementation

## Verification
### File Structure

### Step-by-Step Guideline

#### Transaction
> file: `env/agent/transaction.sv`

- **Purpose**: 
    
    The transaction class creates some standardized data structure that flows between verification components.

    In verification of our processor, our transaction represents a RISC-V instruction (RV32I ISA) along with its expected behavior (including memory addr/data, output reg/data).

- **Key Components**:
  
  - instruction
  - PC
  - expected results (both reg and data)
  - flags inside the processor (reg_write, mem_write, etc)
  - helper function

- **Implementation Details**:

    - `decode_instruction()` - breaks down 32-bit instruction
    - `convert2string()` - provides transaction information for debugging

#### Interface
> file: `tb/interface.sv`

- **Purpose**: 

    The interface acts as the bridge between the DUT and our verification env, allowing the testbench to reuse the interface for multiple testcases. The interface defines the contract between the hardware design and the software verification components. Thus, all signals used for our verification stages or passed into the DUT should be declared in this file. 
    
    The interface ensures proper synchronization through clocking blocks and provides separate access points for drivers and monitors. This maintains a clean verification environment.

- **Key Components**:
- **Implementation Details**:







