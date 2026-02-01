#+feature using-stmt
package x86asm
import "core:fmt"
sub_r8_rm8 := Opcode { bytes = [4]u8 {0x2a, 0,0,0,}, size = 1 }
sub_rm8_r8 := Opcode { bytes = [4]u8{0x28, 0,0,0,}, size = 1 }
sub_rm8_imm := Opcode { bytes = [4]u8{0x80, 0,0,0,}, size = 1, modrm_ext = 5}
sub_rm64_imm := Opcode { bytes = [4]u8{0x81, 0,0,0,}, size = 1, modrm_ext = 5 }
sub_r16_rm16 := Opcode { bytes = [4]u8{0x2b, 0,0,0,}, size = 1 }
sub_rm16_r16 := Opcode { bytes = [4]u8{0x29, 0,0,0,}, size = 1 }
sub_reg64_reg64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("sub %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, sub_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
sub_reg32_reg32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("sub %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, sub_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
sub_reg16_reg16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("sub %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, 0x66, sub_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
sub_reg8_reg8 :: proc(using assembler: ^Assembler, dest: Reg8, src: Reg8) {
    idest := u8(dest)
    isrc := u8(src)
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    assert(!(rex != {} && (isrc > 15 || idest > 15)))
    if remember { append(&mnemonics, fmt.aprintf("sub %s, %s", dest, src)) }
    if idest > 15 { idest -= 12 }
    if isrc > 15 { isrc -= 12 }
    generic_reg_or_imm_to_reg(assembler, rex, nil, sub_r8_rm8, REGISTER_DIRECT, int(idest), int(isrc), 0, 0, OperandEncoding.RM) 
}
sub_reg8_memory :: proc(using assembler: ^Assembler, dest: Reg8, src: Memory) {
    idest := u8(dest)
    assert(!(u8(src.base.(Reg64)) > 7 && u8(dest) > 15))
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("sub %s, byte %v", dest, src)) }
    if idest > 15 { idest -= 12 }
    generic_from_memory_to_reg(assembler, rex, false, sub_r8_rm8, .RM, int(idest), src)
}
sub_reg32_memory :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("sub %s, dword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, sub_r16_rm16, .RM, int(dest), src)
}
sub_reg16_memory :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("sub %s, word %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, sub_r16_rm16, .RM, int(dest), src)
}
sub_reg64_memory :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("sub %s, qword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, sub_r16_rm16, .RM, int(dest), src)

}
sub_memory_reg8 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest.base.(Reg64)) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if remember { append(&mnemonics, fmt.aprintf("sub byte %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, rex, false, sub_rm8_r8, .MR, dest, int(isrc))
}
sub_memory_reg16 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("sub word %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, true, sub_rm16_r16, .MR, dest, int(src))
}
sub_memory_reg32 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("sub dword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, false, sub_rm16_r16, .MR, dest, int(src))
}
sub_memory_reg64 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("sub qword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {.W}, false, sub_rm16_r16, .MR, dest, int(src))
}
sub_memory_imm8 :: proc(using assembler: ^Assembler, dest: Memory, src: u8) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("sub byte %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("sub byte %v, %i", dest, src)) }
    }
    generic_from_imm_to_memory(assembler, {}, true, sub_rm8_imm, dest, int(src), 1)
}
sub_memory_imm16 :: proc(using assembler: ^Assembler, dest: Memory, src: i16) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("sub word %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("sub word %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, true, sub_rm64_imm, dest, int(src), 2)
}
sub_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("sub dword %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("sub dword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, false, sub_rm64_imm, dest, int(src), 4)
}
subsx_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("sub qword %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("sub qword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {.W}, false, sub_rm64_imm, dest, int(src), 4)
}

sub_reg_imm8 :: proc(using assembler: ^Assembler, dest: Reg8, src: u8) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("sub %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("sub %v, %i", dest, src)) }
    }
    idest := u8(dest)
    rex := RexPrefix {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if idest > 15 { idest -= 12 }
    generic_reg_or_imm_to_reg(assembler, {.Rex}, nil, sub_rm8_imm, 0b1100_0000, int(idest), 0, int(src), 1, OperandEncoding.MI)
}
sub_reg_imm16 :: proc(using assembler: ^Assembler, dest: Reg16, src: i16) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("sub %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("sub %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, sub_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 2, OperandEncoding.MI)
}
sub_reg_imm :: proc(using assembler: ^Assembler, dest: Reg32, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("sub %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("sub %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, nil, sub_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
     
}
subsx_reg_imm :: proc(using assembler: ^Assembler, dest: Reg64, src: i32) {
    if src >= 10 {
        if remember { append(&mnemonics, fmt.aprintf("sub %v, 0x%x", dest, src)) }
    }
    else {
        if remember { append(&mnemonics, fmt.aprintf("sub %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, sub_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
}



sub :: proc { 
    sub_reg64_memory, sub_reg32_memory, sub_reg16_memory, sub_reg8_memory, 
    sub_reg64_reg64, sub_reg32_reg32, sub_reg16_reg16, sub_reg8_reg8, 
    sub_memory_reg64, sub_memory_reg32, sub_memory_reg16, sub_memory_reg8,
    sub_memory_imm, sub_memory_imm16, sub_memory_imm8,
    sub_reg_imm8, sub_reg_imm16, sub_reg_imm,
}
subsx :: proc {subsx_memory_imm, subsx_reg_imm}
