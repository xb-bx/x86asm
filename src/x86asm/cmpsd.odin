package x86asm
import "core:fmt"

cmpsd_xmm_xmmmem :: Opcode { bytes = [4]u8{0x0f, 0xc2,0, 0}, size = 2 }

cmpsd_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm, op: CMPSSOP) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("cmp%ssd %s, %s", op, dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_reg_or_imm_to_reg(assembler, { }, nil, cmpsd_xmm_xmmmem, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
    append(&assembler.bytes, u8(op))
}

cmpsd_xmm_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory, op: CMPSSOP) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("cmp%ssd %s, qword %s", op, dest, src)) }
    append(&assembler.bytes, 0xf2)
    generic_from_memory_to_reg(assembler, {}, false, cmpsd_xmm_xmmmem, .RM, int(dest), src)
    append(&assembler.bytes, u8(op))
}

cmpeqsd_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpsd_xmm_xmm(assembler, dest, src, CMPSSOP.eq)
}
cmpeqsd_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpsd_xmm_mem(assembler, dest, src, CMPSSOP.eq)
}
cmpeqsd :: proc { cmpeqsd_mem, cmpeqsd_reg }

cmplesd_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpsd_xmm_xmm(assembler, dest, src, CMPSSOP.le)
}
cmplesd_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpsd_xmm_mem(assembler, dest, src, CMPSSOP.le)
}
cmplesd :: proc { cmplesd_mem, cmplesd_reg }
cmpneqsd_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpsd_xmm_xmm(assembler, dest, src, CMPSSOP.neq)
}
cmpneqsd_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpsd_xmm_mem(assembler, dest, src, CMPSSOP.neq)
}
cmpneqsd :: proc { cmpneqsd_mem, cmpneqsd_reg }

cmpltsd_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpsd_xmm_xmm(assembler, dest, src, CMPSSOP.lt)
}
cmpltsd_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpsd_xmm_mem(assembler, dest, src, CMPSSOP.lt)
}
cmpltsd :: proc { cmpltsd_mem, cmpltsd_reg }

cmpunordsd_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpsd_xmm_xmm(assembler, dest, src, CMPSSOP.unord)
}
cmpunordsd_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpsd_xmm_mem(assembler, dest, src, CMPSSOP.unord)
}
cmpunordsd :: proc { cmpunordsd_mem, cmpunordsd_reg }

cmpnltsd_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpsd_xmm_xmm(assembler, dest, src, CMPSSOP.nlt)
}
cmpnltsd_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpsd_xmm_mem(assembler, dest, src, CMPSSOP.nlt)
}
cmpnltsd :: proc { cmpnltsd_mem, cmpnltsd_reg }

cmpnlesd_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpsd_xmm_xmm(assembler, dest, src, CMPSSOP.nle)
}
cmpnlesd_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpsd_xmm_mem(assembler, dest, src, CMPSSOP.nle)
}
cmpnlesd :: proc { cmpnlesd_mem, cmpnlesd_reg }

cmpordsd_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpsd_xmm_xmm(assembler, dest, src, CMPSSOP.ord)
}
cmpordsd_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpsd_xmm_mem(assembler, dest, src, CMPSSOP.ord)
}
cmpordsd :: proc { cmpordsd_mem, cmpordsd_reg }
