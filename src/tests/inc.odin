package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "base:intrinsics"
import "core:strings"
import "x86asm:x86asm"

@test
test_inc_reg :: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        inc(assembler, Reg64(i))
        inc(assembler, Reg32(i))
        inc(assembler, Reg16(i))
        inc(assembler, Reg8(i))
        inc_m8(assembler, at(Reg64(i), Reg64.Rcx, 32))
        inc_m16(assembler, at(Reg64(i)))
        inc_m32(assembler, at(Reg64(i)))
        inc_m64(assembler, at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}


