#+feature using-stmt
package example
import "core:fmt"

import "x86asm:x86asm"
import "core:mem/virtual"
main :: proc() {
    using x86asm
    assembler: Assembler = {}
    init_asm(&assembler, true)
    when ODIN_OS == .Windows {
        first_arg_reg := rcx
    } else {
        first_arg_reg := rdi
    }

    mov(&assembler, rax, first_arg_reg)
    add(&assembler, rax, rax)
    ret(&assembler)

    fn := alloc_executable(len(assembler.bytes))
    for b,i in assembler.bytes {
        fn[i] = b
    }

    res := (transmute(proc "c" (var: int) -> int)fn)(100)
    fmt.println(res)


}

alloc_executable :: proc(size: uint) -> [^]u8 {
    size := size
    data, err := virtual.memory_block_alloc(size, size, {})
    if err != virtual.Allocator_Error.None {
        panic("Failed to allocate executable memory")
    }
    prot := transmute(rawptr)(transmute(int)data.base & ~int(0xfff))
    ok := virtual.protect(prot, data.reserved, { virtual.Protect_Flag.Read, virtual.Protect_Flag.Write, virtual.Protect_Flag.Execute})
    if !ok {
        panic("Failed to allocate executable memory")
    }
    return data.base
}

