#+feature using-stmt
package x86asm
import "core:fmt"
test_r8_rm8 := Opcode { bytes = [4]u8 {0x84, 0,0,0,}, size = 1 }
test_r16_rm16 := Opcode { bytes = [4]u8{0x85, 0,0,0,}, size = 1 }
test_reg64_reg64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("test %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, test_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.MR) 
}
test_reg32_reg32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("test %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, nil, test_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.MR) 
}
test_reg16_reg16 :: proc(using assembler: ^Assembler, dest: Reg16, src: Reg16) {
    if remember { append(&mnemonics, fmt.aprintf("test %s, %s", dest, src)) }
    generic_reg_or_imm_to_reg(assembler, {}, 0x66, test_r16_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.MR) 
}
test_reg8_reg8 :: proc(using assembler: ^Assembler, dest: Reg8, src: Reg8) {
    idest := u8(src)
    isrc := u8(dest)
    rex: RexPrefix = {}
    if idest >= u8(Reg8.Spl) && idest <= u8(Reg8.Dil) { rex = {.Rex}}
    if isrc >= u8(Reg8.Spl) && isrc <= u8(Reg8.Dil) { rex = {.Rex}}
    assert(!(rex != {} && (isrc > 15 || idest > 15)))
    if remember { append(&mnemonics, fmt.aprintf("test %s, %s", dest, src)) }
    if idest > 15 { idest -= 12 }
    if isrc > 15 { isrc -= 12 }
    generic_reg_or_imm_to_reg(assembler, rex, nil, test_r8_rm8, REGISTER_DIRECT, int(idest), int(isrc), 0, 0, OperandEncoding.RM) 
}
test :: proc { 
    test_reg64_reg64, test_reg32_reg32, test_reg16_reg16, test_reg8_reg8, 
}
