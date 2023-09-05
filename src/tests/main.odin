package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "core:intrinsics"
import "core:strings"
import "x86asm:x86asm"
import "core:sys/windows"
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
when ODIN_OS == .Windows {
    SPLITTER :: "\r\n"
    run_rasm_and_read_stdout :: proc(assembled: []u8) -> string {
        using strings
        start_info := windows.STARTUPINFOW {}
        proc_info := windows.PROCESS_INFORMATION {}
        f, err := os.open("out.txt", os.O_CREATE | os.O_TRUNC)
        if err != 0 {
            panic("")
        }
        start_info.cb = size_of(windows.STARTUPINFOW)
        start_info.dwFlags |= windows.STARTF_USESTDHANDLES
        start_info.hStdOutput = windows.HANDLE(f)
        cmdline := fmt.aprintf("rasm2 -d %v", assembled)
        ok := windows.CreateProcessW(nil, windows.utf8_to_wstring(cmdline), nil, nil, true, 0, nil, nil, &start_info, &proc_info)
        windows.WaitForSingleObject(proc_info.hProcess, windows.INFINITE)
        exitcode: windows.DWORD = 0
        os.close(f)
        bytes, fok := os.read_entire_file("out.txt")
        assert(fok)
        res, cok := strings.clone_from_bytes(bytes)
        assert(cok == .None)
        ress := strings.trim(res, " \n\r")
        return strings.trim(ress, " \r\n")
    }
}
else {
SPLITTER :: "\n"
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
    return strings.trim(strings.trim(res, " \n\r"), " \n\r")
}


}
