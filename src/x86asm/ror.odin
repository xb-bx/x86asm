#+feature using-stmt
package x86asm
import "core:fmt"
ror_rm32_cl := Opcode { bytes = [4]u8 {0xd3, 0,0,0,}, size = 1, modrm_ext = 1}
ror_reg16_cl :: proc(using assembler: ^Assembler, reg: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("ror %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { }, OLD_PREFIX, ror_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
ror_reg32_cl :: proc(using assembler: ^Assembler, reg: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("ror %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { }, nil, ror_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
ror_reg64_cl :: proc(using assembler: ^Assembler, reg: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("ror %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { .W }, nil, ror_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
ror_cl :: proc { ror_reg16_cl, ror_reg32_cl, ror_reg64_cl }
