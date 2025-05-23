valueA DCD     627
valueB DCD     345
addrC  DCD     0xAAAAAAAA ; 0xAAAAAAAA at mem[addrC] will be replaced by function result
       ;       set up r7,r8,r11,sp to known value (should be unchanged after the function call).
       MOV     r7,#0x00055000 ; r7 = caller r7 value
       MOV     r8,#0x00000AA0 ; r8 = caller r8 value
       MOV     r11,#0xFF000000 ; Set caller frame & stack pointers to known values
       ADD     r11,r11,#16 ; r11 = 0xFF000010 (VisUAL does not support the name fp)
       ADD     sp,sp,#44 ; sp = 0xFF00002c
       ;       push parameters onto the stack
       ADR     r0,valueA ; r0 = address of valueA
       LDR     r1,[r0] ; r1 = valueA
       STR     r1,[sp,#-4]! ; push valueA onto the stack
       ADR     r0,valueB ; r0 = address of valueB
       LDR     r1,[r0] ; r1 = valueB
       STR     r1,[sp,#-4]! ; push valueB onto the stack
       ADR     r1,addrC ; r1 = addressC
       STR     r1,[sp,#-4]! ; push addressC onto the stack
       bl      calc ; call function
       LDR     r0,[r1]
       

       END     ; END OF PROGRAM


       ;       FUNCTION calc
       ;       parameters: valueA, valueB, addrC
       ;       modifies register r7 & r8
       ;       stores result at mem[addrC]
calc   STR     lr,[sp,#-4]! ; push link register (r14) onto the stack
       STR     r7,[sp,#-4]! ; push r7 onto the stack
       STR     r8,[sp,#-4]! ; push r8 onto the stack
       STR     r11,[sp,#-4]! ; push frame pointer register (r11) onto the stack

       MOV     r11,sp ; set the constant frame pointer (r11) for this function call
       SUB     sp,sp,#8 ; create a 2-word stack frame for intermediate results
       LDR     r7,[r11,#20] ; load valueB into r7
       ADD     r8,r7,r7,lsl #3 ; store 9 * B into r8
       STR     r8,[sp,#4]! ; store r8 into stack
       LDR     r8,[r11,#24] ; load valueA into r8
       ORR     r8,r7,r8 ; or r7 and r8
       LDR     r7,[r11,#-4]
       ADD     r8, r7, r8 ;
       STR     r8,[sp,#0]! ; store r8 into stack
       LDR     r7,[r11,#24] ; load valueA into r8
       ;       set r8 to 27 * valueA
       ADD     r8, r7, r7, lsl #1
       ADD     r8, r8,r7,lsl #3
       ADD     r8, r8,r7,lsl #4
       ;
       LDR     r7,[r11,#-4] ; load the partial answer from before in
       SUB     r8, r8,r7 ; final answer
       LDR     r7,[r11,#16] ; load valueB into r7
       STR     r8,[r7]

       ADD     sp,sp,#8 ; delete the 2-word stack frame
       LDR     r11,[sp,#-4]
       LDR     r8,[sp,#0]
       LDR     r7,[sp,#4]
       LDR     lr,[sp,#8]
       LDR     r15,[sp,#8]













