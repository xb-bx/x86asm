package x86asm
import "core:fmt"

inc_rm8 :: Opcode {bytes = [4]u8{0xfe, 0,0,0,}, size = 1, modrm_ext = 0}
inc_rm64 :: Opcode {bytes = [4]u8{0xff, 0,0,0,}, size = 1, modrm_ext = 0}


inc_m64 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("inc qword %s", src)) }
    generic_from_memory(assembler, {.W}, false, inc_rm64, src)
}
inc_m32 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("inc dword %s", src)) }
    generic_from_memory(assembler, {}, false, inc_rm64, src)
}
inc_m16 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("inc word %s", src)) }
    generic_from_memory(assembler, {}, true, inc_rm64, src)
}
inc_m8 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("inc byte %s", src)) }
    generic_from_memory(assembler, {}, false, inc_rm8, src)
}
inc_r64 :: proc(using assembler: ^Assembler, src: Reg64)  {
    if remember { append(&mnemonics, fmt.aprintf("inc %s", src)) }
    generic_reg(assembler, {.W}, false, inc_rm64, int(src))
}
inc_r32 :: proc(using assembler: ^Assembler, src: Reg32)  {
    if remember { append(&mnemonics, fmt.aprintf("inc %s", src)) }
    generic_reg(assembler, {}, false, inc_rm64, int(src))
}
inc_r16 :: proc(using assembler: ^Assembler, src: Reg16)  {
    if remember { append(&mnemonics, fmt.aprintf("inc %s", src)) }
    generic_reg(assembler, {}, true, inc_rm64, int(src))
}
inc_r8 :: proc(using assembler: ^Assembler, src: Reg8)  {
    isrc := u8(src)
    rex := RexPrefix {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("inc %s", src)) }
    if isrc > 15 { isrc -= 12 }
    generic_reg(assembler, rex,  false, inc_rm8, int(isrc))
}
inc :: proc { inc_r8, inc_r16, inc_r32, inc_r64 }
