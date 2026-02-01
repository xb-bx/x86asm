#+feature using-stmt
package x86asm
import "core:fmt"

cvtsi2sd_xmm1_r32m32 :: Opcode { bytes = [4]u8{0x0f, 0x2a, 0,0}, size = 2 }

 
cvtsi2sd_mem32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cvtsi2sd %s, dword %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {}, false, cvtsi2sd_xmm1_r32m32, .RM, int(dest), src)
}
cvtsi2sd_xmm_reg32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("cvtsi2sd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, cvtsi2sd_xmm1_r32m32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}

cvtsi2sd_mem64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cvtsi2sd %s, qword %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {.W}, false, cvtsi2sd_xmm1_r32m32, .RM, int(dest), src)
}
cvtsi2sd_xmm_reg64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("cvtsi2sd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cvtsi2sd_xmm1_r32m32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}

cvtsi2sd :: proc { cvtsi2sd_xmm_reg64, cvtsi2sd_xmm_reg32 }
