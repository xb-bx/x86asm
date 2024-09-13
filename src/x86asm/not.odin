package x86asm
import "core:fmt"

not_rm8 :: Opcode {bytes = [4]u8{0xf6, 0,0,0,}, size = 1, modrm_ext = 2}
not_rm64 :: Opcode {bytes = [4]u8{0xf7, 0,0,0,}, size = 1, modrm_ext = 2}


not_m64 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("not qword %s", src)) }
    generic_from_memory(assembler, {.W}, false, not_rm64, src)
}
not_m32 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("not dword %s", src)) }
    generic_from_memory(assembler, {}, false, not_rm64, src)
}
not_m16 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("not word %s", src)) }
    generic_from_memory(assembler, {}, true, not_rm64, src)
}
not_m8 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("not byte %s", src)) }
    generic_from_memory(assembler, {}, false, not_rm8, src)
}
not_r64 :: proc(using assembler: ^Assembler, src: Reg64)  {
    if remember { append(&mnemonics, fmt.aprintf("not %s", src)) }
    generic_reg(assembler, {.W}, false, not_rm64, int(src))
}
not_r32 :: proc(using assembler: ^Assembler, src: Reg32)  {
    if remember { append(&mnemonics, fmt.aprintf("not %s", src)) }
    generic_reg(assembler, {}, false, not_rm64, int(src))
}
not_r16 :: proc(using assembler: ^Assembler, src: Reg16)  {
    if remember { append(&mnemonics, fmt.aprintf("not %s", src)) }
    generic_reg(assembler, {}, true, not_rm64, int(src))
}
not_r8 :: proc(using assembler: ^Assembler, src: Reg8)  {
    isrc := u8(src)
    rex := RexPrefix {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("not %s", src)) }
    if isrc > 15 { isrc -= 12 }
    generic_reg(assembler, rex,  false, not_rm8, int(isrc))
}
not :: proc { not_r8, not_r16, not_r32, not_r64 }
