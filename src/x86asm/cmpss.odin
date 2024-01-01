package x86asm
import "core:fmt"

cmpss_xmm_xmmmem :: Opcode { bytes = [4]u8{0x0f, 0xc2,0, 0}, size = 2 }

CMPSSOP :: enum {
    eq = 0,
    lt,
    le,
    unord,
    neq,
    nlt,
    nle,
    ord,
}
 
cmpss_xmm_xmm :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm, op: CMPSSOP) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("cmp%sss %s, %s", op, dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_reg_or_imm_to_reg(assembler, { }, nil, cmpss_xmm_xmmmem, REGISTER_DIRECT, int(dest), int(src), 0, 0, OperandEncoding.RM) 
    append(&assembler.bytes, u8(op))
}

cmpss_xmm_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory, op: CMPSSOP) {
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("cmp%sss %s, dword %s", op, dest, src)) }
    append(&assembler.bytes, 0xf3)
    generic_from_memory_to_reg(assembler, {}, false, cmpss_xmm_xmmmem, .RM, int(dest), src)
    append(&assembler.bytes, u8(op))
}

cmpeqss_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpss_xmm_xmm(assembler, dest, src, CMPSSOP.eq)
}
cmpeqss_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpss_xmm_mem(assembler, dest, src, CMPSSOP.eq)
}
cmpeqss :: proc { cmpeqss_mem, cmpeqss_reg }

cmpless_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpss_xmm_xmm(assembler, dest, src, CMPSSOP.le)
}
cmpless_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpss_xmm_mem(assembler, dest, src, CMPSSOP.le)
}
cmpless :: proc { cmpless_mem, cmpless_reg }
cmpneqss_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpss_xmm_xmm(assembler, dest, src, CMPSSOP.neq)
}
cmpneqss_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpss_xmm_mem(assembler, dest, src, CMPSSOP.neq)
}
cmpneqss :: proc { cmpneqss_mem, cmpneqss_reg }

cmpltss_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpss_xmm_xmm(assembler, dest, src, CMPSSOP.lt)
}
cmpltss_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpss_xmm_mem(assembler, dest, src, CMPSSOP.lt)
}
cmpltss :: proc { cmpltss_mem, cmpltss_reg }

cmpunordss_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpss_xmm_xmm(assembler, dest, src, CMPSSOP.unord)
}
cmpunordss_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpss_xmm_mem(assembler, dest, src, CMPSSOP.unord)
}
cmpunordss :: proc { cmpunordss_mem, cmpunordss_reg }

cmpnltss_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpss_xmm_xmm(assembler, dest, src, CMPSSOP.nlt)
}
cmpnltss_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpss_xmm_mem(assembler, dest, src, CMPSSOP.nlt)
}
cmpnltss :: proc { cmpnltss_mem, cmpnltss_reg }

cmpnless_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpss_xmm_xmm(assembler, dest, src, CMPSSOP.nle)
}
cmpnless_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpss_xmm_mem(assembler, dest, src, CMPSSOP.nle)
}
cmpnless :: proc { cmpnless_mem, cmpnless_reg }

cmpordss_reg :: proc(using assembler: ^Assembler, dest: Xmm, src: Xmm) {
    cmpss_xmm_xmm(assembler, dest, src, CMPSSOP.ord)
}
cmpordss_mem :: proc(using assembler: ^Assembler, dest: Xmm, src: Memory) {
    cmpss_xmm_mem(assembler, dest, src, CMPSSOP.ord)
}
cmpordss :: proc { cmpordss_mem, cmpordss_reg }
