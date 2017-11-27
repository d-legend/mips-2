

.data

string_invalid: .asciiz "NaN"

buff: .space 1001 # space for input string

.text

.globl main

main:

la $a0,buff# input string address
li $a1,1001 
li $v0,8 #read string
syscall

j subprogram2

j subprogram3 




#
#Changes each charater into its decimal equivalent
#

subprogram1:

HexCheck:
move $t2, $zero

li $t6,47
li $t7,58
slt $t0,$t6,$t4    # Sets $t0=1 if $t6 < $t4, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $t4 < $t7, otherwise $t1=0
and  $t2, $t1, $t0    # Sets $t2=1 if $t6 < $t4 < $t7, otherwise $t0=0
beq $t2, 0, HexCheck2
add $t9, $t9, 1  
add $a2, $t4, -48 


HexCheck2:
li $t6,64
li $t7,71
slt $t0,$t6,$t4    # Sets $t0=1 if $t6 < $t4, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $t4 < $t7, otherwise $t1=0
and  $t3, $t1, $t0    # Sets $t3=1 if $t6 < $t4 < $t7, otherwise 				#$t0=0
beq $t3, 0, HexCheck3
add $t9, $t9, 1  
add $a2, $t4, -55  


HexCheck3:
or $t2, $t2, $t3    
li $t6,96
li $t7,103
slt $t0,$t6,$t4    # Sets $t0=1 if $t6 < $t4, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $t4 < $t7, otherwise $t1=0
and  $t0, $t1, $t0    # Sets $t0=1 if $t6 < $t4 < $t7, otherwise $t0=0
beq $t0, 0, WhiteSpaces
add $t9, $t9, 1 
add $a2, $t4, -87


#
#Ignoring white spaces
#

WhiteSpaces:
or $t2, $t2, $t0    
move $a3, $a0
move $t7, $t4
li $t6,32
bne $t6,$t7,Else   # b Else if there is no space
beq $s5, 8, subprogram3 # b Invalid if all spaces
beq $t8, 1, LoopBuff 
li $t2, 1          # $t2 = 1
j Exit             # jump out of the if

Else: 
	bne $t2,1,subprogram3 # b Invalid if other chars not hex
	li $t8, 1 	#Assign 1 if you see a char
Exit:
	
beq $t2, $zero, subprogram3 #b to invalid if the character is not valid

j subprogram1

#
#After there is a character and then a space iterate further to #see if another character shows up and mark invalid if it is so
#

LoopBuff: 
	
lbu $t7, buff($a3)   #loading value
add $a3, $a3, 1
bne $t7, 32, Else2
j LoopBuff
	Else2:
	bne $t7, 10, Else3
		li $t8, 0 
		j WhiteSpaces	#j if return char
	Else3:
		bne $t7, 44, Else4
		li $t8, 0 
		j WhiteSpaces	#j if comma char
	Else4:
		bne $t7, 0, subprogram3
		li $t8, 0 
		j WhiteSpaces	#j if null char


subprogram2:

#It converts a single hexadecimal string to a decimal integer. 
#It must call Subprogram 1 to get the decimal value of each of the characters in the string. 
#Registers must be used to pass parameters into the subprogram. Values must be returned via the stack.

subprogram3:
	
la $a0,string_invalid 
li $v0,4	#print error output
syscall
li $v0,10	#exit
syscall
#displays unsigned decimal integer stack is used to pass parameters into subprogram




