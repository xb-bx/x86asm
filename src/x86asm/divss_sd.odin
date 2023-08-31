package x86asm
import "core:fmt"

divss_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x5e, 0,0}, size = 2 }
divsd_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x5e, 0,0}, size = 2 }

 
divss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("divss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, divss_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
divss_xmm_mem32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("divss %s, dword %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_from_memory_to_reg(assembler, {}, false, divss_xmm1_xmm2, .RM, int(dest), src)
}
divsd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("divsd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, divsd_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
divsd_xmm_mem64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("divsd %s, qword %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {}, false, divsd_xmm1_xmm2, .RM, int(dest), src)
}
divss :: proc { addss_xmm_xmm, addss_xmm_mem32 }
divsd :: proc { addsd_xmm_xmm, addsd_xmm_mem64 }
