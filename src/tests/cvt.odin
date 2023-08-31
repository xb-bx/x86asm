
package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"
@test
test_cvtss2sd:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cvtss2sd_xmm_xmm(assembler, Xmm(i), Xmm(i))
        cvtss2sd_xmm_mem32(assembler, Xmm(i), at(Reg64(i)))
        cvtsd2ss_xmm_xmm(assembler, Xmm(i), Xmm(i))
        cvtsd2ss_xmm_mem64(assembler, Xmm(i), at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), "\n")
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}
@test
test_cvttss_sd_2si:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        cvttsd2si_reg32_xmm(assembler, Reg32(i), Xmm(i))
        cvttsd2si_reg32_mem32(assembler, Reg32(i), at(Reg64(i)))
        cvttsd2si_reg64_xmm(assembler, Reg64(i), Xmm(i))
        cvttsd2si_reg64_mem64(assembler, Reg64(i), at(Reg64(i)))
        cvttss2si_reg32_xmm(assembler, Reg32(i), Xmm(i))
        cvttss2si_reg32_mem32(assembler, Reg32(i), at(Reg64(i)))
        cvttss2si_reg64_xmm(assembler, Reg64(i), Xmm(i))
        cvttss2si_reg64_mem64(assembler, Reg64(i), at(Reg64(i)))
    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), "\n")
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}
