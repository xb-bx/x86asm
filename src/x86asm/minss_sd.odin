#+feature using-stmt
package x86asm
import "core:fmt"
minsd_xm_xm := Opcode { bytes = [4]u8 {0xf, 0x5d, 0,0}, size = 2, modrm_ext = 0}

minsd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("minsd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, minsd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
minss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("minss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, minsd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
minss :: proc { minss_xmm_xmm }
minsd :: proc { minsd_xmm_xmm }
