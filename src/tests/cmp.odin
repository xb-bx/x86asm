package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"
@test
test_cmp_memory_imm :: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cmpsx(assembler, at(Reg64(i), Reg64.Rcx, 0xfff), i32(i))    
        cmp(assembler, at(Reg64(i), 0xfff), i32(i))    
        cmp(assembler, at(Reg64(i), 0xfff), i16(i))    
        cmp(assembler, at(Reg64(i), 0xfff), u8(i))    
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
test_cmp_register_to_memory :: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        for j in 0..=15 {
            if Reg64(j) == Reg64.Rsp || Reg64(j) == Reg64.R12 {continue}
            cmp(assembler, at(Reg64(i), Reg64(j), 32, 2), Reg64(j))
            cmp(assembler, at(Reg64(i), Reg64(j), 32, 2), Reg32(j))
            cmp(assembler, at(Reg64(i), Reg64(j), 16, 2), Reg16(j))
            cmp(assembler, at(Reg64(i), Reg64(j), 8, 2), Reg8(j))
        }
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
test_cmp_register_to_register :: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    defer { delete_asm(assembler); free(assembler) }
    for i in 0..=15 {
        for j in 0..=15 {
            cmp(assembler, Reg8(i), Reg8(j))
            cmp(assembler, Reg16(i), Reg16(j))
            cmp(assembler, Reg32(i), Reg32(j))
            cmp(assembler, Reg64(i), Reg64(j))
        }
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
        }
    }
}
@test
test_cmp_from_memory_at_sib_to_reg:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    defer { delete_asm(assembler); free(assembler) }
    for i in 0..=15 {
        for j in 0..=15 {
            if Reg64(j) == Reg64.Rsp || Reg64(j) == Reg64.R12 { continue }
            cmp(assembler, Reg8(i), at(Reg64(i), Reg64(j),  i32(i + j), 2))
            cmp(assembler, Reg16(i), at(Reg64(i), Reg64(j),  i32(i + j), 2))
            cmp(assembler, Reg32(i), at(Reg64(i), Reg64(j),  i32(i + j), 2))
            cmp(assembler, Reg64(i), at(Reg64(i), Reg64(j),  i32(i + j), 2))
        }
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
        }
    }
}
@test
test_cmp_from_memory_at_register_to_reg:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    defer { delete_asm(assembler); free(assembler) }
    for i in 0..=15 {
        for j in 0..=15 {
            cmp(assembler, Reg8(i), at(Reg64(j), i32(i + j)))
            cmp(assembler, Reg16(i), at(Reg64(j), i32(i + j)))
            cmp(assembler, Reg32(i), at(Reg64(j), i32(i + j)))
            cmp(assembler, Reg64(i), at(Reg64(j), i32(i + j)))
            cmp(assembler, Reg8(i), 42)
            cmp(assembler, Reg16(i), 42)
            cmp(assembler, Reg32(i), 42)
            cmpsx(assembler, Reg64(i), 42)

        }
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
        }
    }
}

