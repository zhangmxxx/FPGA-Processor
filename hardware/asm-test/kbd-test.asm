# t used for const, s used for cnt, a used for variables
lui t0, 768 				   # initialize t0 with 0x00300000
lui t1, 784           # head/tail port
addi t2, zero, 10 # upbound for read times

mv s0, zero
loop:
lw a0, (t1)           # read the union of head / tail
andi a1, a0, 31   # [4:0]
andi a2, a0, 992 # [9:5]
srli a2, a2, 5        # `remove' mask 
beq a1, a2, increment # if (head == tail) do not actually read
lw a3, (t0)           # read keymem
sw zero, (t0)       # increment head ptr(memory only recognize writing into 0x003, and the data is ignored)

increment:
addi s0, s0, 1
bgt t2, s0, loop

end:
j end
