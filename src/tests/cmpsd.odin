#+feature using-stmt
package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "base:intrinsics"
import "core:strings"
import "x86asm:x86asm"
@test
test_cmpsd :: proc(t: ^testing.T) {
    using x86asm
    set_formatter()   
    context.user_ptr = t
    assembler := make_asm()
    for i in 0..=15 {
        for j in 0..=15 {
            cmpeqsd(assembler, Xmm(i), Xmm(j))
            cmpeqsd(assembler, Xmm(i), at(Reg64(j)))
            cmpneqsd(assembler, Xmm(i), Xmm(j))
            cmpneqsd(assembler, Xmm(i), at(Reg64(j)))
            cmplesd(assembler, Xmm(i), Xmm(j))
            cmplesd(assembler, Xmm(i), at(Reg64(j)))
            cmpltsd(assembler, Xmm(i), Xmm(j))
            cmpltsd(assembler, Xmm(i), at(Reg64(j)))
            cmpnlesd(assembler, Xmm(i), Xmm(j))
            cmpnlesd(assembler, Xmm(i), at(Reg64(j)))
            cmpnltsd(assembler, Xmm(i), Xmm(j))
            cmpnltsd(assembler, Xmm(i), at(Reg64(j)))
            cmpunordsd(assembler, Xmm(i), Xmm(j))
            cmpunordsd(assembler, Xmm(i), at(Reg64(j)))
            cmpordsd(assembler, Xmm(i), Xmm(j))
            cmpordsd(assembler, Xmm(i), at(Reg64(j)))
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
