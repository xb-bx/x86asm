
package x86asm
import "core:fmt"

cvtsd2ss_xmm1_xmm2m32 :: Opcode { bytes = [4]u8{0x0f, 0x5a, 0,0}, size = 2 }

cvtsd2ss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("cvtsd2ss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, cvtsd2ss_xmm1_xmm2m32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
cvtsd2ss_xmm_mem64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("cvtsd2ss %s, qword %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {}, false, cvtsd2ss_xmm1_xmm2m32, .RM, int(dest), src)
}
cvtsd2ss :: proc { cvtsd2ss_xmm_xmm, cvtsd2ss_xmm_mem64 }

 
