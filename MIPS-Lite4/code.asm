    addi $1, $1, 1          ;0010/00 00/001 0/0001 0000 0000 0000 0001
    addi $3, $1, 2          ;0010/00 00/001 0/0011 0000 0000 0000 0010
    sub $2, $3, $1          ;0000/00 00/011 0/0001 0001/0 000/00 10/0011
    add $4, $1 $3           ;0000/00 00/001 0/0011 0010/0 000/00 10/0001
    ori $5, $4, 0x3f00      ;0011/01 00/100 0/0101 0011 1111 0000 0000
    lui $6, 0x3f3f          ;0011/11 00/000 0/0110 0011 1111 0011 1111
    addi $7, $7, 1          ;0010/00 00/111 0/0111 0000 0000 0000 0001
    beq $7, $1, A           ;0001/00 00/001 0/0111 0000 0000 0000 1101
B:  sw $5, 7($1)            ;1010/11 00/001 0/0101 0000 0000 0000 0111
    lw $8, 6($2)            ;1000/11 00/010 0/1000 0000 0000 0000 0110
    jal C                   ;0000/11 00/000 0/0000 0000 0000 0000 1111
    jal D                   ;0000/11 00/000 0/0000 0000 0000 0001 0001
A:  slt $9, $1, $2          ;0000/00 00/001 0/0010 0100/1 000/00 10/1010
    j B                     ;0000/10 00/000 0/0000 0000 0000 0000 1001
C:  slti $9, $3, 2          ;0010/10 00/011 0/1001 0000 0000 0000 0010
    jr                      ;0000/00 11/111 0/0000 0000/0 000/00 00/1000
D:  addi $10, $10, 0xffff   ;0010/00 01/010 0/1010 1111 1111 1111 1111
    sb $10, 14($1)          ;1010/00 00/001 0/1010 0000 0000 0000 1110
    sh $10, 10($2)          ;1010/01 00/010 0/1010 0000 0000 0000 1010
    lb $10, 14($1)          ;1000/00 00/001 0/1010 0000 0000 0000 1110
    lbu $10, 14($1)         ;1001/00 00/001 0/1010 0000 0000 0000 1110
    lh $10, 10($2)          ;1000/01 00/010 0/1010 0000 0000 0000 1010
    lhu $10, 10($2)         ;1001/01 00/010 0/1010 0000 0000 0000 1010
    jr                      ;0000/00 11/111 0/0000 0000/0 000/00 00/1000