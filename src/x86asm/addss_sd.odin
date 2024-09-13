package x86asm
import "core:fmt"

addss_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x58, 0,0}, size = 2 }
addsd_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x58, 0,0}, size = 2 }

 
addss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("addss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, addss_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
addss_xmm_mem32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("addss %s, dword %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_from_memory_to_reg(assembler, {}, false, addss_xmm1_xmm2, .RM, int(dest), src)
}
addsd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("addsd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, addsd_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
addsd_xmm_mem64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("addsd %s, qword %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {}, false, addsd_xmm1_xmm2, .RM, int(dest), src)
}
addss :: proc { addss_xmm_xmm, addss_xmm_mem32 }
addsd :: proc { addsd_xmm_xmm, addsd_xmm_mem64 }
