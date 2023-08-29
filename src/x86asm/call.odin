package x86asm
import "core:fmt"

call_rm :: Opcode {bytes = [4]u8 {0xff, 0,0,0,}, size = 1, modrm_ext = 2 }

call_r64 :: proc(using assembler: ^Assembler, src: Reg64) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("call %s", src)) }
    generic_reg(assembler, {}, false, call_rm, int(src))
}
call_memory :: proc(using assembler: ^Assembler, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("call qword %v", src)) }
    generic_from_memory(assembler, {}, false, call_rm, src)
}
call :: proc { call_r64, call_memory }
