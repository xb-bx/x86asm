#+feature using-stmt
package x86asm
import "core:fmt"
sqrtsd_xm_xm := Opcode { bytes = [4]u8 {0xf, 0x51, 0,0}, size = 2, modrm_ext = 0}

sqrtsd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("sqrtsd %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, sqrtsd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
sqrtss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("sqrtss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, sqrtsd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
sqrtss :: proc { sqrtss_xmm_xmm }
sqrtsd :: proc { sqrtsd_xmm_xmm }
