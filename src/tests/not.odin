package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"

@test
test_not_reg :: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        not(assembler, Reg64(i))
        not(assembler, Reg32(i))
        not(assembler, Reg16(i))
        not(assembler, Reg8(i))
        not_m8(assembler, at(Reg64(i), Reg64.Rcx, 32))
        not_m16(assembler, at(Reg64(i)))
        not_m32(assembler, at(Reg64(i)))
        not_m64(assembler, at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}


