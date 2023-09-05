package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"
@test
test_subss:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        subss_xmm_xmm(assembler, Xmm(i), Xmm(i))
        subss_xmm_mem32(assembler, Xmm(i), at(rax))
        subsd_xmm_xmm(assembler, Xmm(i), Xmm(i))
        subsd_xmm_mem64(assembler, Xmm(i), at(rax))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}
