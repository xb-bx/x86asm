package x86asm
import "core:fmt"
cmp_r8_rm8 := Opcode { bytes = [4]u8 {0x3a, 0,0,0,}, size = 1 }
cmp_rm8_r8 := Opcode { bytes = [4]u8{0x38, 0,0,0,}, size = 1 }
cmp_rm8_imm := Opcode { bytes = [4]u8{0x80, 0,0,0,}, size = 1, modrm_ext = 7}
cmp_rm64_imm := Opcode { bytes = [4]u8{0x81, 0,0,0,}, size = 1, modrm_ext = 7 }
cmp_r16_rm16 := Opcode { bytes = [4]u8{0x3b, 0,0,0,}, size = 1 }
cmp_rm16_r16 := Opcode { bytes = [4]u8{0x39, 0,0,0,}, size = 1 }
cmp_reg64_reg64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmp %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmp_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
cmp_reg32_reg32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmp %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmp_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
cmp_reg16_reg16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmp %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, 0x66, cmp_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
cmp_reg8_reg8 :: proc(using assembler: ^Assembler, dest: Reg8, src: Reg8) {
    idest := u8(dest)
    isrc := u8(src)
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    assert(!(rex != {} && (isrc > 15 || idest > 15)))
    if remember { append(&mnemonics, fmt.aprintf("cmp %s, %s", dest, src)) }
    if idest > 15 { idest -= 12 }
    generic_reg_or_imm_to_reg(assembler, rex, nil, cmp_r8_rm8, REGISTER_DIRECT, int(idest), int(src), 0, 0, OperandEncoding.RM) 
}
cmp_reg8_memory :: proc(using assembler: ^Assembler, dest: Reg8, src: Memory) {
    idest := u8(dest)
    assert(!(u8(src.base.(Reg64)) > 7 && u8(dest) > 15))
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("cmp %s, byte %v", dest, src)) }
    if idest > 15 { idest -= 12 }
    generic_from_memory_to_reg(assembler, rex, false, cmp_r8_rm8, .RM, int(idest), src)
}
cmp_reg32_memory :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmp %s, dword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, cmp_r16_rm16, .RM, int(dest), src)
}
cmp_reg16_memory :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmp %s, word %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, cmp_r16_rm16, .RM, int(dest), src)
}
cmp_reg64_memory :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cmp %s, qword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, cmp_r16_rm16, .RM, int(dest), src)

}
cmp_memory_reg8 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest.base.(Reg64)) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if remember { append(&mnemonics, fmt.aprintf("cmp byte %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, rex, false, cmp_rm8_r8, .MR, dest, int(isrc))
}
cmp_memory_reg16 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("cmp word %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, true, cmp_rm16_r16, .MR, dest, int(src))
}
cmp_memory_reg32 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cmp dword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, false, cmp_rm16_r16, .MR, dest, int(src))
}
cmp_memory_reg64 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cmp qword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {.W}, false, cmp_rm16_r16, .MR, dest, int(src))
}
cmp_memory_imm8 :: proc(using assembler: ^Assembler, dest: Memory, src: u8) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("cmp byte %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("cmp byte %v, %i", dest, src)) }
    }
    generic_from_imm_to_memory(assembler, {}, true, cmp_rm8_imm, dest, int(src), 1)
}
cmp_memory_imm16 :: proc(using assembler: ^Assembler, dest: Memory, src: i16) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("cmp word %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("cmp word %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, true, cmp_rm64_imm, dest, int(src), 2)
}
cmp_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("cmp dword %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("cmp dword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, false, cmp_rm64_imm, dest, int(src), 4)
}
cmpsx_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("cmp qword %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("cmp qword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {.W}, false, cmp_rm64_imm, dest, int(src), 4)
}
cmp_reg_imm8 :: proc(using assembler: ^Assembler, dest: Reg8, src: u8) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("cmp %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("cmp %v, %i", dest, src)) }
    }
    idest := u8(dest)
    rex := RexPrefix {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if idest > 15 { idest -= 12 }
    generic_reg_or_imm_to_reg(assembler, {.Rex}, nil, cmp_rm8_imm, 0b1100_0000, int(idest), 0, int(src), 1, OperandEncoding.MI)
}
cmp_reg_imm16 :: proc(using assembler: ^Assembler, dest: Reg16, src: i16) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("cmp %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("cmp %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, cmp_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 2, OperandEncoding.MI)
}
cmp_reg_imm :: proc(using assembler: ^Assembler, dest: Reg32, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("cmp %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("cmp %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, nil, cmp_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
     
}
cmpsx_reg_imm :: proc(using assembler: ^Assembler, dest: Reg64, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("cmp %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("cmp %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cmp_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
}
cmp :: proc { 
    cmp_reg64_memory, cmp_reg32_memory, cmp_reg16_memory, cmp_reg8_memory, 
    cmp_reg64_reg64, cmp_reg32_reg32, cmp_reg16_reg16, cmp_reg8_reg8, 
    cmp_memory_reg64, cmp_memory_reg32, cmp_memory_reg16, cmp_memory_reg8,
    cmp_memory_imm, cmp_memory_imm16, cmp_memory_imm8,
    cmp_reg_imm, cmp_reg_imm16, cmp_reg_imm8,
}
cmpsx :: proc {cmpsx_memory_imm, cmpsx_reg_imm}
