# Single-Cycle RISC-V Processor (RV32I) 🚀

This repository contains a simple, educational **Single-Cycle RISC-V (RV32I)** processor implemented in SystemVerilog. The architecture is primarily based on the design presented in the _Digital Design and Computer Architecture: RISC-V Edition_ by Harris & Harris, but features several custom optimizations and architectural refinements for better synthesis efficiency and future extensibility.

## 🌟 Key Features & Optimizations

- **RV32I Base Instruction Set Support For Main Instructions:** Capable of executing core R-Type, I-Type, S-Type, B-Type, and J-Type instructions.

## 📜 Supported Instructions

| Type       | Instructions Supported In Core          |
| ---------- | --------------------------------------- |
| **R-Type** | `add`, `sub`, `and`, `or`, `xor`, `slt` |
| **I-Type** | `addi`, `lw`                            |
| **S-Type** | `sw`                                    |
| **B-Type** | `beq`                                   |
| **J-Type** | `jal`                                   |

## 🏗️ Architecture & Datapath

The processor follows a classic von Neumann-like Harvard abstraction for single-cycle execution (separate Instruction and Data memory interfaces outside the core).

### Datapath Execution Flows

_(Add your Circuit Builder schematics below! Here are the 5 main execution paths you should showcase:)_

#### 1. R-Type Instruction (`add`, `sub`, etc.)

![R-Type Datapath](docs/images/r_type_datapath.png) <!-- Replace with your actual image path -->
_Characteristics: ALUSrc selects Register (`RD2`), ResultSrc selects ALU result, RegWrite is Enabled._

#### 2. I-Type Instruction (`lw` - Load Word)

![Load Datapath](docs/images/lw_datapath.png) <!-- Replace with your actual image path -->
_Characteristics: Critical Path! ALUSrc selects Immediate, ALU calculates address, ResultSrc selects Data Memory output._

#### 3. S-Type Instruction (`sw` - Store Word)

![Store Datapath](docs/images/sw_datapath.png) <!-- Replace with your actual image path -->
_Characteristics: MemWrite is Enabled, `RD2` is wired directly to Data Memory `WriteData`, RegWrite is Disabled._

#### 4. B-Type Instruction (`beq` - Branch if Equal)

![Branch Datapath](docs/images/beq_datapath.png) <!-- Replace with your actual image path -->
_Characteristics: Feedback loop engaged! ALU calculates subtraction, `Zero` flag goes to Controller, PCSrc toggles PC MUX to target address._

#### 5. J-Type Instruction (`jal` - Jump and Link)

![Jump Datapath](docs/images/jal_datapath.png) <!-- Replace with your actual image path -->
_Characteristics: Result MUX selects `PC+4` to save the return address in the selected register._

## 📂 Module Hierarchy

```text
riscvsingle (Top Module)
├── controller
│   ├── maindec (Main Decoder - Opcode based)
│   └── aludec  (ALU Decoder - funct3/funct7 based)
└── datapath
    ├── pc_reg     (Program Counter)
    ├── signextend (Immediate Generator)
    ├── regfile    (32x32-bit Register File)
    └── alu        (Arithmetic Logic Unit)
```

## 🚀 Running the Tests

The project includes a comprehensive SystemVerilog testbench (`riscvsingle_tb.sv`) that verifies instruction execution, register updates, and branching logic.

**Prerequisites:** [Icarus Verilog](http://iverilog.icarus.com/) (`iverilog`).

To run the testbench and see the output trace:

```bash
# Compile the design and the testbench
iverilog -g2012 -o tb.vvp rtl/*.sv tb/riscvsingle_tb.sv

# Run the simulation
vvp tb.vvp
```

You can view the resulting `wave.vcd` file in GTKWave to analyze all inner signals cycle-by-cycle!

---

_🎓 Designed for hardware architecture studies and FPGA exploration._
