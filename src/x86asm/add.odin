package x86asm
import "core:fmt"
add_r8_rm8 := Opcode { bytes = [4]u8 {0x2, 0,0,0,}, size = 1 }
add_r16_rm16 := Opcode { bytes = [4]u8{0x03, 0,0,0,}, size = 1 }
add_rm8_r8 := Opcode { bytes = [4]u8{0, 0,0,0,}, size = 1 }
add_rm8_imm := Opcode { bytes = [4]u8{0x80, 0,0,0,}, size = 1 }
add_rm64_imm := Opcode { bytes = [4]u8{0x81, 0,0,0,}, size = 1 }
add_rm16_r16 := Opcode { bytes = [4]u8{0x01, 0,0,0,}, size = 1 }
add_reg64_reg64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("add %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, add_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
add_reg32_reg32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("add %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, add_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
add_reg16_reg16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("add %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, 0x66, add_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
add_reg8_reg8 :: proc(using assembler: ^Assembler, dest: Reg8, src: Reg8) {
    idest := u8(dest)
    isrc := u8(src)
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    assert(!(rex != {} && (isrc > 15 || idest > 15)))
    if remember { append(&mnemonics, fmt.aprintf("add %s, %s", dest, src)) }
    if idest > 15 { idest -= 12 }
    if isrc > 15 { isrc -= 12 }
    generic_reg_or_imm_to_reg(assembler, rex, nil, add_r8_rm8, REGISTER_DIRECT, int(idest), int(isrc), 0, 0, OperandEncoding.RM) 
}
add_reg8_memory :: proc(using assembler: ^Assembler, dest: Reg8, src: Memory) {
    idest := u8(dest)
    assert(!(u8(src.base.(Reg64)) > 7 && u8(dest) > 15))
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("add %s, byte %v", dest, src)) }
    if idest > 15 { idest -= 12 }
    generic_from_memory_to_reg(assembler, rex, false, add_r8_rm8, .RM, int(idest), src)
}
add_reg32_memory :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("add %s, dword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, add_r16_rm16, .RM, int(dest), src)
}
add_reg16_memory :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("add %s, word %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, add_r16_rm16, .RM, int(dest), src)
}
add_reg64_memory :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("add %s, qword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, add_r16_rm16, .RM, int(dest), src)

}
add_memory_reg8 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest.base.(Reg64)) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if remember { append(&mnemonics, fmt.aprintf("add byte %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, rex, false, add_rm8_r8, .MR, dest, int(isrc))
}
add_memory_reg16 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("add word %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, true, add_rm16_r16, .MR, dest, int(src))
}
add_memory_reg32 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("add dword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, false, add_rm16_r16, .MR, dest, int(src))
}
add_memory_reg64 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("add qword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {.W}, false, add_rm16_r16, .MR, dest, int(src))
}

add_reg_imm8 :: proc(using assembler: ^Assembler, dest: Reg8, src: u8) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("add %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("add %v, %i", dest, src)) }
    }
    idest := u8(dest)
    rex := RexPrefix {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if idest > 15 { idest -= 12 }
    generic_reg_or_imm_to_reg(assembler, {.Rex}, nil, add_rm8_imm, 0b1100_0000, int(idest), 0, int(src), 1, OperandEncoding.MI)
}
add_reg_imm16 :: proc(using assembler: ^Assembler, dest: Reg16, src: i16) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("add %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("add %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, add_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 2, OperandEncoding.MI)
}
add_reg_imm :: proc(using assembler: ^Assembler, dest: Reg32, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("add %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("add %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, nil, add_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
     
}
addsx_reg_imm :: proc(using assembler: ^Assembler, dest: Reg64, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("add %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("add %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, add_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
}
add_memory_imm8 :: proc(using assembler: ^Assembler, dest: Memory, src: u8) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("add byte %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("add byte %v, %i", dest, src)) }
    }
    generic_from_imm_to_memory(assembler, {}, true, add_rm8_imm, dest, int(src), 1)
}
add_memory_imm16 :: proc(using assembler: ^Assembler, dest: Memory, src: i16) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("add word %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("add word %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, true, add_rm64_imm, dest, int(src), 2)
}
add_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("add dword %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("add dword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, false, add_rm64_imm, dest, int(src), 4)
}
addsx_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("add qword %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("add qword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {.W}, false, add_rm64_imm, dest, int(src), 4)
}
add :: proc { 
    add_reg64_memory, add_reg32_memory, add_reg16_memory, add_reg8_memory, 
    add_reg64_reg64, add_reg32_reg32, add_reg16_reg16, add_reg8_reg8, 
    add_memory_reg64, add_memory_reg32, add_memory_reg16, add_memory_reg8,
    add_memory_imm, add_memory_imm16, add_memory_imm8,
    add_reg_imm8, add_reg_imm16, add_reg_imm,
}
addsx :: proc {addsx_memory_imm, addsx_reg_imm}
