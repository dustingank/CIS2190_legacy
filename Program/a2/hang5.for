C      GAME OF HANGMAN BY DAVE AHL, DIGITAL
C      BASED ON A BASIC PROGRAM WRITTEN BY KEN AUPPERLE
C            HALF HALLOW HILLS H.S. DIX HILLS NY
C      CONVERTED TO FORTRAN 77 BY M.WIRTH, APRIL 2012
C       
       PROGRAM HANGMAN 
       CHARACTER P(12,12)
       CHARACTER D(20), N(26), A*20, GUESS, B*20, ANS 
       INTEGER U(50)
       INTEGER Q, M, I, J, W, T1, R, L 
       REAL RND 

       CHARACTER*20 DICT(50)

       DATA DICT/'gum','sin','for','cry','lug','bye','fly','ugly', 
     M           'each','from','work','talk','with','self',
     M           'pizza','thing','feign','fiend','elbow','fault',
     M           'dirty','budget','spirit','quaint','maiden',
     M           'escort','pickax','example','tension','quinine',
     M           'kidney','replica','sleeper','triangle',
     M           'kangaroo','mahogany','sergeant','sequence',
     M           'moustache','dangerous','scientist','different',
     M           'quiescent','magistrate','erroneously',
     M           'loudspeaker','phytotoxic','matrimonial',
     M           'parasympathomimetic','thigmotropism'/
       WRITE (*,*) "THE GAME OF HANGMAN"
10     DO 16 I = 1,12
           DO 15 J = 1,12
               P(I,J) = " "
15         CONTINUE
16     CONTINUE
       DO 18 I = 1,20
           D(I) = "-"
18     CONTINUE
       DO 20 I = 1,26
           N(I) = " "
20     CONTINUE
       DO 25 I = 1,50
           U(I) = 0
25     CONTINUE
       DO 30 I = 1,12
           P(I,1) = "X"
30     CONTINUE
       DO 40 J = 1,7
           P(1,J) = "X"
40     CONTINUE
       P(2,7) = "X"
       C=1
       W=50
       M=0 
       IF (C .LT. W) GO TO 100
       WRITE (*,*) "You did all the words"; GO TO 999
100    RND=RAND()
       Q=CEILING(RND*50)
       IF (U(Q) - 1) 120,100,120
120    U(Q) = 1; C=C+1; T1=0
       
       A = DICT(Q)
       L = LEN_TRIM(A) 
       WRITE (*,*) D(1:L)
170    WRITE (*,*) "Here are the letters you used: "
       DO 180 I = 1,26
           IF (N(I) .EQ. ' ') GO TO 200
           WRITE (*,'(AA$)') N(I),","
180    CONTINUE

200    WRITE (*,*) " "
       WRITE (*,*) "What is your guess? "; R=0
       READ (*,*) GUESS 
       DO 210 I = 1,26
           IF (N(I) .EQ. " ") GO TO 250 
           IF (ICHAR(N(I)) - ICHAR(GUESS)) 210,205,210
205        WRITE (*,*) "You guessed that letter before";
           GO TO 170
210    CONTINUE
       WRITE (*,*) "Invalid character"; GO TO 170
250    N(I)=GUESS; T1=T1+1
       DO 260 I = 1,L
           IF (A(I:I) .EQ. GUESS) THEN
               D(I) = GUESS; R=R+1
           END IF
260    CONTINUE
270    IF (R .EQ. 0) THEN
           GO TO 290
       ELSE 
           GO TO 300
       END IF
290    M=M+1; GO TO 400       
300    DO 305 I = 1,L
           IF (ICHAR(D(I)) - ICHAR("-")) 305,320,305
305    CONTINUE
       GO TO 390
320    WRITE (*,*) D(1:L)
330    WRITE (*,*) "What is your guess for the word? "
       READ (*,*) B
340    IF (A .EQ. B) GO TO 360
       WRITE (*,*) "Wrong. Try another letter"; GO TO 170
360    WRITE (*,*) "Right! It took you ",T1," guesses"
370    WRITE (*,*) "Do you want another word? (Y/N) "
       READ (*,*) ANS
       IF (ICHAR(ANS) - ICHAR("Y")) 380,10,380
380    WRITE (*,*) "It's been fun! Bye for now."; GO TO 999
390    WRITE (*,*) "You found the word."; GO TO 370
400    WRITE (*,*) "Sorry, that letter isn't in the word."
410    GO TO (415,420,425,430,435,440,445,450,455,460), M
415    WRITE (*,*) "First we draw a head."; GO TO 470
420    WRITE (*,*) "Now we draw a body."; GO TO 470
425    WRITE (*,*) "Next we draw an arm."; GO TO 470
430    WRITE (*,*) "This time it's the other arm."; GO TO 470
435    WRITE (*,*) "Now, let's draw the right leg."; GO TO 470
440    WRITE (*,*) "This time we draw the left leg."; GO TO 470
445    WRITE (*,*) "Now we put up a hand."; GO TO 470
450    WRITE (*,*) "Next the other hand."; GO TO 470
455    WRITE (*,*) "Now we draw one foot."; GO TO 470
460    WRITE (*,*) "Here's the other foot -- You're hung!!." 
470    GO TO (480,490,500,510,520,530,540,550,560,570), M
480    P(3,6) = "-"; P(3,7) = "-"; P(3,8) = "-"; P(4,5) = "("; 
       P(4,6) = "."; 
481    P(4,8) = "."; P(4,9) = ")"; P(5,6) = "-"; P(5,7) = "-"; 
       P(5,8) = "-"; GO TO 580
490    DO 495 I = 6,9
           P(I,7) = "X" 
495    CONTINUE
       GO TO 580
500    DO 505 I = 4,7
           P(I,I-1) = "\" 
505    CONTINUE
       GO TO 580
510    P(4,11) = "/"; P(5,10) = "/"; P(6,9) = "/"; P(7,8) = "/"; 
       GO TO 580
520    P(10,6) = "/"; P(11,5) = "/"; GO TO 580 
530    P(10,8) = "\"; P(11,9) = "\"; GO TO 580 
540    P(3,11) = "\"; GO TO 580 
550    P(3,3) = "/"; GO TO 580 
560    P(12,10) = "\"; P(12,11) = "-"; GO TO 580 
570    P(12,3) = "-"; P(12,4) = "/" 
580    DO 585 I = 1,12
           WRITE (*,*) (P(I,J),J=1,12)
585    CONTINUE 
590    IF (M - 10) 170,600,170
600    WRITE (*,*) "Sorry, you loose. The word was ", A
610    WRITE (*,*) "You missed that one."; GO TO 370 

999    WRITE (*,*) "Ending..." 
       END
