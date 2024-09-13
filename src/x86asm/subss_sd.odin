package x86asm
import "core:fmt"

subss_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x5c, 0,0}, size = 2 }
subsd_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x5c, 0,0}, size = 2 }

 
subss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("subss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, subss_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
subss_xmm_mem32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("subss %s, dword %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_from_memory_to_reg(assembler, {}, false, subss_xmm1_xmm2, .RM, int(dest), src)
}
subsd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("subsd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, subsd_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
subsd_xmm_mem64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("subsd %s, qword %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {}, false, subsd_xmm1_xmm2, .RM, int(dest), src)
}
subss :: proc { subss_xmm_xmm, subss_xmm_mem32 }
subsd :: proc { subsd_xmm_xmm, subsd_xmm_mem64 }
