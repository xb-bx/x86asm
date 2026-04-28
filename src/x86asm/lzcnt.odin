#+feature using-stmt
package x86asm
import "core:fmt"
lzcnt_rm16 := Opcode { bytes = [4]u8 {0x0f, 0xbd, 0,0}, size = 2, modrm_ext = 0}

lzcnt_reg32_reg32:: proc(using assembler: ^Assembler, dest: Reg32, src: Reg32) {
    if remember { append(&mnemonics, fmt.aprintf("lzcnt %s, %s", dest, src)) }
    rex := RexPrefix {}
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, rex, nil, lzcnt_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}

lzcnt_reg64_reg64:: proc(using assembler: ^Assembler, dest: Reg64, src: Reg64) {
    if remember { append(&mnemonics, fmt.aprintf("lzcnt %s, %s", dest, src)) }
    rex := RexPrefix {.W}
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, rex, nil, lzcnt_rm16, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}

