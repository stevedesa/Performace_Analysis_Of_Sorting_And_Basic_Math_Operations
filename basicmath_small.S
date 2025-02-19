                .data
a1:             .dword  0x3FF0000000000000
a2:             .dword  0x3FF0000000000000
a3:             .dword  0x3FF0000000000000
a4:             .dword  0x3FF0000000000000
b1:             .dword  0xC025000000000000
b2:             .dword  0xC012000000000000
b3:             .dword  0xC00C000000000000
b4:             .dword  0xC02B666666666666
c1:             .dword  0x4040000000000000
c2:             .dword  0x4031000000000000
c3:             .dword  0x4036000000000000
c4:             .dword  0x3FF0000000000000
d1:             .dword  0xC03E000000000000
d2:             .dword  0xC03E000000000000
d3:             .dword  0xC03F000000000000
d4:             .dword  0xC041800000000000
l:              .dword  0x000000003FED0169
PI:             .dword  0x400921FB54442D18

solutions:      .word   0
solnArray:      .skip   24
sqrtArray:      .skip   8

cubicPrint:     .asciz  "********* CUBIC FUNCTIONS ***********\n"
sqrtPrint:      .asciz  "********* INTEGER SQR ROOTS ***********\n"
anglePrint:     .asciz  "********* ANGLE CONVERSION ***********\n"
solutionPrint:  .asciz  " %f"
randomPrint:    .asciz  " %f %f %f\n"
sqrtPrint1:     .asciz  "sqrt(%3d) = %2d\n"
sqrtPrint2:     .asciz  "\nsqrt(%lX) = %X, remainder = %X\n"
anglePrint1:    .asciz  "%3.0f degrees = %.12f radians\n"
anglePrint2:    .asciz  "%.12f radians = %3.0f degrees\n"
newline:        .asciz  "\n"

                .text
                .type main, %function
                .global main

main:
    // LOAD STACK
    STP     x29, x30, [sp,#-16]!
    STP     x27, x28, [sp,#-16]!
    STP     d27, d28, [sp,#-16]!
    
    // LDR     x0, =cubicPrint
    // BL      printf

    // FIRST CUBIC LOOP
    ADR     x0, a1
    ADR     x1, b1
    ADR     x2, c1
    ADR     x3, d1
    ADR     x4, solutions
    ADR     x5, solnArray
    BL      SolveCubic

    // SECOND CUBIC LOOP
    ADR     x0, a2
    ADR     x1, b2
    ADR     x2, c2
    ADR     x3, d2
    ADR     x4, solutions
    ADR     x5, solnArray
    BL      SolveCubic

    // THIRD CUBIC LOOP
    ADR     x0, a3
    ADR     x1, b3
    ADR     x2, c3
    ADR     x3, d3
    ADR     x4, solutions
    ADR     x5, solnArray
    BL      SolveCubic

    // FOURTH CUBIC LOOP
    ADR     x0, a4
    ADR     x1, b4
    ADR     x2, c4
    ADR     x3, d4
    ADR     x4, solutions
    ADR     x5, solnArray
    bl      SolveCubic
 
    // RANDOM EQUATION LOOP
    MOV     x27, #1         // a1 (on stack)

innerLoop1:
    MOV     x28, #10        // b1 (on stack)

innerLoop2:
    FMOV    d27, #5         // c1 (d on stack)

innerLoop3:
    FMOV    d28, #-1        // d1 (d on stack)

innerLoop4:
    SCVTF   d0, x27         // a1 (move for fn call)
    SCVTF   d1, x28         // b1 (move for fn call)
    FMOV	d2, d27         // c1 (move for fn call)
    FMOV    d3, d28         // d1 (move for fn call)
    ADR     x0, solutions
    ADR     x1, solnArray
    BL      SolveCubic

    // PRINT
    // LDR      x0, =randomPrint
    // LDR      x1, =solnArray
    // LDR      d0, [x1, #0]
    // LDR      d1, [x1, #8]
    // LDR      d2, [x1, #16]
    // BL       printf
    
    // INNER LOOP 4 CHECK
    FMOV      d7, #1.0
    FSUB      d28, d28, d7
    FMOV      d7, #-11.0
    FCMP      d28, d7
    BGT       innerLoop4    // br if > -11

    // INNER LOOP 3 CHECK
    FMOV      d7, #0.5
    FADD      d27, d27, d7
    FMOV      d7, #15.0
    FCMP      d27, d7
    BLT       innerLoop3    // br if < 15

    // INNER LOOP 2 CHECK
    SUB       x28, x28, #1
    CMP       x28, #0
    BGT       innerLoop2    // br if > 0

    // INNER LOOP 1 CHECK
    ADD       x27, x27, #1
    CMP       x27, #10
    BLT       innerLoop1    // br if < 10

    // SQUARE ROOT LOOP
    // LDR     x0, =sqrtPrint
    // BL      printf

    MOV         x27, #0      // i = 0

sqrtLoop:
    MOV         x0, x27
    ADR         x1, sqrtArray
    BL          usqrt

    // PRINT
    // ADR        x0, sqrtPrint1
    // MOV        x1, x27
    // ADR        x2, sqrtArray
    // LDR        x2, [x2]
    // BL         printf

    ADD         x27, x27, #1
    CMP         x27, #1001
    BLT         sqrtLoop    // br if < 1001

    LDR         x0, =l
    ADR         x1, sqrtArray
    BL          usqrt

    // PRINT
    // ADR         x0, sqrtPrint2
    // ADR         x1, l
    // ADR         x1, [x1]
    // ADR         x2, sqrtArray
    // MOV         x7, x2
    // LDR         x2, [x2]
    // LDR         x3, [x7, #8]
    // BL          printf
    
    // ANGLE LOOP
    // LDR     x0, =anglePrint
    // BL      printf

    // DEG TO RAD
    MOV         x27, #0
    SCVTF       d27, x27    // X (on stack)

angleLoop1:
    FMOV        d0, d27
    BL          deg2rad
    // FMOV        d7, d0      // o/p temp store

    // LDR         x0, =anglePrint1
    // FMOV        d0, d27
    // FMOV        d1, d7
    // BL          printf

    FMOV        d7, #1
    FADD        d27, d27, d7    // X += 1.0

    MOV         x7, #360
    SCVTF       d7, x7
    FCMP        d27, d7
    BLE         angleLoop1

    // RAD TO DEG
    ADR         x7, PI
    LDR         d7, [x7]
    MOV         x6, #180
    SCVTF       d6, x6
    FDIV        d28, d7, d6     // PI / 180

    MOV         x27, #0
    SCVTF       d27, x27

angleLoop2:
    FMOV        d0, d27
    BL          rad2deg
    // FMOV        d7, d0      // o/p temp store

    // LDR         x0, =anglePrint2
    // FMOV        d0, d27
    // FMOV        d1, d7
    // BL          printf

    FMOV        d7, #1
    FADD        d27, d27, d28

    ADR         x6, PI
    LDR         d6, [x6]
    FMOV        d4, #2
    FMUL        d6, d6, d4      // 2 * PI

    FCMP        d27, d6
    BLE         angleLoop2      // br if < rad_max

    // RESTORE STACK
    LDP     d27, d28, [sp], #16
    LDP     x27, x28, [sp], #16
    LDP     x29, x30, [sp], #16
    MOV     x0, #0
    RET
    