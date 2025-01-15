$MV(R0,n)

@100
D = A;
	
@i
M = D;
(BUBBLE_SORT)
	$WHILE(n)
	
	$MV(n,m)
	@m
	M = M - 1;
	
	@i
	D = M;
	
	@j
	M = D + 1;
	
	$WHILE(m)
	    
		@i 
		A = M;
		D = M;
		
		@j
		A = M;
		D = D - M;
		
		@SWAP
		D; JGT
		
		@SKIP
		0; JMP
		
		(SWAP)
			@i
			A = M;
			D = M;
			@k
			M = D;
			
			@j
			A = M;
			D = M;
			
			@i
			A = M;
			M = D;
			
			@k
			D = M;
			
			@j
			A = M;
			M = D;
		(SKIP)
			@j
			M = M + 1;
			@m
			M = M - 1;
	$END
	@i
	M = M + 1;
	@n
	M = M - 1;
$END
(END)
@END
0;JMP
	