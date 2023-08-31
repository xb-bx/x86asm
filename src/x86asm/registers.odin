package x86asm
Xmm :: enum {
    Xmm0,
    Xmm1,
    Xmm2,
    Xmm3,
    Xmm4,
    Xmm5,
    Xmm6,
    Xmm7,
    Xmm8,
    Xmm9,
    Xmm10,
    Xmm11,
    Xmm12,
    Xmm13,
    Xmm14,
    Xmm15,
}
Reg64 :: enum {
    Rax = 0,
    Rcx,
    Rdx,
    Rbx,
    Rsp,
    Rbp,
    Rsi,
    Rdi,
    R8,
    R9,
    R10,
    R11,
    R12,
    R13,
    R14,
    R15,
}
Reg32 :: enum {
    Eax = 0,
    Ecx,
    Edx,
    Ebx,
    Esp,
    Ebp,
    Esi,
    Edi,
    R8d,
    R9d,
    R10d,
    R11d,
    R12d,
    R13d,
    R14d,
    R15d,
}
Reg16 :: enum {
    Ax = 0,
    Cx,
    Dx,
    Bx,
    Sp,
    Bp,
    Si,
    Di,
    R8w,
    R9w,
    R10w,
    R11w,
    R12w,
    R13w,
    R14w,
    R15w,
}
Reg8 :: enum {
    Al,
    Cl,
    Dl,
    Bl,
    Spl,
    Bpl,
    Sil,
    Dil,
    R8b,
    R9b,
    R10b,
    R11b,
    R12b,
    R13b,
    R14b,
    R15b,
    Ah,
    Ch,
    Dh,
    Bh,
}
rax :: Reg64.Rax
rcx :: Reg64.Rcx
rdx :: Reg64.Rdx
rbx :: Reg64.Rbx
rsp :: Reg64.Rsp
rbp :: Reg64.Rbp
rsi :: Reg64.Rsi
rdi :: Reg64.Rdi
r8 :: Reg64.R8
r9 :: Reg64.R9
r10 :: Reg64.R10
r11 :: Reg64.R11
r12 :: Reg64.R12
r13 :: Reg64.R13
r14 :: Reg64.R14
r15 :: Reg64.R15

eax :: Reg32.Eax
ecx :: Reg32.Ecx
edx :: Reg32.Edx
ebx :: Reg32.Ebx
esp :: Reg32.Esp
ebp :: Reg32.Ebp
esi :: Reg32.Esi
edi :: Reg32.Edi
r8d :: Reg32.R8d
r9d :: Reg32.R9d
r10d :: Reg32.R10d
r11d :: Reg32.R11d
r12d :: Reg32.R12d
r13d :: Reg32.R13d
r14d :: Reg32.R14d
r15d :: Reg32.R15d



ax :: Reg16.Ax
cx :: Reg16.Cx
dx :: Reg16.Dx
bx :: Reg16.Bx
sp :: Reg16.Sp
bp :: Reg16.Bp
si :: Reg16.Si
di :: Reg16.Di
r8w :: Reg16.R8w
r9w :: Reg16.R9w
r10w :: Reg16.R10w
r11w :: Reg16.R11w
r12w :: Reg16.R12w
r13w :: Reg16.R13w
r14w :: Reg16.R14w
r15w :: Reg16.R15w

al :: Reg8.Al
cl :: Reg8.Cl
dl :: Reg8.Dl
bl :: Reg8.Bl
spl :: Reg8.Spl
bpl :: Reg8.Bpl
sil :: Reg8.Sil
dil :: Reg8.Dil
r8b :: Reg8.R8b
r9b :: Reg8.R9b
r10b :: Reg8.R10b
r11b :: Reg8.R11b
r12b :: Reg8.R12b
r13b :: Reg8.R13b
r14b :: Reg8.R14b
r15b :: Reg8.R15b
ah :: Reg8.Ah
ch :: Reg8.Ch
dh :: Reg8.Dh
bh :: Reg8.Bh



xmm0 :: Xmm.Xmm0
xmm1 :: Xmm.Xmm1
xmm2 :: Xmm.Xmm2
xmm3 :: Xmm.Xmm3
xmm4 :: Xmm.Xmm4
xmm5 :: Xmm.Xmm5
xmm6 :: Xmm.Xmm6
xmm7 :: Xmm.Xmm7
xmm8 :: Xmm.Xmm8
xmm9 :: Xmm.Xmm9
xmm10 :: Xmm.Xmm10
xmm11 :: Xmm.Xmm11
xmm12 :: Xmm.Xmm12
xmm13 :: Xmm.Xmm13
xmm14 :: Xmm.Xmm14
xmm15 :: Xmm.Xmm15
