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
test_movq:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        for j in 0..=15 {
            movq_xmm_reg64(assembler, Xmm(i), Reg64(j))
            movd_xmm_reg32(assembler, Xmm(i), Reg32(j))
            movq_reg64_xmm(assembler, Reg64(j), Xmm(i))
            movd_reg32_xmm(assembler, Reg32(j), Xmm(i))
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
