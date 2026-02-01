#+feature using-stmt
package x86asm
import "core:fmt"
shr_rm32_cl := Opcode { bytes = [4]u8 {0xd3, 0,0,0,}, size = 1, modrm_ext = 5}
sar_rm32_cl := Opcode { bytes = [4]u8 {0xd3, 0,0,0,}, size = 1, modrm_ext = 7}
shr_reg16_cl :: proc(using assembler: ^Assembler, reg: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("shr %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { }, OLD_PREFIX, shr_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
shr_reg32_cl :: proc(using assembler: ^Assembler, reg: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("shr %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { }, nil, shr_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
shr_reg64_cl :: proc(using assembler: ^Assembler, reg: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("shr %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { .W }, nil, shr_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
shr_cl :: proc { shr_reg16_cl, shr_reg32_cl, shr_reg64_cl }

sar_reg16_cl :: proc(using assembler: ^Assembler, reg: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("sar %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { }, OLD_PREFIX, sar_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
sar_reg32_cl :: proc(using assembler: ^Assembler, reg: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("sar %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { }, nil, sar_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
sar_reg64_cl :: proc(using assembler: ^Assembler, reg: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("sar %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { .W }, nil, sar_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
sar_cl :: proc { sar_reg16_cl, sar_reg32_cl, sar_reg64_cl }
