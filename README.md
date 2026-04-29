# Single-Cycle RISC-V Processor (RV32I) 🚀

This repository contains a simple, educational **Single-Cycle RISC-V (RV32I)** processor implemented in SystemVerilog. The architecture is primarily based on the design presented in the _Digital Design and Computer Architecture: RISC-V Edition_ by Harris & Harris, but features several custom optimizations and architectural refinements for better synthesis efficiency and future extensibility.

## 🌟 Key Features & Optimizations

- **RV32I Base Instruction Set Support For Main Instructions:** Capable of executing core R-Type, I-Type, S-Type, B-Type, and J-Type instructions.

## 📜 Supported Instructions

| Type       | Instructions Supported In Core                                      |
| ---------- | ------------------------------------------------------------------- |
| **R-Type** | `add`, `sub`, `xor`, `or`, `and`, `sll`, `srl`, `sra`, `slt`, `sltu` |
| **I-Type** | `addi`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai`, `slti`, `sltiu`, `lb`, `lh`, `lw`, `lbu`, `lhu` |
| **S-Type** | `sb`, `sh`, `sw`                                                    |
| **B-Type** | `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`                          |
| **J-Type** | `jal`                                                               |
| **U-Type** | `lui`, `auipc`                                                      |

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

## 📂 Directory Structure

```text
project_root
├── rtl/                    # SystemVerilog source files
│   ├── *.sv
│
├── tb/                     # SystemVerilog testbench files
│   ├── overall_simulation.sv
│
├── test/                   
│   ├── RV_Assembly_Code.s  # Assembly test program
│   ├── program.hex         # assembled rv machine code (generated)
│   └── sim_results.txt     # overall_simulation results (generated)
│
├── Makefile                # Build / simulation automation
│
├── simv                    # Compiled simulation executable (generated)
├── wave.vcd                # Waveform dump file (generated)
└── simulation_log.txt      # Simulation output log (generated)
```

## Build & Run

This project includes a `Makefile` to automate assembling the RISC-V program, compiling the SystemVerilog design, running the simulation, and viewing waveforms.

### Requirements

Install the following tools before compiling:

- **make** – build automation tool  
- **Icarus Verilog** (`iverilog`, `vvp`) – compile and run simulation  
- **GTKWave** (`gtkwave`) – waveform viewer  
- **RISC-V GNU Toolchain**  
  - `riscv64-unknown-elf-as` – assembler  
  - `riscv64-unknown-elf-objcopy` – binary conversion tool  
- **hexdump** – generate `.hex` memory file  


### Make Targets

| Command | Function |
|--------|----------|
| `make` | Assemble, compile, and run simulation |
| `make compile` | Assemble code and compile RTL + testbench |
| `make assemble` | Generate `program.hex` from assembly source |
| `make run` | Run simulation |
| `make wave` | Run simulation and open GTKWave |
| `make clean` | Remove generated files |

_🎓 Designed for hardware architecture studies and FPGA exploration._
