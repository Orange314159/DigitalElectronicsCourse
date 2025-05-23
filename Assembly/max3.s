data   DCD     0x2,0x3,0x1; P,Q,R
       mov     r0,#0x200 ; r0 = start data address
       ldr     r1,[r0],#4 ; r1 = P, r0 = r0 + 4

       ldr     r2,[r0],#4 ;
       ldr     r3,[r0],#4 ;

       ;       find max of 1 and 2

       cmp     r1,r2
       movmi   r1,r2
       cmp     r1,r3
       movmi   r1,r3
