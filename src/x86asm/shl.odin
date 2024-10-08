package x86asm
import "core:fmt"
shl_rm32_cl := Opcode { bytes = [4]u8 {0xd3, 0,0,0,}, size = 1, modrm_ext = 4}
shl_m16_cl :: proc(using assembler: ^Assembler, reg: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("shl word %v, cl", reg)) }
    generic_from_memory(assembler, {}, true, shl_rm32_cl, reg)
}
shl_m32_cl :: proc(using assembler: ^Assembler, reg: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("shl dword %v, cl", reg)) }
    generic_from_memory(assembler, {}, false, shl_rm32_cl, reg)
}
shl_m64_cl :: proc(using assembler: ^Assembler, reg: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("shl qword %v, cl", reg)) }
    generic_from_memory(assembler, {.W}, false, shl_rm32_cl, reg)
}
shl_reg16_cl :: proc(using assembler: ^Assembler, reg: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("shl %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { }, OLD_PREFIX, shl_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
shl_reg32_cl :: proc(using assembler: ^Assembler, reg: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("shl %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { }, nil, shl_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
shl_reg64_cl :: proc(using assembler: ^Assembler, reg: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("shl %v, cl", reg)) }
    generic_reg_or_imm_to_reg(assembler, { .W }, nil, shl_rm32_cl, REGISTER_DIRECT, int(reg), int(0), 0, 0, OperandEncoding.MR) 

}
shl_cl :: proc { shl_reg16_cl, shl_reg32_cl, shl_reg64_cl }
