data   DCD     -9,3,16,27,-18,1,32,33;
       mov     r0,#0x200 ; r0 = start data address
       add     r1,r0,#28 ; r1 = end data address
       ldr     r2,[r0],#4 ; r2 = initial maximum
loop   ldr     r3,[r0],#4 ; r3 = compare against
       cmp     r2, r3
       movlt   r2, r3
       cmp     r1,r0
       bne     loop
