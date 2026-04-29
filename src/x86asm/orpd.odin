#+feature using-stmt
package x86asm
import "core:fmt"
orpd_xm_xm := Opcode { bytes = [4]u8 {0xf, 0x56, 0,0}, size = 2, modrm_ext = 0}

orpd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("orpd %s, %s", dest, src)) }
    append(&assembler.bytes, 0x66)
    generic_reg_or_imm_to_reg(assembler, { }, nil, orpd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
orps_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("orps %s, %s", dest, src)) }
    // append(&assembler.bytes, 0x66)
    generic_reg_or_imm_to_reg(assembler, { }, nil, orpd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
orpd :: proc { orpd_xmm_xmm }
orps :: proc { orps_xmm_xmm }
