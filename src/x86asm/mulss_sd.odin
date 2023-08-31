package x86asm
import "core:fmt"

mulss_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x59, 0,0}, size = 2 }
mulsd_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x59, 0,0}, size = 2 }

 
mulss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mulss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, mulss_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
mulss_xmm_mem32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mulss %s, dword %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_from_memory_to_reg(assembler, {}, false, mulss_xmm1_xmm2, .RM, int(dest), src)
}
mulsd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mulsd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, mulsd_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
mulsd_xmm_mem64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("mulsd %s, qword %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {}, false, mulsd_xmm1_xmm2, .RM, int(dest), src)
}
mulss :: proc { mulss_xmm_xmm, mulss_xmm_mem32 }
mulsd :: proc { mulsd_xmm_xmm, mulsd_xmm_mem64 }
