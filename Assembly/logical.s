data   DCD     0xEEEE3044,0xDDDD20F2,0xFFFFC4F8 ; P,Q,R

       mov     r0,#0x200 ; r0 = start data address
       ldr     r1,[r0],#4 ; r1 = P, r0 = r0 + 4

       ldr     r2,[r0],#4 ; r2 = Q, r0 = r0 + 4
       ldr     r3,[r0],#4 ; r3 = R, r0 = r0 + 4
       mov     r2, r2, lsr #1;
       eor     r2, r2, r3, lsr #5;
       orr     r1, r2, r1, lsr #9; r1 |= r2
       and     r1, r1, #0b111110