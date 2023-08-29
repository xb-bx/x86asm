package x86asm
import "core:fmt"

jmp_rm :: Opcode {bytes = [4]u8 {0xff, 0,0,0,}, size = 1, modrm_ext = 4 }

jmp_r64 :: proc(using assembler: ^Assembler, src: Reg64) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("jmp %s", src)) }
    generic_reg(assembler, {}, false, jmp_rm, int(src))
}
jmp_memory :: proc(using assembler: ^Assembler, src: Memory) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("jmp qword %v", src)) }
    generic_from_memory(assembler, {}, false, jmp_rm, src)
}

jmp_lbl :: proc(using assembler: ^Assembler, lbl: Label) {
    append(&bytes, 0xe9)
    place := len(bytes)
    append(&bytes, 0)
    append(&bytes, 0)
    append(&bytes, 0)
    append(&bytes, 0)
    append(&labelplaces, tuple(lbl.id, place))
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("jmp label_%i", lbl.id)) }
}
// j<cond> lbl
jcc :: proc(using assembler: ^Assembler, cond: u8, lbl: Label) {
    append(&bytes, 0x0f)
    append(&bytes, cond)
    place := len(bytes)
    append(&bytes, 0)
    append(&bytes, 0)
    append(&bytes, 0)
    append(&bytes, 0)
    append(&labelplaces, tuple(lbl.id, place))
}
je :: proc(using assembler: ^Assembler, lbl: Label) {
    jcc(assembler, 0x84, lbl)
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("je label_%i", lbl.id)) }
}
jne :: proc(using assembler: ^Assembler, lbl: Label) {
    jcc(assembler, 0x85, lbl)
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("jne label_%i", lbl.id)) }
}
jle :: proc(using assembler: ^Assembler, lbl: Label) {
    jcc(assembler, 0x8e, lbl)
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("jle label_%i", lbl.id)) }
}
jlt :: proc(using assembler: ^Assembler, lbl: Label) {
    jcc(assembler, 0x8c, lbl)
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("jlt label_%i", lbl.id)) }
}
jgt :: proc(using assembler: ^Assembler, lbl: Label) {
    jcc(assembler, 0x8f, lbl)
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("jgt label_%i", lbl.id)) }
}
jge :: proc(using assembler: ^Assembler, lbl: Label) {
    jcc(assembler, 0x8d, lbl)
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("jge label_%i", lbl.id)) }
}



jmp :: proc { jmp_r64, jmp_memory, jmp_lbl }
