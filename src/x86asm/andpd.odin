#+feature using-stmt
package x86asm
import "core:fmt"
andpd_xm_xm := Opcode { bytes = [4]u8 {0xf, 0x54, 0,0}, size = 2, modrm_ext = 0}

andpd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("andpd %s, %s", dest, src)) }
    append(&assembler.bytes, 0x66)
    generic_reg_or_imm_to_reg(assembler, { }, nil, andpd_xm_xm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
andpd :: proc { andpd_xmm_xmm }
