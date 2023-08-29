package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"
Assembler :: x86asm.Assembler
Reg64 :: x86asm.Reg64
Reg32 :: x86asm.Reg32
Reg16 :: x86asm.Reg16
Reg8 :: x86asm.Reg8
make_asm :: proc() -> ^Assembler {
    using x86asm
    a := new(Assembler)
    init_asm(a, true)
    return a
}

run_rasm_and_read_stdout :: proc(assembled: []u8) -> string {
    pid, err := os.fork()
    assert(err == os.ERROR_NONE)
    if pid == 0 {
        args := [2]string {"-c", fmt.aprintf("rasm2 -d %v > out.txt", assembled)}
        assert(os.execvp("/bin/bash", args[:]) == 0)
    }
    else {
        // For some reason odin standard lib does not have wait for pid function
        SYS_waitid :: 247
        a, _ := mem.alloc(1024)
        
        code := intrinsics.syscall(SYS_waitid, 1, uintptr(pid), 0, 4, uintptr(a))
        mem.free(a)
    }
    bytes, fok := os.read_entire_file("out.txt")
    assert(fok)
    res, ok := strings.clone_from_bytes(bytes)
    assert(ok == .None)
    return strings.trim(res, " \n\r")
}

