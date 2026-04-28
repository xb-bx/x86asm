#+feature using-stmt
package x86asm
import "core:fmt"
rol_rm32_cl := Opcode { bytes = [4]u8 {0xd3, 0,0,0,}, size = 1, modrm_ext = 0}
rol_reg16_cl :: proc(using assembler: ^Assembler, reg: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("rol %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { }, OLD_PREFIX, rol_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
rol_reg32_cl :: proc(using assembler: ^Assembler, reg: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("rol %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { }, nil, rol_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
rol_reg64_cl :: proc(using assembler: ^Assembler, reg: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("rol %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { .W }, nil, rol_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
rol_cl :: proc { rol_reg16_cl, rol_reg32_cl, rol_reg64_cl }
