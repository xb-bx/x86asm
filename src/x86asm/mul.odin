package x86asm
import "core:fmt"

mul_rm8 :: Opcode {bytes = [4]u8{0xf6, 0,0,0,}, size = 1, modrm_ext = 4}
mul_rm64 :: Opcode {bytes = [4]u8{0xf7, 0,0,0,}, size = 1, modrm_ext = 4}
imul_rm8 :: Opcode {bytes = [4]u8{0xf6, 0,0,0,}, size = 1, modrm_ext = 5}
imul_rm64 :: Opcode {bytes = [4]u8{0xf7, 0,0,0,}, size = 1, modrm_ext = 5}
imul_r16_rm16 := Opcode { bytes = [4]u8{0x0f, 0xaf,0,0,}, size = 2 }


mul_m64 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("mul qword %s", src)) }
    generic_from_memory(assembler, {.W}, false, mul_rm64, src)
}
mul_m32 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("mul dword %s", src)) }
    generic_from_memory(assembler, {}, false, mul_rm64, src)
}
mul_m16 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("mul word %s", src)) }
    generic_from_memory(assembler, {}, true, mul_rm64, src)
}
mul_m8 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("mul byte %s", src)) }
    generic_from_memory(assembler, {}, false, mul_rm8, src)
}
mul_r64 :: proc(using assembler: ^Assembler, src: Reg64)  {
    if remember { append(&mnemonics, fmt.aprintf("mul %s", src)) }
    generic_reg(assembler, {.W}, false, mul_rm64, int(src))
}
mul_r32 :: proc(using assembler: ^Assembler, src: Reg32)  {
    if remember { append(&mnemonics, fmt.aprintf("mul %s", src)) }
    generic_reg(assembler, {}, false, mul_rm64, int(src))
}
mul_r16 :: proc(using assembler: ^Assembler, src: Reg16)  {
    if remember { append(&mnemonics, fmt.aprintf("mul %s", src)) }
    generic_reg(assembler, {}, true, mul_rm64, int(src))
}
mul_r8 :: proc(using assembler: ^Assembler, src: Reg8)  {
    isrc := u8(src)
    rex := RexPrefix {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("mul %s", src)) }
    if isrc > 15 { isrc -= 12 }
    generic_reg(assembler, rex,  false, mul_rm8, int(isrc))
}
mul :: proc { mul_r8, mul_r16, mul_r32, mul_r64 }

imul_m64 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("imul qword %s", src)) }
    generic_from_memory(assembler, {.W}, false, imul_rm64, src)
}
imul_m32 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("imul dword %s", src)) }
    generic_from_memory(assembler, {}, false, imul_rm64, src)
}
imul_m16 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("imul word %s", src)) }
    generic_from_memory(assembler, {}, true, imul_rm64, src)
}
imul_m8 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("imul byte %s", src)) }
    generic_from_memory(assembler, {}, false, imul_rm8, src)
}
imul_r64 :: proc(using assembler: ^Assembler, src: Reg64)  {
    if remember { append(&mnemonics, fmt.aprintf("imul %s", src)) }
    generic_reg(assembler, {.W}, false, imul_rm64, int(src))
}
imul_r32 :: proc(using assembler: ^Assembler, src: Reg32)  {
    if remember { append(&mnemonics, fmt.aprintf("imul %s", src)) }
    generic_reg(assembler, {}, false, imul_rm64, int(src))
}
imul_r16 :: proc(using assembler: ^Assembler, src: Reg16)  {
    if remember { append(&mnemonics, fmt.aprintf("imul %s", src)) }
    generic_reg(assembler, {}, true, imul_rm64, int(src))
}
imul_r8 :: proc(using assembler: ^Assembler, src: Reg8)  {
    isrc := u8(src)
    rex := RexPrefix {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("imul %s", src)) }
    if isrc > 15 { isrc -= 12 }
    generic_reg(assembler, rex,  false, imul_rm8, int(isrc))
}



imul_reg64_reg64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("imul %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, imul_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
imul_reg32_reg32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("imul %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, imul_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
imul_reg16_reg16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("imul %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, 0x66, imul_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}


imul_reg32_memory :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("imul %s, dword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, imul_r16_rm16, .RM, int(dest), src)
}
imul_reg16_memory :: proc(using assembler: ^Assembler, dest: Reg16, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("imul %s, word %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, imul_r16_rm16, .RM, int(dest), src)
}
imul_reg64_memory :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("imul %s, qword %v", dest, src)) }
    generic_from_memory_to_reg(assembler, {.W}, false, imul_r16_rm16, .RM, int(dest), src)
}

imul :: proc { imul_r8, imul_r16, imul_r32, imul_r64, imul_reg64_reg64, imul_reg32_reg32, imul_reg16_reg16, imul_reg16_memory, imul_reg32_memory, imul_reg64_memory}
