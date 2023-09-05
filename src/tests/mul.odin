package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"

@test
test_mul_reg :: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        mul(assembler, Reg64(i))
        mul(assembler, Reg32(i))
        mul(assembler, Reg16(i))
        mul(assembler, Reg8(i))
        mul_m8(assembler, at(Reg64(i), Reg64.Rcx, 32))
        mul_m16(assembler, at(Reg64(i)))
        mul_m32(assembler, at(Reg64(i)))
        mul_m64(assembler, at(Reg64(i)))
        imul(assembler, Reg64(i))
        imul(assembler, Reg32(i))
        imul(assembler, Reg16(i))
        imul(assembler, Reg8(i))
        imul_m8(assembler, at(Reg64(i), Reg64.Rcx, 32))
        imul_m16(assembler, at(Reg64(i)))
        imul_m32(assembler, at(Reg64(i)))
        imul_m64(assembler, at(Reg64(i)))
        imul(assembler, Reg64(i), Reg64(i))
        imul(assembler, Reg32(i), Reg32(i))
        imul(assembler, Reg16(i), Reg16(i))
        imul(assembler, Reg64(i), at(Reg64(i)))
        imul(assembler, Reg32(i), at(Reg64(i)))
        imul(assembler, Reg16(i), at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}


