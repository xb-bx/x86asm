package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"

@test
test_push_reg :: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        push_r64(assembler, Reg64(i))
        push_r16(assembler, Reg16(i))
        push_memory(assembler, at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), "\n")
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}


