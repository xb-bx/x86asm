#+feature using-stmt
package x86asm
import "core:fmt"

movss_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x10, 0,0}, size = 2 }
movss_m32_xmm1 :: Opcode { bytes = [4]u8{0x0f, 0x11, 0,0 }, size = 2 }
movsd_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x10, 0,0}, size = 2 }
movsd_m32_xmm1 :: Opcode { bytes = [4]u8{0x0f, 0x11, 0,0 }, size = 2 }

 
movss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("movss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, movss_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
movss_xmm_mem32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("movss %s, dword %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_from_memory_to_reg(assembler, {}, false, movss_xmm1_xmm2, .RM, int(dest), src)
}
movss_mem32_xmm :: proc(using assembler: ^Assembler, dest: Memory, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("movss dword %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_from_reg_to_memory(assembler, {}, false, movss_m32_xmm1, .MR, dest, int(src))
}
movsd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("movsd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, movsd_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
movsd_xmm_mem64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("movsd %s, qword %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {}, false, movsd_xmm1_xmm2, .RM, int(dest), src)
}
movsd_mem64_xmm :: proc(using assembler: ^Assembler, dest: Memory, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("movsd qword %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_reg_to_memory(assembler, {}, false, movsd_m32_xmm1, .MR, dest, int(src))
}
movss :: proc { movss_xmm_xmm, movss_mem32_xmm, movss_xmm_mem32 }
movsd :: proc { movsd_xmm_xmm, movsd_mem64_xmm, movsd_xmm_mem64 }
