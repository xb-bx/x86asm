package x86asm
import "core:fmt"
import "core:strings"
import "core:testing"
when ODIN_TEST {
    assert :: proc(b: bool, loc := #caller_location) -> bool {
        t := transmute(^testing.T)context.user_ptr 
        if !b {
            fmt.println(loc)
            testing.fail(t)
        }
        return b
    }
}

Label :: struct {
    id: int,
    offset: int,
}
Tuple :: struct($T1, $T2: typeid) {
    first: T1,
    second: T2,
}
tuple :: proc(fst: $T1, snd: $T2) -> Tuple(T1, T2) {
    return Tuple(T1, T2) { first = fst, second = snd }
}
Assembler :: struct {
    bytes: [dynamic]u8,
    labels: [dynamic]Label,
    labelplaces: [dynamic]Tuple(int, int),
    mnemonics: [dynamic]string,
}
init_asm :: proc(using assembler: ^Assembler, remember_mnemonics: bool = false) {
    bytes = make([dynamic]u8, 0, 128)
    labels = make([dynamic]Label, 0, 16)
    labelplaces = make([dynamic]Tuple(int, int), 0, 16)
    if remember_mnemonics {
        mnemonics = make([dynamic]string)
    }
}


create_label :: proc(using assembler: ^Assembler) -> Label {
    lbl := Label { id = len(labels), offset = 0 }
    append(&labels, lbl)
    return lbl
}
set_label :: proc(using assembler: ^Assembler, lbl: Label) {
    lbl := &labels[lbl.id]    
    lbl.offset = len(bytes)
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("label_%i:", lbl.id)) }
}
ret :: proc(using assembler: ^Assembler) {
    append(&bytes, 0xc3)
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("ret")) }
}
int3 :: proc(using assembler: ^Assembler) {
    append(&bytes, 0xcc)
    if mnemonics != nil { append(&mnemonics, fmt.aprintf("int3")) }
}
assemble :: proc(using assebler: ^Assembler) {
    for place in labelplaces {
        lbl := labels[place.first]
        offset := lbl.offset - ((place.second) + 4)
        bytes[place.second + 3] = cast(u8)(offset >> 24)
        bytes[place.second + 2] = cast(u8)(offset >> 16)
        bytes[place.second + 1] = cast(u8)(offset >> 8)
        bytes[place.second + 0] = cast(u8)(offset)
    }
}


@(private)
can_memory_be_encoded_with_modrm :: proc(using memory: Memory) -> bool {
    if base == nil {
        return false
    }
    basereg := base.(Reg64)
    return index == nil && scale == 1 &&
        basereg != Reg64.Rsp && basereg != Reg64.R12
        
}
@(private)
extend_rex_if_needed :: proc(rex: RexPrefix, op1: int, op2: int) -> RexPrefix {
    res := rex
    if op1 > 7 {
        res |= { .R }
    }
    if op2 > 7 {
        res |= { .B }
    }
    return res
}
@(private)
OLD_PREFIX :: 0x66
@(private)
encode_mod_rm :: proc(enc:  OperandEncoding, dest: int, src:int) -> u8 {
    switch enc {
        case .MR:
            res :u8= 0
            res |= u8(dest) & 7
            res |= (u8(src) & 7) << 3
            return res
        case .MI:
            return u8(dest) & 7 
        case .RM:
            res :u8= 0
            res |= u8(src) & 7
            res |= (u8(dest) & 7) << 3
            return res
        case: panic("SHOULD NOT HAPPEN")
        
    }
    return 0
}

@(private)
generic_from_reg_to_memory_sib :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, openc: OperandEncoding, dest: Memory, src: int) {
    assert(openc != .MI)
    assert(dest.scale == 1 || dest.scale == 2 || dest.scale == 4 || dest.scale == 8)
    if dest.index != nil {
        assert(dest.index.(Reg64) != Reg64.Rsp)
    }
    base := dest.base.(Reg64)
    disp_size := 1
    if abs(dest.offset) > 127 {
        disp_size = 4 
    }

    rex := extend_rex_if_needed(rex, src, 0) 
    modrm: u8 = (disp_size == 1 ? 0b01_00_0000 : 0b10_00_0000) | u8(Reg64.Rsp)
    if u8(base) & 7 == u8(Reg64.Rsp) && dest.index == nil {
        modrm = u8(Reg64.Rsp)
        if disp_size == 4 {
            modrm |= 0x80
        }
        else {
            modrm |= 0x40
        }
        if u8(base) > 7 {
            rex |= { .B }
        }
        if old {
            append(&bytes, OLD_PREFIX)
        }
        if transmute(u8)rex != 0 {
            append(&bytes, (transmute(u8)rex) | 0x40)
        }
        for i in 0..<opcode.size {
            append(&bytes, opcode.bytes[i])
        }
        modrm |= u8(src & 7) << 3
        append(&bytes, modrm)
        append(&bytes, 0x24)
        switch disp_size {
            case 1:
                append(&bytes, u8(dest.offset & 0xff))
            case 4:
                offset := dest.offset
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
        }
        return
    }
    index := dest.index.(Reg64)
    modrm |= u8(src & 7) << 3
    modrm |= u8(Reg64.Rsp)
    if u8(index) > 7 {
        rex |= {.X}
    }
    if u8(base) > 7 {
        rex |= {.B}
    }
    scale := 0
    switch dest.scale {
        case 1:
            scale = 0
        case 2:
            scale = 1
        case 4:
            scale = 2
        case 8:
            scale = 3
    }
    sib :u8= (u8(scale & 0b11) << 6) |  
        ((u8(index) & 7) << 3) |
        ((u8(base) & 7))
    if old {
        append(&bytes, OLD_PREFIX)
    }
    if transmute(u8)rex != 0 {
        append(&bytes, (transmute(u8)rex) | 0x40)
    }
    for i in 0..<opcode.size {
        append(&bytes, opcode.bytes[i])
    }
    append(&bytes, modrm)
    append(&bytes, sib)
    switch disp_size {
        case 1:
            append(&bytes, u8(dest.offset & 0xff))
        case 4:
            offset := dest.offset
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
    }

}
@(private)
generic_from_memory_sib_to_reg :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, openc: OperandEncoding, dest: int, src: Memory) {
    assert(openc != .MI)
    assert(src.scale == 1 || src.scale == 2 || src.scale == 4 || src.scale == 8)
    if src.index != nil {
        assert(src.index.(Reg64) != Reg64.Rsp)
    }
    base := src.base.(Reg64)
    disp_size := 1
    if abs(src.offset) > 127 {
        disp_size = 4 
    }

    rex := extend_rex_if_needed(rex, dest, 0) 
    modrm: u8 = (disp_size == 1 ? 0b01_00_0000 : 0b10_00_0000) | u8(Reg64.Rsp)
    if u8(base) & 7 == u8(Reg64.Rsp) && src.index == nil {
        modrm = u8(Reg64.Rsp)
        if disp_size == 4 {
            modrm |= 0x80
        }
        else {
            modrm |= 0x40
        }
        if u8(base) > 7 {
            rex |= { .B }
        }
        if old {
            append(&bytes, OLD_PREFIX)
        }
        if transmute(u8)rex != 0 {
            append(&bytes, (transmute(u8)rex) | 0x40)
        }
        for i in 0..<opcode.size {
            append(&bytes, opcode.bytes[i])
        }
        modrm |= u8(dest & 7)  << 3
        append(&bytes, modrm)
        append(&bytes, 0x24)
        
        switch disp_size {
            case 1:
                append(&bytes, u8(src.offset & 0xff))
            case 4:
                offset := src.offset
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
        }
        return
    }
    index := src.index.(Reg64)
    if openc == .RM {
        modrm |= u8(dest & 7) << 3
    }
    if u8(index) > 7 {
        rex |= {.X}
    }
    if u8(base) > 7 {
        rex |= {.B}
    }
    scale := 0
    switch src.scale {
        case 1:
            scale = 0
        case 2:
            scale = 1
        case 4:
            scale = 2
        case 8:
            scale = 3
    }
    sib :u8= (u8(scale & 0b11) << 6) |  
        ((u8(index) & 7) << 3) |
        ((u8(base) & 7))
    if old {
        append(&bytes, OLD_PREFIX)
    }
    if transmute(u8)rex != 0 {
        append(&bytes, (transmute(u8)rex) | 0x40)
    }
    for i in 0..<opcode.size {
        append(&bytes, opcode.bytes[i])
    }
    append(&bytes, modrm)
    append(&bytes, sib)
    switch disp_size {
        case 1:
            append(&bytes, u8(src.offset & 0xff))
        case 4:
            offset := src.offset
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
    }

}
@(private)
generic_from_memory_sib :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, src: Memory) {
    assert(src.scale == 1 || src.scale == 2 || src.scale == 4 || src.scale == 8)
    if src.index != nil {
        assert(src.index.(Reg64) != Reg64.Rsp)
    }
    base := src.base.(Reg64)
    disp_size := 1
    if abs(src.offset) > 127 {
        disp_size = 4 
    }

    rex := rex
    modrm: u8 = (disp_size == 1 ? 0b01_00_0000 : 0b10_00_0000) | u8(Reg64.Rsp)
    if u8(base) & 7 == u8(Reg64.Rsp) && src.index == nil {
        modrm = u8(Reg64.Rsp)
        if disp_size == 4 {
            modrm |= 0x80
        }
        else {
            modrm |= 0x40
        }
        if u8(base) > 7 {
            rex |= { .B }
        }
        if old {
            append(&bytes, OLD_PREFIX)
        }
        if transmute(u8)rex != 0 {
            append(&bytes, (transmute(u8)rex) | 0x40)
        }
        for i in 0..<opcode.size {
            append(&bytes, opcode.bytes[i])
        }
        append(&bytes, modrm | ((opcode.modrm_ext & 7) << 3))
        append(&bytes, 0x24)
        
        switch disp_size {
            case 1:
                append(&bytes, u8(src.offset & 0xff))
            case 4:
                offset := src.offset
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
        }
        return
    }
    index := src.index.(Reg64)
    if u8(index) > 7 {
        rex |= {.X}
    }
    if u8(base) > 7 {
        rex |= {.B}
    }
    scale := 0
    switch src.scale {
        case 1:
            scale = 0
        case 2:
            scale = 1
        case 4:
            scale = 2
        case 8:
            scale = 3
    }
    sib :u8= (u8(scale & 0b11) << 6) |  
        ((u8(index) & 7) << 3) |
        ((u8(base) & 7))
    if old {
        append(&bytes, OLD_PREFIX)
    }
    if transmute(u8)rex != 0 {
        append(&bytes, (transmute(u8)rex) | 0x40)
    }
    for i in 0..<opcode.size {
        append(&bytes, opcode.bytes[i])
    }
    append(&bytes, modrm | ((opcode.modrm_ext & 7) << 3))
    append(&bytes, sib)
    switch disp_size {
        case 1:
            append(&bytes, u8(src.offset & 0xff))
        case 4:
            offset := src.offset
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
    }

}
@(private)
generic_from_memory_modrm :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, src: Memory) {
    rex := extend_rex_if_needed(rex, 0, int(src.base.(Reg64))) 
    if old {
        append(&bytes, OLD_PREFIX)
    }
    if transmute(u8)(rex) != 0 {
        append(&bytes, (transmute(u8)rex) | 0x40)
    }
    for i in 0..<opcode.size {
        append(&bytes, opcode.bytes[i])
    }
    modrm :u8= 0
    offset_size := 0
    rbpdisp := false
    if src.offset == 0 {
        base := src.base.(Reg64)
        modrm = encode_mod_rm(.RM, 0, int(src.base.(Reg64)))
        if base == Reg64.Rbp || base == Reg64.R13 {
            rbpdisp = true      
            modrm |= 0b01_00_0000
        }
        
        offset_size = 0
    } else if abs(src.offset) <= 127 {
        modrm = 0b01_00_0000 | encode_mod_rm(.RM, 0, int(src.base.(Reg64)))
        offset_size = 1
    } else {
        modrm = 0b10_00_0000 | encode_mod_rm(.RM, 0, int(src.base.(Reg64)))
        offset_size = 4
    }
    append(&bytes, modrm | ((opcode.modrm_ext & 7) << 3))
    switch offset_size {
        case 0:
            if rbpdisp {
                append(&bytes,0) 
            }
        case 1:
            append(&bytes, u8(src.offset & 0xff))
        case 4:
            offset := src.offset
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
    }
    
}
@(private)
generic_from_memory_modrm_to_reg :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, openc: OperandEncoding, dest: int, src: Memory) {
    assert(openc != .MI)
    rex := extend_rex_if_needed(rex, dest, int(src.base.(Reg64))) 
    if old {
        append(&bytes, OLD_PREFIX)
    }
    if transmute(u8)(rex) != 0 {
        append(&bytes, (transmute(u8)rex) | 0x40)
    }
    for i in 0..<opcode.size {
        append(&bytes, opcode.bytes[i])
    }
    modrm :u8= 0
    offset_size := 0
    rbpdisp := false
    if src.offset == 0 {
        base := src.base.(Reg64)
        modrm = encode_mod_rm(openc, dest, int(src.base.(Reg64)))
        if base == Reg64.Rbp || base == Reg64.R13 {
            rbpdisp = true      
            modrm |= 0b01_00_0000
        }
        
        offset_size = 0
    } else if abs(src.offset) <= 127 {
        modrm = 0b01_00_0000 | encode_mod_rm(openc, dest, int(src.base.(Reg64)))
        offset_size = 1
    } else {
        modrm = 0b10_00_0000 | encode_mod_rm(openc, dest, int(src.base.(Reg64)))
        offset_size = 4
    }
    append(&bytes, modrm)
    switch offset_size {
        case 0:
            if rbpdisp {
                append(&bytes,0) 
            }
        case 1:
            append(&bytes, u8(src.offset & 0xff))
        case 4:
            offset := src.offset
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
    }
    
}
@(private)
generic_from_reg_to_memory_modrm :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, openc: OperandEncoding, dest: Memory, src: int) {
    assert(openc != .MI)
    rex := extend_rex_if_needed(rex, src, int(dest.base.(Reg64))) 
    if old {
        append(&bytes, OLD_PREFIX)
    }
    if transmute(u8)(rex) != 0 {
        append(&bytes, (transmute(u8)rex) | 0x40)
    }
    for i in 0..<opcode.size {
        append(&bytes, opcode.bytes[i])
    }
    modrm :u8= 0
    offset_size := 0
    rbpdisp := false
    if dest.offset == 0 {
        base := dest.base.(Reg64)
        modrm = encode_mod_rm(openc, int(dest.base.(Reg64)), src)
        if base == Reg64.Rbp || base == Reg64.R13 {
            rbpdisp = true      
            modrm |= 0b01_00_0000
        }
        
        offset_size = 0
    } else if abs(dest.offset) <= 127 {
        modrm = 0b01_00_0000 | encode_mod_rm(openc, int(dest.base.(Reg64)), src)
        offset_size = 1
    } else {
        modrm = 0b10_00_0000 | encode_mod_rm(openc, int(dest.base.(Reg64)), src)
        offset_size = 4
    }
    append(&bytes, modrm)
    switch offset_size {
        case 0:
            if rbpdisp {
                append(&bytes,0) 
            }
        case 1:
            append(&bytes, u8(dest.offset & 0xff))
        case 4:
            offset := dest.offset
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
    }
    
}

@(private)
generic_from_imm_to_memory_sib :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, dest: Memory, src: int, imm_size: int) {
    assert(dest.scale == 1 || dest.scale == 2 || dest.scale == 4 || dest.scale == 8)
    if dest.index != nil {
        assert(dest.index.(Reg64) != Reg64.Rsp)
    }
    base := dest.base.(Reg64)
    disp_size := 1
    if abs(dest.offset) > 127 {
        disp_size = 4 
    }
    rex := rex
    modrm: u8 = (disp_size == 1 ? 0b01_00_0000 : 0b10_00_0000) | u8(Reg64.Rsp)| u8(opcode.modrm_ext & 7) << 3
    if u8(base) & 7 == u8(Reg64.Rsp) && dest.index == nil {
        modrm = u8(Reg64.Rsp) | u8(opcode.modrm_ext & 7) << 3
        if disp_size == 4 {
            modrm |= 0x80
        }
        else {
            modrm |= 0x40
        }
        if u8(base) > 7 {
            rex |= { .B }
        }
        if old {
            append(&bytes, OLD_PREFIX)
        }
        if transmute(u8)rex != 0 {
            append(&bytes, (transmute(u8)rex) | 0x40)
        }
        for i in 0..<opcode.size {
            append(&bytes, opcode.bytes[i])
        }
        append(&bytes, modrm)
        append(&bytes, 0x24)
        
        switch disp_size {
            case 1:
                append(&bytes, u8(dest.offset & 0xff))
            case 4:
                offset := dest.offset
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
                offset >>= 8
                append(&bytes, cast(u8)(offset & 0xff))
        }
        imm := src
        for i in 0..=imm_size-1 {
            append(&bytes, cast(u8)(imm & 0xff))
            imm >>= 8
        }
        return
    }
    index := dest.index.(Reg64)
    modrm |= u8(Reg64.Rsp)
    if u8(index) > 7 {
        rex |= {.X}
    }
    if u8(base) > 7 {
        rex |= {.B}
    }
    scale := 0
    switch dest.scale {
        case 1:
            scale = 0
        case 2:
            scale = 1
        case 4:
            scale = 2
        case 8:
            scale = 3
    }
    sib :u8= (u8(scale & 0b11) << 6) |  
        ((u8(index) & 7) << 3) |
        ((u8(base) & 7))
    if old {
        append(&bytes, OLD_PREFIX)
    }
    if transmute(u8)rex != 0 {
        append(&bytes, (transmute(u8)rex) | 0x40)
    }
    for i in 0..<opcode.size {
        append(&bytes, opcode.bytes[i])
    }
    append(&bytes, modrm)
    append(&bytes, sib)
    switch disp_size {
        case 1:
            append(&bytes, u8(dest.offset & 0xff))
        case 4:
            offset := dest.offset
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
    }
    imm := src
    for i in 0..=imm_size-1 {
        append(&bytes, cast(u8)(imm & 0xff))
        imm >>= 8
    }

}
@(private)
generic_from_imm_to_memory_modrm :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, dest: Memory, src: int, imm_size: int) {
    rex := extend_rex_if_needed(rex, 0, int(dest.base.(Reg64))) 
    if old {
        append(&bytes, OLD_PREFIX)
    }
    if transmute(u8)(rex) != 0 {
        append(&bytes, (transmute(u8)rex) | 0x40)
    }
    for i in 0..<opcode.size {
        append(&bytes, opcode.bytes[i])
    }
    modrm :u8= 0
    offset_size := 0
    rbpdisp := false
    if dest.offset == 0 {
        base := dest.base.(Reg64)
        modrm = encode_mod_rm(.MI, int(dest.base.(Reg64)), 0) | u8(opcode.modrm_ext & 7) << 3
        if base == Reg64.Rbp || base == Reg64.R13 {
            rbpdisp = true      
            modrm |= 0b01_00_0000
        }
        
        offset_size = 0
    } else if abs(dest.offset) <= 127 {
        modrm = 0b01_00_0000 | encode_mod_rm(.MI, int(dest.base.(Reg64)), 0) | u8(opcode.modrm_ext & 7) << 3
        offset_size = 1
    } else {
        modrm = 0b10_00_0000 | encode_mod_rm(.MI, int(dest.base.(Reg64)), 0) | u8(opcode.modrm_ext & 7) << 3
        offset_size = 4
    }
    append(&bytes, modrm)
    switch offset_size {
        case 0:
            if rbpdisp {
                append(&bytes,0) 
            }
        case 1:
            append(&bytes, u8(dest.offset & 0xff))
        case 4:
            offset := dest.offset
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
            offset >>= 8
            append(&bytes, cast(u8)(offset & 0xff))
    }
    imm := src
    for i in 0..=imm_size-1 {
        append(&bytes, cast(u8)(imm & 0xff))
        imm >>= 8
    }
    
}
@(private)
generic_from_imm_to_memory :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, dest: Memory, src: int, imm_size: int) {
    if can_memory_be_encoded_with_modrm(dest) {
        generic_from_imm_to_memory_modrm(assembler, rex, old, opcode, dest, src, imm_size)
    }
    else {
        generic_from_imm_to_memory_sib(assembler, rex, old, opcode, dest, src, imm_size)
    }
}
@(private)
generic_from_reg_to_memory :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, openc: OperandEncoding, dest: Memory, src: int) {
    if can_memory_be_encoded_with_modrm(dest) {
        generic_from_reg_to_memory_modrm(assembler, rex, old, opcode, openc, dest, src)
    }
    else {
        generic_from_reg_to_memory_sib(assembler, rex, old, opcode, openc, dest, src)
    }
}
@(private)
generic_from_memory :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, src: Memory) {
    if can_memory_be_encoded_with_modrm(src) {
        generic_from_memory_modrm(assembler, rex, old, opcode, src)
    }
    else {
        generic_from_memory_sib(assembler, rex, old, opcode, src)
    }
}
@(private)
generic_from_memory_to_reg :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, openc: OperandEncoding, dest: int, src: Memory) {
//     fmt.println(src)
    if can_memory_be_encoded_with_modrm(src) {
        generic_from_memory_modrm_to_reg(assembler, rex, old, opcode, openc, dest, src)
    }
    else {
        generic_from_memory_sib_to_reg(assembler, rex, old, opcode, openc, dest, src)
    }
}
@(private)
generic_opcode_reg :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, src: int) {
    rex := extend_rex_if_needed(rex, 0, src)
    assert(opcode.size == 1)
    if old { append(&bytes, OLD_PREFIX) }
    if rex != {} { append(&bytes, transmute(u8)(rex | {.Rex})) }
    append(&bytes, opcode.bytes[0] | u8(src & 7))
}


@(private)
REGISTER_DIRECT :: 0b1100_0000
@(private)
Memory :: struct {
    base: Maybe(Reg64),
    index: Maybe(Reg64),
    // 0 - no scale
    scale: int,
    // 0 - no offset
    offset: i32,
}
@(private)
RexFlags :: enum u8 {
    B,
    X,
    R,
    W,
    _,
    __,
    Rex,
    ___,
}
@(private)
RexPrefix :: bit_set[RexFlags]
@(private)
Opcode :: struct {
    bytes: [4]u8,
    size: int,
    modrm_ext: u8,
}
@(private)
at_base :: proc(base: Reg64, disp: i32 = 0) -> Memory {
    return {
        base = base,
        index = nil,
        scale = 1,
        offset = disp,
    }
}
@(private)
at_base_index_scale :: proc(base: Reg64, index: Reg64, disp: i32 = 0, scale: int = 1) -> Memory {
    return {
        base = base,
        index = index,
        scale = scale,
        offset = disp,
    }
}
at :: proc {at_base, at_base_index_scale}
OperandEncoding :: enum {
    MI,
    MR,
    RM,
}
@(private)
generic_reg :: proc(using assembler: ^Assembler, rex: RexPrefix, old: bool, opcode: Opcode, src: int) {
    rex := extend_rex_if_needed(rex, 0, src)
    if old { append(&bytes, OLD_PREFIX) }
    if rex != {} { append(&bytes, transmute(u8)(rex | {.Rex}))}
    for i in 0..<opcode.size {
        append(&bytes, opcode.bytes[i])
    }
    append(&bytes, 0b11_00_0000 | u8(src & 7) | ((opcode.modrm_ext & 7) << 3)) 
}
@(private)
generic_reg_or_imm_to_reg :: proc(using asmm: ^Assembler, rex: RexPrefix, old_prefix: Maybe(u8) = nil, opcode: Opcode, modrm: u8, reg1: int, reg2: int, imm: int, imm_size: int, modrmmode: OperandEncoding) {
    rex := rex
    reg1 := reg1
    reg2 := reg2
    imm := imm
    modrm := modrm
    if modrmmode == OperandEncoding.MI || modrmmode == OperandEncoding.MR {
        if reg1 >= 8 {
            rex |= { .B }
        }
        reg1 = reg1 & 7
        modrm |= cast(u8)reg1
        if modrmmode == OperandEncoding.MR {
            if reg2 >= 8 {
                rex |= { .R }
            }
            reg2 = reg2 & 7
            modrm |= cast(u8)reg2 << 3
        }
    }
    else {
        if reg1 >= 8 {
            rex |=  { .R }
        }
        reg1 = reg1 & 7
        modrm |= cast(u8)reg1 << 3
        if reg2 >= 8 {
            rex |= { .B }
        }
        reg2 = reg2 & 7
        modrm |= cast(u8)reg2
    }
    if old, ok := old_prefix.?; ok {
        append(&asmm.bytes, old)
    }
    if transmute(u8)(rex) != 0 {
        rex |= { .Rex }
        
        append(&asmm.bytes, transmute(u8)rex)
    }
    for i in 0..<opcode.size {
        append(&asmm.bytes, opcode.bytes[i])
    }
    append(&asmm.bytes, modrm | ((opcode.modrm_ext & 7) << 3))
    if modrmmode == OperandEncoding.MI {
        for i in 0..=imm_size-1 {
            append(&asmm.bytes, cast(u8)(imm & 0xff))
            imm >>= 8
        }
    }
}


delete_asm :: proc(using assembler: ^Assembler) {
    if assembler != nil {
        delete(bytes)
        delete(labels)
        delete(labelplaces)
        if mnemonics != nil {
            for mnemonic in mnemonics {
                delete(mnemonic)
            }
            delete(mnemonics)
        }
    }
    
}
@(private)
reg_formatter :: proc(fi: ^fmt.Info, arg: any, verb: rune) -> bool {
    str, _ := fmt.enum_value_to_string(arg) 
    str = strings.to_lower(str)
    defer delete(str)
    fmt.fmt_string(fi, str, 's')
    return true
}
@(private)
memory_formatter :: proc(fi: ^fmt.Info, arg: any, verb: rune) -> bool {
    memory := arg.(Memory)        
    fmt.fmt_rune(fi, '[', 'c') 
    fmt.fmt_value(fi, memory.base.(Reg64), 's')
    if memory.index != nil {
        fmt.fmt_string(fi, " + ", 's')
        fmt.fmt_value(fi, memory.index.(Reg64), 's')
        if memory.scale != 1 {
            fmt.fmt_rune(fi, '*', 'c') 
            fmt.fmt_value(fi, memory.scale, 'i')
        }

    }
    if memory.offset != 0 {
        fmt.fmt_string(fi, memory.offset < 0 ? " - " : " + ", 's') 
        if memory.offset < 10 {
            fmt.fmt_int(fi, cast(u64)abs(memory.offset), false, 32, 'i')
        } else {
            fmt.fmt_string(fi, "0x", 's')
            fmt.fmt_int(fi, cast(u64)abs(memory.offset), false, 32, 'x')
        }
    }
    fmt.fmt_rune(fi, ']', 'c') 
    return true
}
@(private)
array_formatter :: proc(fi: ^fmt.Info, arg: any, verb: rune) -> bool {
    for b in arg.([]u8) {
        if b <= 0xF {
            fmt.fmt_rune(fi, '0', 'c')
        }
        fmt.fmt_int(fi, u64(b), false, 8, 'X')
    }
    return true
}
fmts := new_clone(make(map[typeid]fmt.User_Formatter))
set_formatter :: proc() {
    if formatters_set { return }
    formatters_set = true
    fmt.set_user_formatters(fmts)
    err := fmt.register_user_formatter(Reg64, reg_formatter)
    err = fmt.register_user_formatter(Reg32, reg_formatter)
    err = fmt.register_user_formatter(Reg16, reg_formatter)
    err = fmt.register_user_formatter(Reg8, reg_formatter)
    err = fmt.register_user_formatter(Xmm, reg_formatter)
    err = fmt.register_user_formatter(Memory, memory_formatter)
    err = fmt.register_user_formatter([]u8, array_formatter)
}

formatters_set := false
@private
main :: proc() {
    set_formatter()
    asmm := Assembler {} 
    init_asm(&asmm)
//     (&asmm, xmm8, xmm1)
    
//     for i in 0..=15{
//         mov_reg32_memory(&asmm, Reg32(i), at(Reg64.Rbp, Reg64.R8, 256, 2))
//     }
    for b in asmm.bytes {
        fmt.printf("%2X", b)
    }
//     rex: u8 = u8(RexPrefix { .W, .R, .X, .B, .Rex})
//     fmt.printf("%b", rex)
//     assert(rex == 0b01001111)
    
}

