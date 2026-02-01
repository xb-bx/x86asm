#+feature using-stmt
package x86asm
import "core:fmt"

cvtss2sd_xmm1_xmm2m32 :: Opcode { bytes = [4]u8{0x0f, 0x5a, 0,0}, size = 2 }

cvtss2sd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("cvtss2sd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, cvtss2sd_xmm1_xmm2m32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
cvtss2sd_xmm_mem32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cvtss2sd %s, dword %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_from_memory_to_reg(assembler, {}, false, cvtss2sd_xmm1_xmm2m32, .RM, int(dest), src)
}
cvtss2sd :: proc { cvtss2sd_xmm_xmm, cvtss2sd_xmm_mem32 }

 
