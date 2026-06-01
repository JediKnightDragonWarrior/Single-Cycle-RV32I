# Directories
RTL_DIR = rtl
TB_DIR  = tb
INC_DIR = $(RTL_DIR)
ASM_SRC = test/RV_Assembly_Code.s
HEX_FILE = test/program.hex
LOG 	 = test/sim_results.txt

# Toolchain detection
ifneq ($(shell which riscv64-elf-as 2>/dev/null),)
    PREFIX = riscv64-elf-
else
    PREFIX = riscv64-unknown-elf-
endif

AS      = $(PREFIX)as
OBJCOPY = $(PREFIX)objcopy

# Variables
RTL  = $(wildcard $(RTL_DIR)/*.sv)
TB   = $(TB_DIR)/overall_simulation.sv

# Output files
OUT  = test/simv
WAVE = test/wave.vcd

# Compiler flags
FLAGS = -g2012 -I $(INC_DIR)

# --- TARGETS ---

# 1. Normal Testbench Mode
# Runs simulation. Depends on the compiled output.
run: $(OUT)
	vvp $(OUT)

# 2. Assembly/Hex Mode
# Explicitly ensures hex file is ready before running.
assemble: $(HEX_FILE) run

# Compile Rule
# The simulation executable depends on all RTL and the TB
$(OUT): $(RTL) $(TB)
	iverilog $(FLAGS) -o $(OUT) $(RTL) $(TB)

# Hexfile Rule
# If hex doesn't exist or .s is newer, it triggers the RISC-V toolchain
$(HEX_FILE): $(ASM_SRC)
	$(AS) -march=rv32i -mabi=ilp32 -o tmp.o $(ASM_SRC)
	$(OBJCOPY) -O binary --only-section=.text tmp.o tmp.bin
	hexdump -v -e '1/4 "%08x" "\n"' tmp.bin > $(HEX_FILE)
	rm tmp.o tmp.bin

# 3. Waveform Generation
# This will run the simulation (to generate the .vcd) and then open GTKWave
wave: run
	gtkwave $(WAVE)

# Clean up
clean:
	rm -f $(OUT) $(HEX_FILE) $(WAVE) $(LOG) tmp.o tmp.bin