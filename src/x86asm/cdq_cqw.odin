package x86asm

cdq :: proc(assembler: ^Assembler) {
    if assembler.mnemonics != nil {
        append(&assembler.mnemonics, "cdq")
    }
    append(&assembler.bytes, 0x99)
}
cqo :: proc(assembler: ^Assembler) {
    if assembler.mnemonics != nil {
        append(&assembler.mnemonics, "cqo")
    }
    append(&assembler.bytes, 0x48)
    append(&assembler.bytes, 0x99)
}
