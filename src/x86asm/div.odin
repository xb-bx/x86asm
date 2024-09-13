package x86asm
import "core:fmt"

div_rm8 :: Opcode {bytes = [4]u8{0xf6, 0,0,0,}, size = 1, modrm_ext = 6}
div_rm64 :: Opcode {bytes = [4]u8{0xf7, 0,0,0,}, size = 1, modrm_ext = 6}
idiv_rm8 :: Opcode {bytes = [4]u8{0xf6, 0,0,0,}, size = 1, modrm_ext = 7}
idiv_rm64 :: Opcode {bytes = [4]u8{0xf7, 0,0,0,}, size = 1, modrm_ext = 7}


div_m64 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("div qword %s", src)) }
    generic_from_memory(assembler, {.W}, false, div_rm64, src)
}
div_m32 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("div dword %s", src)) }
    generic_from_memory(assembler, {}, false, div_rm64, src)
}
div_m16 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("div word %s", src)) }
    generic_from_memory(assembler, {}, true, div_rm64, src)
}
div_m8 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("div byte %s", src)) }
    generic_from_memory(assembler, {}, false, div_rm8, src)
}
div_r64 :: proc(using assembler: ^Assembler, src: Reg64)  {
    if remember { append(&mnemonics, fmt.aprintf("div %s", src)) }
    generic_reg(assembler, {.W}, false, div_rm64, int(src))
}
div_r32 :: proc(using assembler: ^Assembler, src: Reg32)  {
    if remember { append(&mnemonics, fmt.aprintf("div %s", src)) }
    generic_reg(assembler, {}, false, div_rm64, int(src))
}
div_r16 :: proc(using assembler: ^Assembler, src: Reg16)  {
    if remember { append(&mnemonics, fmt.aprintf("div %s", src)) }
    generic_reg(assembler, {}, true, div_rm64, int(src))
}
div_r8 :: proc(using assembler: ^Assembler, src: Reg8)  {
    isrc := u8(src)
    rex := RexPrefix {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("div %s", src)) }
    if isrc > 15 { isrc -= 12 }
    generic_reg(assembler, rex,  false, div_rm8, int(isrc))
}
div :: proc { div_r8, div_r16, div_r32, div_r64 }

idiv_m64 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("idiv qword %s", src)) }
    generic_from_memory(assembler, {.W}, false, idiv_rm64, src)
}
idiv_m32 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("idiv dword %s", src)) }
    generic_from_memory(assembler, {}, false, idiv_rm64, src)
}
idiv_m16 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("idiv word %s", src)) }
    generic_from_memory(assembler, {}, true, idiv_rm64, src)
}
idiv_m8 :: proc(using assembler: ^Assembler, src: Memory)  {
    if remember { append(&mnemonics, fmt.aprintf("idiv byte %s", src)) }
    generic_from_memory(assembler, {}, false, idiv_rm8, src)
}
idiv_r64 :: proc(using assembler: ^Assembler, src: Reg64)  {
    if remember { append(&mnemonics, fmt.aprintf("idiv %s", src)) }
    generic_reg(assembler, {.W}, false, idiv_rm64, int(src))
}
idiv_r32 :: proc(using assembler: ^Assembler, src: Reg32)  {
    if remember { append(&mnemonics, fmt.aprintf("idiv %s", src)) }
    generic_reg(assembler, {}, false, idiv_rm64, int(src))
}
idiv_r16 :: proc(using assembler: ^Assembler, src: Reg16)  {
    if remember { append(&mnemonics, fmt.aprintf("idiv %s", src)) }
    generic_reg(assembler, {}, true, idiv_rm64, int(src))
}
idiv_r8 :: proc(using assembler: ^Assembler, src: Reg8)  {
    isrc := u8(src)
    rex := RexPrefix {}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    if remember { append(&mnemonics, fmt.aprintf("idiv %s", src)) }
    if isrc > 15 { isrc -= 12 }
    generic_reg(assembler, rex,  false, idiv_rm8, int(isrc))
}




idiv :: proc { idiv_r8, idiv_r16, idiv_r32, idiv_r64 }
