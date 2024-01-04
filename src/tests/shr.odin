
package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"
@test
test_shr_cl:: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        shr_reg16_cl(assembler, Reg16(i))
        shr_reg32_cl(assembler, Reg32(i))
        shr_reg64_cl(assembler, Reg64(i))
        sar_reg16_cl(assembler, Reg16(i))
        sar_reg32_cl(assembler, Reg32(i))
        sar_reg64_cl(assembler, Reg64(i))

    }
    splited := strings.split(run_rasm_and_read_stdout(assembler.bytes[:]), SPLITTER)
    for str,i in splited {
        if !assert(splited[i] == assembler.mnemonics[i]) {
            fmt.println(splited[i], assembler.mnemonics[i], assembler.bytes[:])
            panic("")
        }
    }
}
