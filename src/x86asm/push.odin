#+feature using-stmt
package x86asm
import "core:fmt"

push_reg :: Opcode { bytes = [4]u8 { 0x50, 0, 0,0}, size = 1} 
push_rm :: Opcode {bytes = [4]u8 {0xff, 0,0,0,}, size = 1, modrm_ext = 6 }

push_r64 :: proc(using assembler: ^Assembler, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("push %s", src)) }
    generic_opcode_reg(assembler, {}, false, push_reg, int(src))
}
push_r16 :: proc(using assembler: ^Assembler, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("push %s", src)) }
    generic_opcode_reg(assembler, {}, true, push_reg, int(src))
}
push_memory :: proc(using assembler: ^Assembler, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("push qword %v", src)) }
    generic_from_memory(assembler, {}, false, push_rm, src)
}
push :: proc { push_r64, push_r16, push_memory }
