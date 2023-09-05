package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"

@test
test_div_reg :: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        div(assembler, Reg64(i))
        div(assembler, Reg32(i))
        div(assembler, Reg16(i))
        div(assembler, Reg8(i))
        div_m8(assembler, at(Reg64(i), Reg64.Rcx, 32))
        div_m16(assembler, at(Reg64(i)))
        div_m32(assembler, at(Reg64(i)))
        div_m64(assembler, at(Reg64(i)))
        idiv(assembler, Reg64(i))
        idiv(assembler, Reg32(i))
        idiv(assembler, Reg16(i))
        idiv(assembler, Reg8(i))
        idiv_m8(assembler, at(Reg64(i), Reg64.Rcx, 32))
        idiv_m16(assembler, at(Reg64(i)))
        idiv_m32(assembler, at(Reg64(i)))
        idiv_m64(assembler, at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}
