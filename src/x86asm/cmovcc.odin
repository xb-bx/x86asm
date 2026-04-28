#+feature using-stmt
package x86asm
import "core:fmt"
cmove_r32_rm32 := Opcode { bytes = [4]u8{0x0f, 0x44,0,0,}, size = 2 }
cmovge_r32_rm32 := Opcode { bytes = [4]u8{0x0f, 0x4d,0,0,}, size = 2 }
cmovg_r32_rm32 := Opcode { bytes = [4]u8{0x0f, 0x4f,0,0,}, size = 2 }
cmovle_r32_rm32 := Opcode { bytes = [4]u8{0x0f, 0x4e,0,0,}, size = 2 }
cmovl_r32_rm32 := Opcode { bytes = [4]u8{0x0f, 0x4c,0,0,}, size = 2 }
cmovne_r32_rm32 := Opcode { bytes = [4]u8{0x0f, 0x45,0,0,}, size = 2 }
cmova_r32_rm32 := Opcode { bytes = [4]u8{0x0f, 0x47,0,0,}, size = 2 }
cmovae_r32_rm32 := Opcode { bytes = [4]u8{0x0f, 0x43,0,0,}, size = 2 }
cmovb_r32_rm32 := Opcode { bytes = [4]u8{0x0f, 0x42,0,0,}, size = 2 }
cmovbe_r32_rm32 := Opcode { bytes = [4]u8{0x0f, 0x46,0,0,}, size = 2 }

cmove :: proc { cmove_r64_r64, cmove_r32_r32, cmove_r16_r16 }
cmove_r16_r16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmove %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmove_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}
cmove_r32_r32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmove %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmove_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmove_r64_r64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmove %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmove_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmove_m32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmove %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmove_r32_rm32, .RM, int(dest), src)

}
cmove_m64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmove %s, qword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmove_r32_rm32, .RM, int(dest), src)

}
cmove_m16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmove %s, word %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmove_r32_rm32, .RM, int(dest), src)

}

cmovge :: proc { cmovge_r64_r64, cmovge_r32_r32, cmovge_r16_r16 }
cmovge_r16_r16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmovge %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmovge_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}
cmovge_r32_r32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmovge %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmovge_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovge_r64_r64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmovge %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmovge_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovge_m32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovge %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmovge_r32_rm32, .RM, int(dest), src)

}
cmovge_m64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovge %s, qword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmovge_r32_rm32, .RM, int(dest), src)

}
cmovge_m16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovge %s, word %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmovge_r32_rm32, .RM, int(dest), src)

}




cmovg :: proc { cmovg_r64_r64, cmovg_r32_r32, cmovg_r16_r16 }
cmovg_r16_r16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmovg %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmovg_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}
cmovg_r32_r32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmovg %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmovg_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovg_r64_r64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmovg %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmovg_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovg_m32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovg %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmovg_r32_rm32, .RM, int(dest), src)

}
cmovg_m64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovg %s, qword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmovg_r32_rm32, .RM, int(dest), src)

}
cmovg_m16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovg %s, word %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmovg_r32_rm32, .RM, int(dest), src)

}

cmovle :: proc { cmovle_r64_r64, cmovle_r32_r32, cmovle_r16_r16 }
cmovle_r16_r16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmovle %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmovle_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}
cmovle_r32_r32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmovle %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmovle_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovle_r64_r64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmovle %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmovle_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovle_m32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovle %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmovle_r32_rm32, .RM, int(dest), src)

}
cmovle_m64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovle %s, qword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmovle_r32_rm32, .RM, int(dest), src)

}
cmovle_m16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovle %s, word %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmovle_r32_rm32, .RM, int(dest), src)

}

cmovl :: proc { cmovl_r64_r64, cmovl_r32_r32, cmovl_r16_r16 }
cmovl_r16_r16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmovl %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmovl_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}
cmovl_r32_r32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmovl %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmovl_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovl_r64_r64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmovl %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmovl_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovl_m32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovl %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmovl_r32_rm32, .RM, int(dest), src)

}
cmovl_m64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovl %s, qword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmovl_r32_rm32, .RM, int(dest), src)

}
cmovl_m16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovl %s, word %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmovl_r32_rm32, .RM, int(dest), src)

}
cmovne :: proc { cmovne_r64_r64, cmovne_r32_r32, cmovne_r16_r16 }
cmovne_r16_r16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmovne %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmovne_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}
cmovne_r32_r32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmovne %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmovne_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovne_r64_r64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmovne %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmovne_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovne_m32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovne %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmovne_r32_rm32, .RM, int(dest), src)

}
cmovne_m64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovne %s, qword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmovne_r32_rm32, .RM, int(dest), src)

}
cmovne_m16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovne %s, word %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmovne_r32_rm32, .RM, int(dest), src)

}

cmova :: proc { cmova_r64_r64, cmova_r32_r32, cmova_r16_r16 }
cmova_r16_r16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmova %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmova_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}
cmova_r32_r32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmova %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmova_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmova_r64_r64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmova %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmova_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmova_m32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmova %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmova_r32_rm32, .RM, int(dest), src)

}
cmova_m64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmova %s, qword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmova_r32_rm32, .RM, int(dest), src)

}
cmova_m16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmova %s, word %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmova_r32_rm32, .RM, int(dest), src)

}

cmovae :: proc { cmovae_r64_r64, cmovae_r32_r32, cmovae_r16_r16 }
cmovae_r16_r16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmovae %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmovae_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}
cmovae_r32_r32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmovae %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmovae_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovae_r64_r64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmovae %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmovae_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovae_m32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovae %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmovae_r32_rm32, .RM, int(dest), src)

}
cmovae_m64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovae %s, qword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmovae_r32_rm32, .RM, int(dest), src)

}
cmovae_m16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovae %s, word %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmovae_r32_rm32, .RM, int(dest), src)

}

cmovb :: proc { cmovb_r64_r64, cmovb_r32_r32, cmovb_r16_r16 }
cmovb_r16_r16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmovb %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmovb_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}
cmovb_r32_r32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmovb %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmovb_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovb_r64_r64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmovb %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmovb_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovb_m32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovb %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmovb_r32_rm32, .RM, int(dest), src)

}
cmovb_m64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovb %s, qword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmovb_r32_rm32, .RM, int(dest), src)

}
cmovb_m16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovb %s, word %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmovb_r32_rm32, .RM, int(dest), src)

}

cmovbe :: proc { cmovbe_r64_r64, cmovbe_r32_r32, cmovbe_r16_r16 }
cmovbe_r16_r16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmovbe %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmovbe_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}
cmovbe_r32_r32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmovbe %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmovbe_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovbe_r64_r64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmovbe %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmovbe_r32_rm32, 0b1100_0000, int(dest), int(src), 0, 0, .RM)

}

cmovbe_m32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovbe %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmovbe_r32_rm32, .RM, int(dest), src)

}
cmovbe_m64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovbe %s, qword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmovbe_r32_rm32, .RM, int(dest), src)

}
cmovbe_m16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmovbe %s, word %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmovbe_r32_rm32, .RM, int(dest), src)

}
