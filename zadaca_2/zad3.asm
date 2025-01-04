@i
M = 0;

(LOOP_START)
	@i
	D = M;
	@R4
	D = D - A;
	@LOOP_END
	D; JGT
	
	@i
	A = M;
	D = M;
	@CANT_BE_POS
	D; JLE
	
	@R5
	D = M;
	@TEST_RAM
	D; JEQ
	
	@i
	A = M;
	D = M;
	
	@R5
	D = D - M;
	@CANT_BE_MIN
	D; JGE
	
	@R5
	M = D;
	
	(TEST_RAM)
	@i
	A = M;
	D = M;
	@R5
	M = D;
	
	(CANT_BE_POS)
	(CANT_BE_MIN)
	
	@i
    M = M + 1;
	@LOOP_START
    0; JMP
(LOOP_END)

(END)
@END
0; JMP