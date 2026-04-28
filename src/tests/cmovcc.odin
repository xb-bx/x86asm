#+feature using-stmt
package test
import "core:testing"
import os "core:os/old"
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

@test
test_cmovbe_imm:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmovbe(assembler, Reg32(i), eax)
        cmovbe(assembler, Reg16(i), ax)
        cmovbe(assembler, Reg64(i), rax)
        cmovbe_m32(assembler, Reg32(i), at(Reg64(i)))
        cmovbe_m16(assembler, Reg16(i), at(Reg64(i)))
        cmovbe_m64(assembler, Reg64(i), at(Reg64(i)))
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
test_cmovb_imm:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmovb(assembler, Reg32(i), eax)
        cmovb(assembler, Reg16(i), ax)
        cmovb(assembler, Reg64(i), rax)
        cmovb_m32(assembler, Reg32(i), at(Reg64(i)))
        cmovb_m16(assembler, Reg16(i), at(Reg64(i)))
        cmovb_m64(assembler, Reg64(i), at(Reg64(i)))
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
test_cmova_imm:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmova(assembler, Reg32(i), eax)
        cmova(assembler, Reg16(i), ax)
        cmova(assembler, Reg64(i), rax)
        cmova_m32(assembler, Reg32(i), at(Reg64(i)))
        cmova_m16(assembler, Reg16(i), at(Reg64(i)))
        cmova_m64(assembler, Reg64(i), at(Reg64(i)))
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
test_cmovae_imm:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmovae(assembler, Reg32(i), eax)
        cmovae(assembler, Reg16(i), ax)
        cmovae(assembler, Reg64(i), rax)
        cmovae_m32(assembler, Reg32(i), at(Reg64(i)))
        cmovae_m16(assembler, Reg16(i), at(Reg64(i)))
        cmovae_m64(assembler, Reg64(i), at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}
