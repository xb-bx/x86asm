package x86asm
import "core:fmt"

cvttsd2si_r32_xmm1m32 :: Opcode { bytes = [4]u8{0x0f, 0x2c, 0,0}, size = 2 }

 
cvttsd2si_reg32_xmm :: proc(using assembler: ^Assembler, dest: Reg32, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("cvttsd2si %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, cvttsd2si_r32_xmm1m32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
cvttsd2si_reg32_mem32 :: proc(using assembler: ^Assembler, dest: Reg32, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cvttsd2si %s, qword %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {}, false, cvttsd2si_r32_xmm1m32, .RM, int(dest), src)
}

cvttsd2si_reg64_xmm :: proc(using assembler: ^Assembler, dest: Reg64, src: Xmm) {
    if remember { append(&mnemonics, fmt.aprintf("cvttsd2si %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cvttsd2si_r32_xmm1m32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}
cvttsd2si_reg64_mem64 :: proc(using assembler: ^Assembler, dest: Reg64, src: Memory) {
    if remember { append(&mnemonics, fmt.aprintf("cvttsd2si %s, qword %s", dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {.W}, false, cvttsd2si_r32_xmm1m32, .RM, int(dest), src)
}
cvttsd2si :: proc { cvttsd2si_reg64_xmm, cvttsd2si_reg32_xmm, cvttsd2si_reg64_mem64, cvttsd2si_reg32_mem32 }
