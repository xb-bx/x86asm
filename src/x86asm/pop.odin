package x86asm
import "core:fmt"

pop_reg :: Opcode { bytes = [4]u8 { 0x58, 0, 0,0}, size = 1} 
pop_rm :: Opcode {bytes = [4]u8 {0x8f, 0,0,0,}, size = 1, modrm_ext = 0 }

pop_r64 :: proc(using assembler: ^Assembler, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("pop %s", src)) }
    generic_opcode_reg(assembler, {}, false, pop_reg, int(src))
}
pop_r16 :: proc(using assembler: ^Assembler, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("pop %s", src)) }
    generic_opcode_reg(assembler, {}, true, pop_reg, int(src))
}
pop_memory :: proc(using assembler: ^Assembler, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("pop qword %v", src)) }
    generic_from_memory(assembler, {}, false, pop_rm, src)
}
pop :: proc { pop_r64, pop_r16, pop_memory }
