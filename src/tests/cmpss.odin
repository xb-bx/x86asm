package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"
@test
test_cmpss :: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        for j in 0..=15 {
            cmpeqss(assembler, Xmm(i), Xmm(j))
            cmpeqss(assembler, Xmm(i), at(Reg64(j)))
            cmpneqss(assembler, Xmm(i), Xmm(j))
            cmpneqss(assembler, Xmm(i), at(Reg64(j)))
            cmpless(assembler, Xmm(i), Xmm(j))
            cmpless(assembler, Xmm(i), at(Reg64(j)))
            cmpltss(assembler, Xmm(i), Xmm(j))
            cmpltss(assembler, Xmm(i), at(Reg64(j)))
            cmpnless(assembler, Xmm(i), Xmm(j))
            cmpnless(assembler, Xmm(i), at(Reg64(j)))
            cmpnltss(assembler, Xmm(i), Xmm(j))
            cmpnltss(assembler, Xmm(i), at(Reg64(j)))
            cmpunordss(assembler, Xmm(i), Xmm(j))
            cmpunordss(assembler, Xmm(i), at(Reg64(j)))
            cmpordss(assembler, Xmm(i), Xmm(j))
            cmpordss(assembler, Xmm(i), at(Reg64(j)))
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
