package x86asm
import "core:fmt"
and_r8_rm8 := Opcode { bytes = [4]u8 {0x22, 0,0,0,}, size = 1 }
and_r16_rm16 := Opcode { bytes = [4]u8{0x23, 0,0,0,}, size = 1 }
and_rm8_r8 := Opcode { bytes = [4]u8{0x20, 0,0,0,}, size = 1 }
and_rm8_imm := Opcode { bytes = [4]u8{0x80, 0,0,0,}, size = 1, modrm_ext = 4, }
and_rm64_imm := Opcode { bytes = [4]u8{0x81, 0,0,0,}, size = 1, modrm_ext = 4, }
and_rm16_r16 := Opcode { bytes = [4]u8{0x21, 0,0,0,}, size = 1,  }
and_reg64_reg64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, and_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
and_reg32_reg32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, and_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
and_reg16_reg16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, 0x66, and_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
and_reg8_reg8 :: proc(using assembler: ^Assembler, dest: Reg8, src: Reg8) {
    idest := u8(dest)
    isrc := u8(src)
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    assert(!(rex != {} && (isrc > 15 || idest > 15)))
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %s, %s", dest, src)) }
    if idest > 15 { idest -= 12 }
    generic_reg_or_imm_to_reg(assembler, rex, nil, and_r8_rm8, REGISTER_DIRECT, int(idest), int(src), 0, 0, OperandEncoding.RM) 
}
and_reg8_memory :: proc(using assembler: ^Assembler, dest: Reg8, src: Memory) {
    idest := u8(dest)
    assert(!(u8(src.base.(Reg64)) > 7 && u8(dest) > 15))
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %s, byte %v", dest, src)) }
    if idest > 15 { idest -= 12 }
    generic_from_memory_to_reg(assembler, rex, false, and_r8_rm8, .RM, int(idest), src)
}
and_reg32_memory :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %s, dword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, and_r16_rm16, .RM, int(dest), src)
}
and_reg16_memory :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %s, word %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, and_r16_rm16, .RM, int(dest), src)
}
and_reg64_memory :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %s, qword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, and_r16_rm16, .RM, int(dest), src)

}
and_memory_reg8 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest.base.(Reg64)) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and byte %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, rex, false, and_rm8_r8, .MR, dest, int(isrc))
}
and_memory_reg16 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg16) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and word %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, true, and_rm16_r16, .MR, dest, int(src))
}
and_memory_reg32 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg32) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and dword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, false, and_rm16_r16, .MR, dest, int(src))
}
and_memory_reg64 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg64) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("and qword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {.W}, false, and_rm16_r16, .MR, dest, int(src))
}

and_reg_imm8 :: proc(using assembler: ^Assembler, dest: Reg8, src: u8) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %v, %i", dest, src)) }
    }
    idest := u8(dest)
    rex := RexPrefix {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if idest > 15 { idest -= 12 }
    generic_reg_or_imm_to_reg(assembler, {.Rex}, nil, and_rm8_imm, 0b1100_0000, int(idest), 0, int(src), 1, OperandEncoding.MI)
}
and_reg_imm16 :: proc(using assembler: ^Assembler, dest: Reg16, src: i16) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, and_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 2, OperandEncoding.MI)
}
and_reg_imm :: proc(using assembler: ^Assembler, dest: Reg32, src: i32) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, nil, and_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
     
}
andsx_reg_imm :: proc(using assembler: ^Assembler, dest: Reg64, src: i32) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, and_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
}
and_memory_imm8 :: proc(using assembler: ^Assembler, dest: Memory, src: u8) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and byte %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and byte %v, %i", dest, src)) }
    }
    generic_from_imm_to_memory(assembler, {}, true, and_rm8_imm, dest, int(src), 1)
}
and_memory_imm16 :: proc(using assembler: ^Assembler, dest: Memory, src: i16) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and word %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and word %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, true, and_rm64_imm, dest, int(src), 2)
}
and_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and dword %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and dword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, false, and_rm64_imm, dest, int(src), 4)
}
andsx_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and qword %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("and qword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {.W}, false, and_rm64_imm, dest, int(src), 4)
}
and :: proc { 
    and_reg64_memory, and_reg32_memory, or_reg16_memory, or_reg8_memory, 
    and_reg64_reg64, and_reg32_reg32, or_reg16_reg16, or_reg8_reg8, 
    and_memory_reg64, and_memory_reg32, or_memory_reg16, or_memory_reg8,
    and_memory_imm, and_memory_imm16, or_memory_imm8,
    and_reg_imm8, and_reg_imm16, or_reg_imm,
}
andsx :: proc {andsx_memory_imm, andsx_reg_imm}
