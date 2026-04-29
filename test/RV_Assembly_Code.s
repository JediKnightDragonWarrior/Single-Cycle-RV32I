    .section .text
    .globl main

# RISC-V Test Program 2
# Goal:
#   - Exercise branches, shifts, load/store, jal
#   - If successful, write 42 to address 124

main:
    addi x1, x0, 7          # x1 = 7
    addi x2, x0, 6          # x2 = 6

    add  x3, x1, x2         # x3 = 13
    slli x4, x2, 2          # x4 = 24
    add  x5, x3, x4         # x5 = 37

    slti x6, x5, 40         # x6 = 1 (37 < 40)
    beq  x6, x0, fail       # should not branch

    add x5, x5, 5          # x5 = 42

    sw   x5, 124(x0)        # memory[124] = 42
    lw   x7, 124(x0)        # x7 = 42

    bne  x7, x5, fail       # verify load/store

    jal  x8, pass_label     # jump and save return addr
    jal  x0, fail           # should never execute

pass_label:
    addi x9, x0, 1          # success flag
    jal  x0, done

fail:
    addi x9, x0, 0          # failure flag

done:
    beq  x0, x0, done       # infinite loop