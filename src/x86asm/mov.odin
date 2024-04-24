package x86asm
import "core:fmt"

mov_r16_rm16 :: Opcode { bytes = [4]u8 { 0x8b, 0, 0,0}, size = 1} 
mov_r64_imm :: Opcode { bytes = [4]u8 { 0xb8, 0, 0,0}, size = 1} 
mov_rm16_r16 :: Opcode { bytes = [4]u8 { 0x89, 0, 0,0}, size = 1} 
mov_r8_rm8 :: Opcode { bytes = [4]u8 { 0x8A, 0, 0,0}, size = 1} 
mov_rm8_r8 :: Opcode { bytes = [4]u8 { 0x88, 0, 0,0}, size = 1} 
mov_rm64_imm :: Opcode { bytes = [4]u8 { 0xc7, 0, 0,0}, size = 1} 
mov_rm8_imm :: Opcode { bytes = [4]u8 { 0xc6, 0, 0,0}, size = 1} 
lea_r64_m ::  Opcode { bytes = [4]u8 { 0x8D, 0, 0,0}, size = 1} 
movsx_r16_rm8 :: Opcode { bytes = [4]u8 {0x0f, 0xbe, 0,0,}, size = 2}
movsx_r32_rm16 :: Opcode { bytes = [4]u8 {0x0f, 0xbf,0,0,}, size = 2}
movsx_r64_rm32 :: Opcode { bytes = [4]u8 {0x63, 0,0,0,}, size = 1}
movzx_r16_rm8 :: Opcode { bytes = [4]u8 {0x0f, 0xb6, 0,0,}, size = 2}
movzx_r32_rm16 :: Opcode { bytes = [4]u8 {0x0f, 0xb7,0,0,}, size = 2}

mov_reg64_reg64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, mov_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
mov_reg32_reg32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, mov_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
mov_reg16_reg16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, 0x66, mov_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
mov_reg8_reg8 :: proc(using assembler: ^Assembler, dest: Reg8, src: Reg8) {
    idest := u8(dest)
    isrc := u8(src)
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    assert(!(rex != {} && (isrc > 15 || idest > 15)))
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %s, %s", dest, src)) }
    if idest > 15 { idest -= 12 }
    generic_reg_or_imm_to_reg(assembler, rex, nil, mov_r8_rm8, REGISTER_DIRECT, int(idest), int(src), 0, 0, OperandEncoding.RM) 
}
mov_reg8_memory :: proc(using assembler: ^Assembler, dest: Reg8, src: Memory) {
    idest := u8(dest)
    assert(!(u8(src.base.(Reg64)) > 7 && u8(dest) > 15))
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %s, byte %v", dest, src)) }
    if idest > 15 { idest -= 12 }
    generic_from_memory_to_reg(assembler, rex, false, mov_r8_rm8, .RM, int(idest), src)
}
mov_reg32_memory :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %s, dword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, mov_r16_rm16, .RM, int(dest), src)
}
mov_reg16_memory :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %s, word %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, mov_r16_rm16, .RM, int(dest), src)
}
mov_reg64_memory :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %s, qword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, mov_r16_rm16, .RM, int(dest), src)

}
mov_memory_reg8 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest.base.(Reg64)) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov byte %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, rex, false, mov_rm8_r8, .MR, dest, int(isrc))
}
mov_memory_reg16 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg16) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov word %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, true, mov_rm16_r16, .MR, dest, int(src))
}
mov_memory_reg32 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg32) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov dword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {}, false, mov_rm16_r16, .MR, dest, int(src))
}
mov_memory_reg64 :: proc(using assembler: ^Assembler, dest: Memory, src: Reg64) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov qword %v, %s", dest, src)) }
    generic_from_reg_to_memory(assembler, {.W}, false, mov_rm16_r16, .MR, dest, int(src))
}
mov_reg64_imm :: proc(using assembler: ^Assembler, dest: Reg64, src: int) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("movabs %s, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("movabs %s, %i", dest, src)) }
    }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, {}, mov_r64_imm.bytes[0], int(dest), 0, src, 8, .MI)
}
mov_memory_imm8 :: proc(using assembler: ^Assembler, dest: Memory, src: u8) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov byte %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov byte %v, %i", dest, src)) }
    }
    generic_from_imm_to_memory(assembler, {}, true, mov_rm8_imm, dest, int(src), 1)
}
mov_memory_imm16 :: proc(using assembler: ^Assembler, dest: Memory, src: i16) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov word %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov word %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, true, mov_rm64_imm, dest, int(src), 2)
}
mov_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov dword %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov dword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {}, false, mov_rm64_imm, dest, int(src), 4)
}
movsx_memory_imm :: proc(using assembler: ^Assembler, dest: Memory, src: i32) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov qword %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov qword %v, %i", dest, src)) }
    }
     
    generic_from_imm_to_memory(assembler, {.W}, false, mov_rm64_imm, dest, int(src), 4)
}



mov_reg_imm8 :: proc(using assembler: ^Assembler, dest: Reg8, src: u8) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %v, %i", dest, src)) }
    }
    idest := u8(dest)
    rex := RexPrefix {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if idest > 15 { idest -= 12 }
    generic_reg_or_imm_to_reg(assembler, {.Rex}, nil, mov_rm8_imm, 0b1100_0000, int(idest), 0, int(src), 1, OperandEncoding.MI)
}
mov_reg_imm16 :: proc(using assembler: ^Assembler, dest: Reg16, src: i16) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, OLD_PREFIX, mov_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 2, OperandEncoding.MI)
}
mov_reg_imm :: proc(using assembler: ^Assembler, dest: Reg32, src: i32) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {}, nil, mov_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
     
}
movsx_reg_imm :: proc(using assembler: ^Assembler, dest: Reg64, src: i32) {
    if src >= 10 {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %v, 0x%x", dest, src)) }
    }
    else {
        if mnemonics != nil { append(&mnemonics, fmt.aprintf("mov %v, %i", dest, src)) }
    }
     
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, mov_rm64_imm, 0b1100_0000, int(dest), 0, int(src), 4, OperandEncoding.MI)
}




lea :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("lea %s, %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, lea_r64_m, .RM, int(dest), src)

}


movzx_reg16_reg8 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movzx %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, rex, OLD_PREFIX, movzx_r16_rm8, REGISTER_DIRECT, int(dest), int(isrc), 0, 0, OperandEncoding.RM) 
}

movzx_reg64_reg8 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movzx %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, rex | {.W}, nil, movzx_r16_rm8, REGISTER_DIRECT, int(dest), int(isrc), 0, 0, OperandEncoding.RM) 
}

movzx_reg32_reg8 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movzx %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, rex, nil, movzx_r16_rm8, REGISTER_DIRECT, int(dest), int(isrc), 0, 0, OperandEncoding.RM) 
}

movzx_reg64_reg16 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg16) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movzx %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, movzx_r32_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
movzx_reg32_reg16 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg16) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movzx %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, movzx_r32_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}

movsx_reg16_reg8 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsx %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, rex, OLD_PREFIX, movsx_r16_rm8, REGISTER_DIRECT, int(dest), int(isrc), 0, 0, OperandEncoding.RM) 
}

movsx_reg64_reg8 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsx %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, rex | {.W}, nil, movsx_r16_rm8, REGISTER_DIRECT, int(dest), int(isrc), 0, 0, OperandEncoding.RM) 
}

movsx_reg32_reg8 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg8) {
    isrc := u8(src)
    assert(!(u8(dest) > 7 && u8(src) > 15))
    rex: RexPrefix = {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc > 15 { isrc -= 12 }
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsx %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, rex, nil, movsx_r16_rm8, REGISTER_DIRECT, int(dest), int(isrc), 0, 0, OperandEncoding.RM) 
}

movsx_reg64_reg16 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg16) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsx %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, movsx_r32_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
movsx_reg64_reg32 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg32) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsxd %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, movsx_r64_rm32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
movsx_reg32_reg16 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg16) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsx %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, movsx_r32_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}

movsx_reg64_memory8 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsx %s, byte %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, movsx_r16_rm8, .RM, int(dest), src)
}
movsx_reg32_memory8 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsx %s, byte %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, movsx_r16_rm8, .RM, int(dest), src)
}
movsx_reg16_memory8 :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsx %s, byte %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, movsx_r16_rm8, .RM, int(dest), src)
}
movsx_reg64_memory16 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsx %s, word %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, movsx_r32_rm16, .RM, int(dest), src)
}
movsx_reg32_memory16 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("movsx %s, word %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, movsx_r32_rm16, .RM, int(dest), src)
}




mov :: proc { 
    mov_reg64_memory, mov_reg32_memory, mov_reg16_memory, mov_reg8_memory, 
    mov_reg64_reg64, mov_reg32_reg32, mov_reg16_reg16, mov_reg8_reg8, 
    mov_memory_reg64, mov_memory_reg32, mov_memory_reg16, mov_memory_reg8,
    mov_reg64_imm,
    mov_memory_imm, mov_memory_imm16, mov_memory_imm8,
    mov_reg_imm, mov_reg_imm8, mov_reg_imm16,
}
movzx :: proc { movzx_reg32_reg8, movzx_reg16_reg8, movzx_reg64_reg8, movzx_reg32_reg16, movzx_reg64_reg16}
movsx :: proc {movsx_memory_imm, movsx_reg_imm, movsx_reg32_reg8, movsx_reg16_reg8, movsx_reg64_reg8, movsx_reg32_reg16, movsx_reg64_reg16, movsx_reg64_reg32}
movsx_mem16 :: proc { movsx_reg32_memory16, movsx_reg64_memory16 }
movsx_mem8 :: proc { movsx_reg32_memory8, movsx_reg64_memory8, movsx_reg16_memory8 }
