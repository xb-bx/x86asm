#+feature using-stmt
package x86asm
import "core:fmt"
or_r8_rm8 := Opcode { bytes = [4]u8 {0x0a, 0,0,0,}, size = 1 }
or_r16_rm16 := Opcode { bytes = [4]u8{0x0b, 0,0,0,}, size = 1 }
or_rm8_r8 := Opcode { bytes = [4]u8{0x08, 0,0,0,}, size = 1 }
or_rm8_imm := Opcode { bytes = [4]u8{0x80, 0,0,0,}, size = 1, modrm_ext = 1, }
or_rm64_imm := Opcode { bytes = [4]u8{0x81, 0,0,0,}, size = 1, modrm_ext = 1, }
or_rm16_r16 := Opcode { bytes = [4]u8{0x09, 0,0,0,}, size = 1,  }
or_reg64_reg64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("or %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, or_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
or_reg32_reg32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("or %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, or_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
or_reg16_reg16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("or %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, 0x66, or_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
or_reg8_reg8 :: proc(using assembler: ^Assembler, dest: Reg8, src: Reg8) {
    idest := u8(dest)
    isrc := u8(src)
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    assert(!(rex != {} && (isrc > 15 || idest > 15)))
    if remember { append(&mnemonics, fmt.aprintf("or %s, %s", dest, src)) }
    if idest > 15 { idest -= 12 }
    generic_reg_or_imm_to_reg(assembler, rex, nil, or_r8_rm8, REGISTER_DIRECT, int(idest), int(src), 0, 0, OperandEncoding.RM) 
}
or_reg8_memory :: proc(using assembler: ^Assembler, dest: Reg8, src: Memory) {
    idest := u8(dest)
    assert(!(u8(src.base.(Reg64)) > 7 && u8(dest) > 15))
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("or %s, byte %v", dest, src)) }
    if idest > 15 { idest -= 12 }
    generic_from_memory_to_reg(assembler, rex, false, or_r8_rm8, .RM, int(idest), src)
}
or_reg32_memory :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("or %s, dword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, or_r16_rm16, .RM, int(dest), src)
}
or_reg16_memory :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("or %s, word %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, or_r16_rm16, .RM, int(dest), src)
}
or_reg64_memory :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("or %s, qword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, or_r16_rm16, .RM, int(dest), src)

}
or_memory_reg8 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest.base.(Reg64)) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if remember { append(&mnemonics, fmt.aprintf("or byte %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, rex, false, or_rm8_r8, .MR, dest, int(isrc))
}
or_memory_reg16 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("or word %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, true, or_rm16_r16, .MR, dest, int(src))
}
or_memory_reg32 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("or dword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, false, or_rm16_r16, .MR, dest, int(src))
}
or_memory_reg64 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("or qword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {.W}, false, or_rm16_r16, .MR, dest, int(src))
}

or_reg_imm8 :: proc(using assembler: ^Assembler, dest: Reg8, src: u8) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("or %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("or %v, %i", dest, src)) }
    }
    idest := u8(dest)
    rex := RexPrefix {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if idest > 15 { idest -= 12 }
    generic_reg_or_imm_to_reg(assembler, {.Rex}, nil, or_rm8_imm, 0b1100_0000, int(idest), 0, int(src), 1, OperandEncoding.MI)
}
or_reg_imm16 :: proc(using assembler: ^Assembler, dest: Reg16, src: i16) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("or %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("or %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, or_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 2, OperandEncoding.MI)
}
or_reg_imm :: proc(using assembler: ^Assembler, dest: Reg32, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("or %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("or %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, nil, or_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
     
}
orsx_reg_imm :: proc(using assembler: ^Assembler, dest: Reg64, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("or %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("or %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, or_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
}
or_memory_imm8 :: proc(using assembler: ^Assembler, dest: Memory, src: u8) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("or byte %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("or byte %v, %i", dest, src)) }
    }
    generic_from_imm_to_memory(assembler, {}, true, or_rm8_imm, dest, int(src), 1)
}
or_memory_imm16 :: proc(using assembler: ^Assembler, dest: Memory, src: i16) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("or word %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("or word %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, true, or_rm64_imm, dest, int(src), 2)
}
or_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("or dword %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("or dword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, false, or_rm64_imm, dest, int(src), 4)
}
orsx_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("or qword %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("or qword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {.W}, false, or_rm64_imm, dest, int(src), 4)
}
or :: proc { 
    or_reg64_memory, or_reg32_memory, or_reg16_memory, or_reg8_memory, 
    or_reg64_reg64, or_reg32_reg32, or_reg16_reg16, or_reg8_reg8, 
    or_memory_reg64, or_memory_reg32, or_memory_reg16, or_memory_reg8,
    or_memory_imm, or_memory_imm16, or_memory_imm8,
    or_reg_imm8, or_reg_imm16, or_reg_imm,
}
orsx :: proc {orsx_memory_imm, orsx_reg_imm}
