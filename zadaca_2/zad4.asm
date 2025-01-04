@SCREEN
D = A;

@i
M = D;

@j
M = 0;

@5
D = A;
@i
M = M + D;

@2048
D = A;
@i
M = M + D;

(START_KAT1)
	@j
	D = M;
	@128
	D = D - A;
	@END_KAT1
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
	
	@START_KAT1
	0; JMP
(END_KAT1)

@i
D = M;

@Sx
M = D;

@j
M = 0;

(START_KAT2)
	@j
	D = M;
	@8
	D = D - A;
	@END_KAT2
	D; JGE
	
	@i
	A = M;
	M = -1;
	
	@i
	M = M + 1;
	
	@j
	M = M + 1;
	
	@START_KAT2
	0; JMP
(END_KAT2)

@128
D = A;
@j
M = D;
@z
M = 0;

(START_HIP)
	@j
	D = M;
	@END_HIP
	D; JEQ
	
	@i
	A = M;
	M = -1;
	
	@33
    D = A;
	@i
	M = M - D;
	
	@j
	M = M - 1;
	
	@START_HIP
	0; JMP
(END_HIP)

(END)
@END
0; JMP