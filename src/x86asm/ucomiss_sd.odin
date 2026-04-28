#+feature using-stmt
package x86asm
import "core:fmt"
ucomisd_xm_xm := Opcode { bytes = [4]u8 {0xf, 0x2e, 0,0}, size = 2, modrm_ext = 0}

ucomisd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("ucomisd %s, %s", dest, src)) }
    append(&assembler.bytes, 0x66)
    generic_reg_or_imm_to_reg(assembler, { }, nil, ucomisd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
ucomiss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("ucomiss %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, { }, nil, ucomisd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
ucomiss :: proc { ucomiss_xmm_xmm }
ucomisd :: proc { ucomisd_xmm_xmm }
