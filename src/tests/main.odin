package test
import "core:testing"
import "core:os"
import "core:fmt"
import "core:mem"
import "base:intrinsics"
import "core:strings"
import "x86asm:x86asm"
import "core:sys/windows"
import "core:sys/linux"
import "core:thread"
import "core:time"
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
    pipes: [2]linux.Fd
    linux.pipe2(&pipes, {})

    pid, err := os.fork()
    
    if pid == 0 {
        linux.close(pipes[0])
        linux.dup2(pipes[1], linux.Fd(os.stdout))
        //args := [2]string {"-c", "cat main.odin"} 
        args := [2]string {"-c", fmt.aprintf("rasm2 -d %v", assembled)}
        assert(os.execvp("/bin/bash", args[:]) == 0)
        return ""
    }
    else {
        linux.close(pipes[1])
        // For some reason odin standard lib does not have wait for pid function
        SYS_waitid :: 247
        a, _ := mem.alloc(1024)
        res := make([dynamic]u8)
        n := 1    
        err := os.ERROR_NONE

        for n > 0 {
            buf := [8024]u8{}
            n, err = os.read(os.Handle(pipes[0]), buf[:])
            append(&res, ..buf[:n])
        }
        result := strings.clone_from_bytes(res[:])
        code := intrinsics.syscall(SYS_waitid, 1, uintptr(pid), 0, 4, uintptr(a))
        mem.free(a)
        return strings.trim(strings.trim(result, " \n\r"), " \n\r")
    }
    //pid, err := os.fork()
    //fmt.println(err)
    //assert(err == os.ERROR_NONE)
    //pipes: [2]linux.Fd
    //linux.pipe2(&pipes)
    
    //if pid == 0 {
        //linux.close(pipes[0])
        //linux.dup2(pipes[1], )
        //args := [2]string {"-c", fmt.aprintf("rasm2 -d %v > %s", assembled, outname)}
        //assert(os.execvp("/bin/bash", args[:]) == 0)
    //}
    //else {
        //// For some reason odin standard lib does not have wait for pid function
        //SYS_waitid :: 247
        //a, _ := mem.alloc(1024)
        
        //code := intrinsics.syscall(SYS_waitid, 1, uintptr(pid), 0, 4, uintptr(a))
        //mem.free(a)
    //}
}


}
