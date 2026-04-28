#+feature using-stmt
package x86asm
import "core:fmt"
movq_xmm_rm32 := Opcode { bytes = [4]u8 {0xf, 0x6e, 0,0}, size = 2, modrm_ext = 0}
movq_rm32_xmm := Opcode { bytes = [4]u8 {0xf, 0x7e, 0,0}, size = 2, modrm_ext = 0}

movq_xmm_reg64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("movq %s, %s", dest, src)) }
    rex := RexPrefix { .W }
    append(&assembler.bytes, 0x66)
    generic_reg_or_imm_to_reg(assembler, rex, nil, movq_xmm_rm32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
movd_xmm_reg32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("movd %s, %s", dest, src)) }
    rex := RexPrefix { }
    append(&assembler.bytes, 0x66)
    generic_reg_or_imm_to_reg(assembler, rex, nil, movq_xmm_rm32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}

movq_reg64_xmm :: proc(using assembler: ^Assembler, dest: Reg64, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("movq %s, %s", dest, src)) }
    rex := RexPrefix { .W }
    append(&assembler.bytes, 0x66)
    generic_reg_or_imm_to_reg(assembler, rex, nil, movq_rm32_xmm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.MR) 
}
movd_reg32_xmm :: proc(using assembler: ^Assembler, dest: Reg32, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("movd %s, %s", dest, src)) }
    rex := RexPrefix { }
    append(&assembler.bytes, 0x66)
    generic_reg_or_imm_to_reg(assembler, rex, nil, movq_rm32_xmm, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.MR) 
}
movd :: proc { movd_reg32_xmm, movd_xmm_reg32 }
movq :: proc { movq_reg64_xmm, movq_xmm_reg64 }
