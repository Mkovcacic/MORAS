@R2
M = 0;

@R0
D = M;

@END
D;JLE

@R1
D = M;

@END
D;JLE

@R0
D = D - M;

@NUM_SWP
D; JLT
(PROC1)
    @R0
	D = M;
    @m
	$MV(R0,m)
	
	@R1
	D = M;
	@n
	$MV(R1,n)
	
	@m
	M = D - M;
	M = M + 1;
	
	$WHILE(m)
		@m
		M = M - 1;
		$ADD(n, R2, R2)
		@n
		M = M - 1;
	$END
	
	@END
	0;JMP
	(NUM_SWP)
	$SWP(R1, R0)
	@PROC1
	0; JMP
(END)
@END
0;JMP