/******************************************************************************
* file: arm_lab_cs18m509_assignment_3.s
* author: Disha Das
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

  @ BSS section
      .bss

  @ DATA SECTION
    .data
data_start: .word 0x205A15E3 ;  #(0010 0000 0101 1010 0001 0101 1101 0011 – 13)
            .word 0x256C8700 ;  #(0010 0101 0110 1100 1000 0111 0000 0000 – 11)
data_end:   .word 0x295468F2 ;  #(0010 1001 0101 0100 0110 1000 1111 0010 – 14)

Output: NUM:
        WEIGHT: 
		
  @ TEXT section
      .text

.globl _main


_main:
    LDR R0, = data_start    @R0 holds start load address
	LDR R5, = NUM           @R5 holds num with max weight in NUM addr   (OUTPUT NUM)
    LDR R9, = WEIGHT        @R9 holds max weight in WEIGHT addr         (OUTPUT MAX WEIGHT)
	MOV R6, #0              @R6 holds max weight
	LDR R7, = data_end      @R7 holds end load address
	LDR R8, [R7]            @R8 holds last input value
	
	check_terminate:        @checks for terminate case after updating max weight:
	CMP R2, R6              @weight of current number compared with current max weight
	BGT update_max_weight
	CMP R4, R8              @terminate case check
	BEQ complete
	
	load:
	LDR R1, [r0], #4        @load number
	MOV R4, R1              @copy of current number
	MOV R2, #0              @R2 holds current weight value init to 0
	
	count_weight:
	AND R3, R1, #1          @the LSB bit of current number is stored in R3
	ADD R2, R3              @LSB bit added to sum of bits of current number
	LSR R1, R1, #1          @current number is logically shifted right
	CMP R1, #0              @if curent number becomes 0, check (update max weight) and terminate
	BEQ check_terminate
	B count_weight          @else continue counting
	
	update_max_weight:      @update max weight
	MOV R6, R2              @new max weight in R2 copied into max weight register R6
	CMP R4, R8              @check terminate
	BEQ complete
	B load                  @load next number
	
	complete:
	STR R4, [R5]            @copy at NUM from R4    (number with max weight)
	STR R6, [R9]            @copy at WEIGHT from R6 (maximum weight)
	swi 0x11