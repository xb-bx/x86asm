#+feature using-stmt
package x86asm
import "core:fmt"
maxsd_xm_xm := Opcode { bytes = [4]u8 {0xf, 0x5f, 0,0}, size = 2, modrm_ext = 0}

maxsd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("maxsd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, maxsd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
maxss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("maxss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, maxsd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
maxss :: proc { maxss_xmm_xmm }
maxsd :: proc { maxsd_xmm_xmm }
