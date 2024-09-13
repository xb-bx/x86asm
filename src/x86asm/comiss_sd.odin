package x86asm
import "core:fmt"

comiss_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x2f, 0,0}, size = 2 }
comisd_xmm1_xmm2 :: Opcode { bytes = [4]u8{0x0f, 0x2f, 0,0}, size = 2 }

 
comiss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("comiss %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, { }, nil, comiss_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
comiss_xmm_mem32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("comiss %s, dword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, false, comiss_xmm1_xmm2, .RM, int(dest), src)
}
comisd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("comisd %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, { }, OLD_PREFIX, comisd_xmm1_xmm2, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
comisd_xmm_mem64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("comisd %s, xmmword %s", dest, src)) }
    generic_from_memory_to_reg(assembler, {}, true, comisd_xmm1_xmm2, .RM, int(dest), src)
}
comiss :: proc { comiss_xmm_xmm, comiss_xmm_mem32 }
comisd :: proc { comisd_xmm_xmm, comisd_xmm_mem64 }
