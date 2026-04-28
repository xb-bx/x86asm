#+feature using-stmt
package x86asm
import "core:fmt"

roundsd_xmm_xmmmem :: Opcode { bytes = [4]u8{0x0f, 0x3a, 0x0b, 0}, size = 3 }
roundss_xmm_xmmmem :: Opcode { bytes = [4]u8{0x0f, 0x3a, 0x0a, 0}, size = 3 }

ROUNDOP:: enum {
    FLOOR = 1,
    CEIL,
    TRUNC,
    NEAREST,
}
 
roundss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm, op: ROUNDOP) {
    if remember { append(&mnemonics, fmt.aprintf("roundss %s, %s, %i", dest, src, op)) }
    append(&assembler.bytes, 0x66)
    generic_reg_or_imm_to_reg(assembler, { }, nil, roundss_xmm_xmmmem, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
    append(&assembler.bytes, u8(op))
}
roundsd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm, op: ROUNDOP) {
    if remember { append(&mnemonics, fmt.aprintf("roundsd %s, %s, %i", dest, src, op)) }
    append(&assembler.bytes, 0x66)
    generic_reg_or_imm_to_reg(assembler, { }, nil, roundsd_xmm_xmmmem, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
    append(&assembler.bytes, u8(op))
}


roundss :: proc { roundss_xmm_xmm }
roundsd :: proc { roundsd_xmm_xmm }
