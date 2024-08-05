package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "base:intrinsics"
import "core:strings"
import "x86asm:x86asm"

@test
test_cmovge_imm:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmovge(assembler, Reg32(i), eax)
        cmovge(assembler, Reg16(i), ax)
        cmovge(assembler, Reg64(i), rax)
        cmovge_m32(assembler, Reg32(i), at(Reg64(i)))
        cmovge_m16(assembler, Reg16(i), at(Reg64(i)))
        cmovge_m64(assembler, Reg64(i), at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}

@test
test_cmovl_imm:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmovl(assembler, Reg32(i), eax)
        cmovl(assembler, Reg16(i), ax)
        cmovl(assembler, Reg64(i), rax)
        cmovl_m32(assembler, Reg32(i), at(Reg64(i)))
        cmovl_m16(assembler, Reg16(i), at(Reg64(i)))
        cmovl_m64(assembler, Reg64(i), at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}

@test
test_cmovle_imm:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmovle(assembler, Reg32(i), eax)
        cmovle(assembler, Reg16(i), ax)
        cmovle(assembler, Reg64(i), rax)
        cmovle_m32(assembler, Reg32(i), at(Reg64(i)))
        cmovle_m16(assembler, Reg16(i), at(Reg64(i)))
        cmovle_m64(assembler, Reg64(i), at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}
@test
test_cmove_imm:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmove(assembler, Reg32(i), eax)
        cmove(assembler, Reg16(i), ax)
        cmove(assembler, Reg64(i), rax)
        cmove_m32(assembler, Reg32(i), at(Reg64(i)))
        cmove_m16(assembler, Reg16(i), at(Reg64(i)))
        cmove_m64(assembler, Reg64(i), at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}
@test
test_cmovg_imm:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmovg(assembler, Reg32(i), eax)
        cmovg(assembler, Reg16(i), ax)
        cmovg(assembler, Reg64(i), rax)
        cmovg_m32(assembler, Reg32(i), at(Reg64(i)))
        cmovg_m16(assembler, Reg16(i), at(Reg64(i)))
        cmovg_m64(assembler, Reg64(i), at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}

@test
test_cmovne_imm:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmovne(assembler, Reg32(i), eax)
        cmovne(assembler, Reg16(i), ax)
        cmovne(assembler, Reg64(i), rax)
        cmovne_m32(assembler, Reg32(i), at(Reg64(i)))
        cmovne_m16(assembler, Reg16(i), at(Reg64(i)))
        cmovne_m64(assembler, Reg64(i), at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}
