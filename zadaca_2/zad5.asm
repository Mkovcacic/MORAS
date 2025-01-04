@SCREEN
D = A;

@i
M = D;

@j
M = 0;

(START_VERTICAL)      // kreira polja (do linije 138)
	@j
	D = M;
	@32
	D = D - A;
	@END_VERTICAL
	D; JGE
	
	@i
	A = M;
	M = 1;
	
	@32
	D = A;
	
	@i
	M = M + D;
	
	@j
	M = M + 1;
	
	@START_VERTICAL
	0; JMP
(END_VERTICAL)

@SCREEN
D = A;

@i
D = M;

@j
M = 0;

(START_HORIZONTAL)
	@j
	D = M;
	@32
	D = D - A;
	@END_HORIZONTAL
	D; JGE
	
	@i
	A = M;
	M = -1;
	
	@i
	M = M + 1;
	
	@j
	M = M + 1;
	
	@START_HORIZONTAL
	0; JMP
(END_HORIZONTAL)

@SCREEN
D = A;

@i
M = D;

@j
M = 0;
(START_HORIZONTAL2)
	@i
	A = M;
	M = -1;
	
	@i
	M = M + 1;
	
	@i
	A = M;
	M = -1;
	
	@j
	M = M + 1;
	@j
	M = M + 1;
	
	@j
	D = M;
	@32
	D = D - A;
	@LOOP_START
	D; JEQ
	
	@i
	M = M + 1;
	D = M;
	
    @k
    M = D;
	
	@z
	M = 0;
	
	(START_VERTICAL2)
	   //zavrsava kada z >= 128
	   @z
	   D = M;
	   @32
	   D = D - A;
	   @END_VERTICAL2
	   D; JGE
	   
	   @k
	   A = M;
	   M = 1;
	   
	   @32
	   D = A;
	   
	   @k
	   M = M + D;
	   
	   @z
	   M = M + 1;
	   
	   @START_VERTICAL2
	   0; JMP
    (END_VERTICAL2)
	
	@START_HORIZONTAL2
	0; JMP
(END_HORIZONTAL2)

(DRAW0)      // crta 0
    @SCREEN
    D = A;

    @i
    M = D;

    @d 
	D = M;
	
	@i 
	M = M + D;
	
	@32
	D = A;
	@i
    M = M + D;
	M = M + D;
	M = M + D;
	
	
	@2
	D = A;
	@j
	M = D;
	@d
	M = M + D;
	
	@e 
	M = M - 1;
	@c
	M = M - 1;
	
	@START_ZERO_DRAW
	0; JMP
	
(DRAW1)      // crta 1
    @SCREEN
    D = A;

    @i
    M = D;

    @d 
	D = M;
	
	@i 
	M = M + D;
	
	@32
	D = A;
	@i
    M = M + D;
	M = M + D;
	M = M + D;

	@j
	M = 0;
	
	@2
	D = A;
	@j
	M = M + D;
	@d
	M = M + D;
	
	@e 
	M = M - 1;
	
	@b
	D = M;
	@a
	M = M - D;
	
	@START_ONE_DRAW
	0; JMP
(START_ONE_DRAW)
	   @j
	   D = M;
	   @30
	   D = D - A;
	   @DIVID
	   D; JGE
	   
	   @i
	   A = M;
	   M = 1;
	   
	   @32
	   D = A;
	   
	   @i
	   M = M + D;
	   
	   @j
	   M = M + 1;
	   
	   @START_ONE_DRAW
	   0; JMP
	(END_ONE_DRAW)
(START_ZERO_DRAW)
	   @j
	   D = M;
	   @30
	   D = D - A;
	   @DIVID
	   D; JGE

	   @i
	   A = M;
	   M = -1;
	   
	   @32
	   D = A;
	   
	   @i
	   M = M + D;
	   
	   @j
	   M = M + 1;
	   
	   @START_ZERO_DRAW
	   0; JMP
    (END_ZERO_DRAW)
(DIVID)	// dijeljenje s 2
	    @c      // broj ne moze biti 2^15  ili veci pa preskacemo prva 2 puta
	    D = M;
	    @LOOP1
	    D; JGE
	    @b
		D = M;
		@R1
		D = D - A;
		@FINAL_START
		D; JEQ
		@g
		M = 0;
		@b
		D = M;
		(LOOP_DIV)
		@R2
		D = D - A;
		@g
		M = M + 1;
		@EVENLY
		D; JEQ 
		@LOOP_DIV
		0; JMP
		(EVENLY)
		@g
		D = M;
		@b
		M = D;
		@LOOP1
		0; JMP
	(END_DIVID)

(LOOP_START)
@R0 
D = M;       
@a         //prebacuje broj iz RAM[0] u a
M = D;       

@16
D = A;
@e        // e broji koliko se polja preslo
M = D;

@c
M = 1;
@d         // pomocu d ce se program prebacivati u sljedece polje
M = 1; 

@b        // pohranja potencije broja 2
M = 0;

@16384
D = A;
@b
M = D;

@LOOP1
0; JMP

(LOOP1)
    @e
    D = M;
	@FINAL_START
	D; JEQ
	
	@c      // broj ne moze biti 2^15  ili veci pa je prvo mjesto uvijek 0
	D = M;
	@DRAW0
	D; JGT
	
	@a
	D = M;
	@b
	D = D - M;
	@DRAW1
	D; JGE
	
	@DRAW0
	D; JLT
	
(LOOP1_END)

(FINAL_START)
    // izadji iz petlje ako RAM[KDB] == U (85)
    // tj. ako RAM[KBD] - 85 == 0
	
    @KBD
    D = M;
    @85
    D = D - A
    @RETURN
    D; JEQ
	
	@FINAL_START
	0; JMP
    
    (RETURN)
	@R0
	M = M + 1;
	@h
	M = M + 1;
    @LOOP_START
    0; JMP
(LOOP_END)
(END)
@END
0; JMP