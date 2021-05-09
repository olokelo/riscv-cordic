# Cordic algorithm in RISC-V 32bit assembly
# Calculates approximated sinus and cosinus values for given angle
# Uses fixed point arithmetic and doesn't require an FPU
# adapted from bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf
# Tested assemblers: RARS and GAS
# Author: oloke (github.com/olokelo)
# License: MIT

# Arguments:
#   a0 <- desired angle (input argument for sin and cos functions expressed in degrees not in radians)

# Variables:
#   t0 -> temporary
#   t1 -> angle
#   t2 -> temp x
#   t3 -> temp y
#   a2 -> x
#   a3 -> y
#   t4 -> temporary
#   t5 -> temporary
#   t6 -> counter

# Returns:
#	a0 -> sin
#   a1 -> cos

.globl cordic

j progtest

.data
	
	atan_table: .word 11520, 6801, 3593, 1824, 916, 458, 229, 115, 57, 28, 14, 7, 4, 2, 1

.text

cordic:

	li t1, 0
	li a3, 0
	li a2, 155               # 256 * CORDIC gain
	
	li t0, 23040             # 90deg
	ble a0, t0, angle_check0 # if desired angle <= 90deg, jump to angle_check0
	
	li t1, 46080             # set angle to 180deg
	
	angle_check0:
	
	li t0, 69120             # 270deg
	ble a0, t0, angle_check1 # if desired angle <= 270deg, jump to angle_check1
	
	li t1, 92160             # set angle to 360deg
	
	angle_check1:
	
	li t6, 0                 # counter (i)
	li t0, 14                # counter iterations
	
	mainloop:
		
		sra t2, a3, t6       # temp_x = x >> t6
		sra t3, a2, t6       # temp_y = y >> t6
		
		# calculate offset of current atan value into t5
		
		la t4, atan_table    # load address of atan_table
		slli t5, t6, 2       # t5 = t6 * 4
		add t4, t4, t5       # t4 = address of atan_table + (t6 * 4)
		lw t5, (t4)          # t5 = atan_table[i]
		
		ble a0, t1, rotate_clockwise
		
		# rotate counter-clockwise
		sub t2, a2, t2       # temp_x = x - temp_x
		add t3, a3, t3       # temp_y = y + temp_y
		add t1, t1, t5       # angle += atan_table[i]
		j iter_finalize
		
		rotate_clockwise:
		
		add t2, a2, t2       # temp_x = x + temp_x
		sub t3, a3, t3       # temp_y = y + temp_y
		sub t1, t1, t5       # angle -= atan_table[i]
		
		iter_finalize:
		
		mv a2, t2         # x = temp_x
		mv a3, t3         # y = temp_y
		
		addi t6, t6, 1         # i += 1
		bne t6, t0, mainloop   # if i != 14, jump to mainloop
	
	li t0, 23040             # 90deg
	slt t4, t0, a0           # t4 = bool(90deg < desired angle)
	
	li t0, 69121             # 270 + (1/256)deg
	slt t5, a0, t0           # t5 = bool(270deg => desired angle)
	
	and t0, t4, t5           # t0 = t4 and t5
	beqz t0, sign_ok
	
	neg a1, a2               # change sign of cos and sin
	neg a0, a3
	j done
	
	sign_ok:
	
	mv a1, a2                # move return values
	mv a0, a3
	
	done:
	
	li a2, 0
	li a3, 0

	ret
	
# progtest requires an fpu!
progtest:

	li t0, 130               # type here the angle in degrees ;)
	slli a0, t0, 8          # a0 = input angle * 256
	jal cordic              # call cordic
	
	fcvt.s.w ft0, a0        # convert returned sin to float
	fcvt.s.w ft1, a1        # convert returned cos to float
	li t0, 0x43800000       # float 256.0
	fmv.s.x ft2, t0
	
	fdiv.s ft0, ft0, ft2    # get real value of sin
	fdiv.s ft1, ft1, ft2    # get real value of cos
