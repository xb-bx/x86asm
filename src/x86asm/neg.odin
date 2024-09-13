package x86asm
import "core:fmt"

neg_rm8 :: Opcode {bytes = [4]u8{0xf6, 0,0,0,}, size = 1, modrm_ext = 3}
neg_rm64 :: Opcode {bytes = [4]u8{0xf7, 0,0,0,}, size = 1, modrm_ext = 3}


neg_m64 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("neg qword %s", src)) }
    generic_from_memory(assembler, {.W}, false, neg_rm64, src)
}
neg_m32 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("neg dword %s", src)) }
    generic_from_memory(assembler, {}, false, neg_rm64, src)
}
neg_m16 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("neg word %s", src)) }
    generic_from_memory(assembler, {}, true, neg_rm64, src)
}
neg_m8 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("neg byte %s", src)) }
    generic_from_memory(assembler, {}, false, neg_rm8, src)
}
neg_r64 :: proc(using assembler: ^Assembler, src: Reg64)  {
    if remember { append(&mnemonics, fmt.aprintf("neg %s", src)) }
    generic_reg(assembler, {.W}, false, neg_rm64, int(src))
}
neg_r32 :: proc(using assembler: ^Assembler, src: Reg32)  {
    if remember { append(&mnemonics, fmt.aprintf("neg %s", src)) }
    generic_reg(assembler, {}, false, neg_rm64, int(src))
}
neg_r16 :: proc(using assembler: ^Assembler, src: Reg16)  {
    if remember { append(&mnemonics, fmt.aprintf("neg %s", src)) }
    generic_reg(assembler, {}, true, neg_rm64, int(src))
}
neg_r8 :: proc(using assembler: ^Assembler, src: Reg8)  {
    isrc := u8(src)
    rex := RexPrefix {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("neg %s", src)) }
    if isrc > 15 { isrc -= 12 }
    generic_reg(assembler, rex,  false, neg_rm8, int(isrc))
}
neg :: proc { neg_r8, neg_r16, neg_r32, neg_r64 }
