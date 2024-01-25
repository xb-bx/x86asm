package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"
@test
test_movss:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        for j in 0..=15 {
            movss_xmm_xmm(assembler, Xmm(i), Xmm(i))
            movss_xmm_mem32(assembler, Xmm(i), at(rax))
            movss_mem32_xmm(assembler, at(Reg64(j)), Xmm(i))
            movsd_xmm_xmm(assembler, Xmm(i), Xmm(i))
            movsd_xmm_mem64(assembler, Xmm(i), at(Reg64(j)))
            movsd_mem64_xmm(assembler, at(Reg64(j)), Xmm(i))
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
