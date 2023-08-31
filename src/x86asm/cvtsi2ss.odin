package x86asm
import "core:fmt"

cvtsi2ss_xmm1_r32m32 :: Opcode { bytes = [4]u8{0x0f, 0x2a, 0,0}, size = 2 }

 
cvtsi2ss_mem32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("cvtsi2ss %s, dword %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_from_memory_to_reg(assembler, {}, false, cvtsi2ss_xmm1_r32m32, .RM, int(dest), src)
}
cvtsi2ss_xmm_reg32 :: proc(using assembler: ^Assembler, dest: Xmm, src: Reg32) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("cvtsi2ss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, cvtsi2ss_xmm1_r32m32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}

cvtsi2ss_mem64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("cvtsi2ss %s, qword %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_from_memory_to_reg(assembler, {.W}, false, cvtsi2ss_xmm1_r32m32, .RM, int(dest), src)
}
cvtsi2ss_xmm_reg64 :: proc(using assembler: ^Assembler, dest: Xmm, src: Reg64) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("cvtsi2ss %s, %s", dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, {.W}, nil, cvtsi2ss_xmm1_r32m32, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
}

cvtsi2ss :: proc { cvtsi2sd_xmm_reg64, cvtsi2sd_xmm_reg32 }
