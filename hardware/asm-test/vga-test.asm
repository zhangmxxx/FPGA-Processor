lui t1, 512 	 # initialize with 0x00200000 
mv s0, zero # row counter
mv s3, zero # column counter
mv s5, zero # addr in a row 
addi s1, zero, 30 # row
addi s2, zero, 70 # column
addi s4, zero, 128 # increment for column + 1

addi t2, zero, 76 # fixed letters
addi t3, zero, 88
addi t4, zero, 84

loop:                   # draw a row
mv s3, zero
mv s5, t1 
row_loop: 
sb t4, (s5)
add s5, s5, s4
addi s3, s3, 1
bgt s2, s3, row_loop

addi t1, t1, 1
addi s0, s0, 1
bgt s1, s0, loop

lui t5 528 							# line_offset port
mv s0, zero
addi t6, zero, 30
sw t6, (t5)

loop1:                   # draw a row
mv s3, zero
mv s5, t1
row_loop1: 
sb t3, (s5)
add s5, s5, s4	
addi s3, s3, 1
bgt s2, s3, row_loop1

addi t1, t1, 1
addi s0, s0, 1
bgt s1, s0, loop1
			
lw  s6, (t5)     # s6 should be 30, the same as t6
bne s6, t6, end
addi t6, zero, 15
sw t6, (t5)

end:
j end


