#Test RV32I base instructions plus RV64I-only extensions for the 64-bit RISC-V processor:
#Instructions                                   #Calculation                    #PC         #Note

# I type instruction related to register file
main:       addi    x1, x0, 1                   # x1 = 1                        0           #initialized reg 1
            addi    x2, x0, 16                  # x2 = 16                       4           #initialized reg 2
            addi    x3, x0, -3                  # x3 = -3                       8           #initialized reg 3
            addi    x4, x0, 0                   # x4 = 0                        C           #reg for status

            addi    x5, x3, 12                  # x5 = (-3+12) = 9              10
            slli    x6, x2, 2                   # x6 = (16 << 2) = 64           14
            slti    x7, x2, -16                 # x7 = (16 > -16) = 0           18
            sltiu   x8, x2, -16                 # x8 = (u(16) < u(-16))= 1      1C
            xori    x9, x2, 18                  # x9 = (16 XOR 18) = 2          20
            srli    x10,x3, 3                   # x10= (-3 >>3) = 2305843009213693951 24     #RV64 logical shift
            srai    x11,x3, 3                   # x11= (-3 >>> 3) = -1          28          #RV64 arithmetic shift
            ori     x12,x3, 3                   # x12= (-3 | 3) = -1            2c
            andi    x13,x3, 3                   # x13= (-3 & 3) = 1             30

            # RV64I word-immediate instructions
            addiw   x18, x3, 1                  # x18 = -2                      34
            slliw   x24, x1, 31                 # x24 = 0xFFFFFFFF80000000      38
            srliw   x20, x24, 31                # x20 = 1                       3C
            sraiw   x21, x24, 31                # x21 = -1                      40

            # R type instructions
            add     x14, x2, x1                 # x14= (16 + 1) = 17            44
            sub     x15, x2, x1                 # x15= (16 - 1) = 15            48
            sll     x16, x2, x1                 # x16= (16 << 1) = 32           4C
            slt     x17, x2, x3                 # x17= (16 > -3) = 0            50
            sltu    x18, x2, x3                 # x18= (u(16) < u(-3)) = 1      54
            xor     x19, x2, x1                 # x19= (16 XOR 1) = 17          58
            srl     x20, x2, x1                 # x20= (16 >> 1) = 8            5C
            sra     x21, x2, x1                 # x21= (16 >>> 1) = 8           60
            or      x22, x2, x1                 # x22= (16 OR 1) = 17           64
            and     x23, x2, x1                 # x23= (16 AND 1) = 0           68

            # RV64I word-register instructions
            addw    x22, x24, x24               # x22 = 0                       6C
            subw    x23, x1, x2                 # x23 = -15                     70
            sllw    x25, x2, x1                 # x25 = 32                      74
            srlw    x26, x24, x1                # x26 = 1073741824              78
            sraw    x27, x24, x1                # x27 = -1073741824             7C

            # U type instruction
            lui     x24, 0x2000                 # x24= 0x02000_000              80
            auipc   x25, 0x2000                 # x25= 0x02000_084              84

            # RV64I doubleword test data setup
            lui     x27, 0x12345                # x27 = 0x0000000012345000      88
            addi    x27, x27, 0x678             # x27 = 0x0000000012345678      8C
            slli    x27, x27, 32                # x27 = 0x1234567800000000      90
            addi    x28, x0, 1                  # x28 = 1                       94
            slli    x28, x28, 31                # x28 = 0x0000000080000000      98
            addi    x29, x0, 1                  # x29 = 1                       9C
            or      x28, x28, x29               # x28 = 0x0000000080000001      A0
            or      x27, x27, x28               # x27 = 0x1234567880000001      A4

            #S type instruction
            sb      x1,  17(x2)                 # (17 + 16) = [33] = 1          A8
            sh      x3,  22(x2)                 # (22 + 16) = [38] = -3         AC
            sw      x2,  24(x2)                 # (24 + 16) = [40] = 16         B0
            sd      x27, 32(x2)                 # (32 + 16) = [48] = x27        B4

            # I type instruction for load
            lb      x26, 36(x3)                 # x26 =[36 - 3]= 1              B8
            lh      x27, 41(x3)                 # x27 =[41 - 3]= -3             BC
            lw      x28, 43(x3)                 # x28 =[43 - 3]= 16             C0
            lbu     x29, 36(x3)                 # x29 =[36 - 3]= 1              C4
            lhu     x30, 41(x3)                 # x30 =[41 - 3]= 0x0000FFFD     C8
            ld      x30, 32(x2)                 # x30 =[32 + 16] = x27          CC
            lwu     x31, 32(x2)                 # x31 =[32 + 16] low 32 bits    D0

            # Branch instructions
            addi    x4,  x0, 0                  #                               D4
            addi    x6,  x0, -5                 #                               D8
            addi    x7,  x0, 5                  #                               DC
target_1:   addi    x4,  x4, 1                  # x4 = A                        E0
            addi    x6,  x6, 1                  # blt t0, t1, target            E4
            blt     x6,  x7, target_1           # if t0 < t1 then target        E8
            add     x6,  x0, x6                 # x6 = 5                        EC

            addi    x4,  x0, 0                  #                               F0
            addi    x8,  x0, -5                 #                               F4
            addi    x9,  x0, 5                  #                               F8
target_2:   addi    x4,  x4, 1                  # x4 = B                        FC
            addi    x9,  x9, -1                 # bge t0, t1, target            100
            bge     x9,  x8, target_2           # if t0 >= t1 then target       104
            add     x9,  x0, x9                 # x9 = -6                       108

            addi    x4,  x0, 0                  #                               10C
            addi    x10, x0, 1                  #                               110
            addi    x11, x0, 5                  #                               114
target_3:   addi    x4,  x4, 1                  # x4 = 4                        118
            addi    x10, x10, 1                 #                               11C
            bltu    x10, x11, target_3          #                               120
            add     x10, x0, x10                # x10 = 5                       124

            addi    x4,  x0, 0                  #                               128
            addi    x12, x0, 1                  #                               12C
            addi    x13, x0, 5                  #                               130
target_4:   addi    x4,  x4, 1                  # x4 = 5                        134
            addi    x13, x13, -1                #                               138
            bgeu    x13, x12, target_4          #                               13C
            add     x13, x0, x13                # x13 = 0                       140

            addi    x4,  x0, 0                  #                               144
            addi    x14, x0, 5                  #                               148
            addi    x15, x0, 0                  #                               14C
target_5:   addi    x4,  x4, 1                  # x4 = 5                        150
            addi    x15, x15, 1                 # bne t0, t1, target            154
            bne     x15, x14, target_5          # if t0 != t1 then target       158
            add     x15, x0 , x15               # x15 = 5                       15C

            addi    x4,  x0, 0                  #                               160
            addi    x16, x0, 2                  #                               164
            addi    x17, x0, 3                  #                               168
target_6:   addi    x4,  x4, 1                  # x4 = 2                        16C
            addi    x16, x16, 1                 # x16 = 3                       170
            beq     x16, x17, target_6          # beq t0, t1, target            174
            add     x16, x0, x16                # x16 = 4                       178

            # J type instruction
            jalr    x31, x0, 388                # x31 = 0x180                   17C
            addi    x4 , x0, -1                 # shouldn't execute             180
            add     x31, x0, x31                # x31 = 0x180                   184

            # I type jump instruction
target_7:   jal     x4,  target_7               # x4 = 0x18C                    188
