
module Controller (
    input [5:0] op,
    input [5:0] func,

    output [1:0] Regdst,
    output Alusrc,
    output Memwrite,
    output [1:0] Memtoreg,
    output Regwrite,
    output [1:0] nPC_sel,
    output Extop,
    output [2:0] Aluop
);

                // op       func
    wire addu;  // 000000   100001
    wire subu;  // 000000   100011
    wire ori;   // 001101
    wire lw;    // 100011
    wire sw;    // 101011
    wire beq;   // 000100
    wire lui;   // 001111

    wire addi;  // 001000
    wire addiu; // 001001
    wire slt;   // 000000   101010
    wire j;     // 000010
    wire jal;   // 000011
    wire jr;    // 000000   001000

    
    assign addu = !op[0] && !op[1] && !op[2] && !op[3] && !op[4] && !op[5]
        && func[0] && !func[1] && !func[2] && !func[3] && !func[4] && func[5];
    
    assign subu = !op[0] && !op[1] && !op[2] && !op[3] && !op[4] && !op[5]
        && func[0] && func[1] && !func[2] && !func[3] && !func[4] && func[5];

    assign ori = op[0] && !op[1] && op[2] && op[3] && !op[4] && !op[5];

    assign beq = !op[0] && !op[1] && op[2] && !op[3] && !op[4] && !op[5];

    assign sw = op[0] && op[1] && !op[2] && op[3] && !op[4] && op[5];

    assign lw = op[0] && op[1] && !op[2] && !op[3] && !op[4] && op[5];

    assign lui = op[0] && op[1] && op[2] && op[3] && !op[4] && !op[5];
    

    assign addi = !op[0] && !op[1] && !op[2] && op[3] && !op[4] && !op[5];

    assign addiu = !op[0] && !op[1] && !op[2] && op[3] && !op[4] && op[5];

    assign slt = !op[0] && !op[1] && !op[2] && !op[3] && !op[4] && !op[5]
        && !func[0] && func[1] && !func[2] && func[3] && !func[4] && func[5];

    assign j = !op[0] && op[1] && !op[2] && !op[3] && !op[4] && !op[5];

    assign jal = op[0] && op[1] && !op[2] && !op[3] && !op[4] && !op[5];

    assign jr = !op[0] && !op[1] && !op[2] && !op[3] && !op[4] && !op[5]
        && !func[0] && !func[1] && !func[2] && func[3] && !func[4] && !func[5];

    
    assign Regdst[0] = addu || subu || slt;
    assign Regdst[1] = jal;

    assign Regwrite = addu || addi || addiu || subu || ori || lw || lui || jal || slt;

    assign Alusrc = addi || addiu || ori || sw || lw || lui;

    assign Memwrite = sw;

    assign Memtoreg[0] = lw;
    assign Memtoreg[1] = jal;

    assign nPC_sel[0] = beq || jr;
    assign nPC_sel[1] = j || jal || jr;

    assign Extop = lui;

    assign Aluop[0] = addu || addi || addiu || ori || lw || sw || lui;
    assign Aluop[1] = addu || addi || addiu || lw || sw || subu || beq;
    assign Aluop[2] = slt || lui;

endmodule