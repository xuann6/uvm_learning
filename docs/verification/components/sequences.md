# Sequence Component

## What is Sequence Class?
A sequence generates transactions and sends them to the driver through the sequencer. The sequence class defines **what instructions to test** and **in what order**, making it the primary way to create test scenarios for during verification.

## Class Hierarchy

**Base Sequence:**
- Provides helper functions (`create_instr()`, `send_tx()`)
- Inherited by all test sequences

**File-Based Sequence:**
- Reads instructions from text files
- Inherited by specific test sequences (nop, r-type, i-type, etc.)

**Test Sequences:**
- Each tests a specific instruction type
- Sets filename in constructor, all the testing files are put under `testbench/stimulus/`

## Key Methods

### body()
The main entry point where transaction generation logic is defined. This is a **fixed UVM method name** that gets called when `sequence.start(sequencer)` is executed.

**Usage:**
```systemverilog
virtual task body();
    transaction tx;
    tx = create_instr(32'h00000013);
    send_tx(tx);
endtask
```

## Some More Details

### What Happens when Calling 'start_item()' and 'finish_item()'?

As you can see, we use `sebd_tx(tx)` function which calls 'start_item()' and 'finish_item()' every time after getting an instruction. What's the purpose of doing this? To explain this, we have to understand the entire work flow across sequence, sequencer, and driver: 

```systemverilog
TEST                    SEQUENCE                SEQUENCER           DRIVER
|                        |                        |                  |
|-- seq.start(sqr) ----->|                        |                  |
|                        |-- body() executes      |                  |
|                        |                        |                  |
|                        |-- start_item(tx1) ---->|                  |
|                        |-- finish_item(tx1) --->|-- queue tx1      |
|                        |   (blocked)            |                  |
|                        |                        |<-- get_next_item()|
|                        |                        |-- send tx1 ----->|
|                        |                        |                  |-- drive tx1
|                        |                        |<-- item_done() --|
|                        |<-- unblocked ----------|                  |
|                        |                        |                  |
|                        |-- start_item(tx2) ---->|                  |
|                        |-- finish_item(tx2) --->|-- queue tx2      |
|                        |   (blocked)            |                  |
|                        |                        |<-- get_next_item()|
|                        |                        |-- send tx2 ----->|
|                        |                        |                  |-- drive tx2
|                        |                        |<-- item_done() --|
|                        |<-- unblocked ----------|                  |
|                        |                        |                  |
|                        |-- body() completes     |                  |
|<-- start() returns ----|                        |                  |
|                        |                        |                  |
|                        |                        |<-- get_next_item()|
|                        |                        |   (queue empty)  |
|                        |                        |   (waits...)     |
```

In `run_phase()` of test, we create and start a sequence. The `start()` method calls the `body()` method, which executes our overridden `body()` implementation. Inside `body()`, we call `start_item()` and `finish_item()` to **send transactions to the sequencer**.

**The sequencer acts as a passive middleman with a queue**. When the driver calls `get_next_item()`, it retrieves one transaction from the sequencer's queue. The sequence's `finish_item()` call remains blocked until the driver calls `item_done()`. This process repeats for each transaction until `body()` completes, then control returns to the test.