      PROGRAM FIRE
     
C     Variable declarations

C     Input of variables

      CALL DANGER(dry,wet,isnow,precip,wind,buo,iherb,
     \            df,ffm,adfm,grass,timber,fload)

C     Output of calculated info from DANGER
      
      END


      SUBROUTINE DANGER(DRY,WET,ISNOW,PRECIP,WIND,BUO,IHERB,
     /     DF,FFM,ADFM,GRASS,TIMBER,FLOAD)
C     ROUTINE FOR COMPUTING NATIONAL FIRE DANGER RATINGS AND FIRE LOAD INDEX
C     DATA NEEDED FOR THE CALCULATIONS ARE=
C     DRY,    DRY BULB TEMPERATURE
C     WET,    WET BULB TEMPERATURE
C     ISNOW,  SOME POSITIVE NON ZERO NUMBER IF THERE IS SNOW ON THE GROUND
C     WIND,   THE CURRENT WIND SPEED IN MILES PER HOUR
C     BUO,    THE LAST VALUE OF THE BUILD UP INDEX
C     IHERB,  THE CURRENT HERB STATE OF THE DISTRICT 1=CURED, 2=TRANSITION, 3=GREEN
C     DATA RETURNED FROM THE SUBROUTINE ARE
C     DRYING FACTOR AS                            DF
C     FINE FUEL MOISTURE AS                       FFM
C     ADJUSTED (10 DAY LAG) FUEL MOISTURE AS      ADFM
C     GRASS SPREAD INDEX WILL BE RETURNED AS      GRASS
C     TIMBER SPREAD INDEX WILL BE RETURNED AS     TIMBER
C     FIRE LOAD RATING (MAN-HOUR BASE) AS         FLOAD
C     BUILD UP INDEX WILL BE RETURNED AS          BUO
      DIMENSION A(4), B(4), C(3), D(6)
      FFM= 99.
      ADFM= 99.
      DF=0.
      FLOAD=0.
C     THESE ARE THE TABLE VALUES USED IN COMPUTING THE DANGER RATINGS
      A(1) = -0.185900
      A(2) = -0.85900
      A(3) = -0.059660
      A(4) = -0.077373
      B(1) = 30.0
      B(2) = 19.2
      B(3) = 13.8
      B(4) = 22.5
      C(1) = 4.5
      C(2) = 12.5
      C(3) = 27.5
      D(1) = 16.0
      D(2) = 10.0
      D(3) = 7.0
      D(4) = 5.0
      D(5) = 4.0
      D(6) = 3.0
C     TEST TO SEE IF THERE IS SNOW ON THE GROUND

      IF(ISNOW) 5,5,1
C     THERE IS SNOW ON THE GROUND AND THE TIMBER AND GRASS SPREAD INDEXES
C     MUST BE SET TO ZERO. WITH A ZERO TIMBER SPREAD THE FIRE LOAD IS
C     ALSO ZERO. BUILD UP WILL BE ADJUSTED FOR PRECIPITATION.
    1 GRASS=0.
      TIMBER=0.
      IF ( PRECIP - .1) 4,4,2
C     PRECIPITATION EXCEEDED .1 INCHES AND WE REDUCE THE BUILD UP INDEX
    2 BUO=-50.*ALOG(1.-(1.-EXP(-BUO/50.))*EXP( -1.175*(PRECIP-.1)))
      IF ( BUO ) 3,4,4
    3 BUO=0.
    4 RETURN
C     THERE IS NO SNOW ON THE GROUND AND WE WILL COMPUTE THE SPREAD INDEXES
C     AND FIRE LOAD
    5 DIF=DRY-WET
      DO 6 I=1,3
      IF( DIF-C(I)) 7,7,6
    6 CONTINUE
      I=4
    7 FFM=B(I)*EXP(A(I)*DIF)
C     WE WILL NOW FIND THE DRYING FACTOR FOR THE DAY
      DO 8 I=1,6
      IF (FFM-D(I)) 8,8,9
    8 CONTINUE
      DF=7
      GO TO 10
    9 DF=I-1
C     TEST TO SEE IF THE FINE FUEL MOISTURE IS ONE OR LESS
C     IF FINE FUEL MOISTURE IS ONE OR LESS WE SET IT TO ONE
   10 IF (FFM-1.) 11,12,12
   11 FFM=1.
C     ADD 5 PERCENT FINE FUEL MOISTURE FOR EACH HERB STAGE GREATER THAN ONE
   12 FFM = FFM + ( IHERB-1 ) * 5.
C     WE MUST ADJUST THE BUI FOR PRECIPITATION BEFORE ADDING THE DRYING FACTOR
      IF (PRECIP -.1) 15,15,13

C     PRECIPITATION EXCEEDED 0.10 INCHES WE MUST REDUCE THE
C     BUILD UP INDEX (BUO) BY AN AMOUNT EQUAL TO THE RAIN FALL
   13 BUO=-50.*ALOG(1.-(1.-EXP(-BUO/50.))*EXP(-1.175*(PRECIP-.1)))
      IF (BUO) 14,15,15
   14 BUO=0.0
C     AFTER CORRECTION FOR RAIN, IF ANY, WE ARE READY TO ADD TODAY'S
C     DRYING FACTOR TO OBTAIN THE CURRENT BUILD UP INDEX
   15 BUO=BUO+DF
C     WE WILL ADJUST THE GRASS SPREAD INDEX FOR HEAVY FUEL LAGS
C     THE RESULT WILL BE THE TIMBER SPREAD INDEX
C     THE ADJUSTED FUEL MOISTURE, ADFM, ADJUSTED FOR HEAVY FUELS, WILL
C     NOW BE COMPUTED
      ADFM = .9*FFM +.5 +9.5*EXP(-BUO/50.)
C     TEST TO SEE IF THE FUEL MOISTURES ARE GREATER THAN 30 PERCENT.
C     IF THEY ARE, SET THEIR INDEX VALUES TO 1.
      IF ( ADFM-30. ) 19,16,16
   16 IF ( FFM-30. ) 18,17,17
C     FINE FUEL MOISTURE IS GREATER THAN 30 PERCENT, THUS WE SET THE GRASS
C     AND TIMBER SPREAD INDEXES TO ONE.
   17 GRASS = 1.
      TIMBER = 1.
      RETURN
   18 TIMBER = 1.
C     TEST TO SEE IF THE WIND SPEED IS GREATER THAN 14 MPH
      IF ( WIND-14. ) 21,25,25
   19 IF ( WIND-14. ) 20,24,24
   20 TIMBER = .01312*(WIND+6.) * (33.-ADFM)**1.65 - 3.
   21 GRASS = .01312*(WIND+6.) * (33.-FFM)**1.65 - 3.
      IF ( TIMBER-1. ) 22,22,28
   22 TIMBER = 1.
      IF ( GRASS-1. ) 23,28,28
   23 GRASS = 1.
      GO TO 28
C     WIND SPEED IS GREATER THAN 14 MPH. WE USE A DIFFERENT FORMULA.
   24 TIMBER = .00918*(WIND+14.) * (33.-ADFM)**1.65 - 3.
   25 GRASS  = .00918*(WIND+14.) * (33.-FFM)**1.65 - 3.
      IF ( GRASS-99. ) 28,28,26

   26 GRASS = 99.
      IF ( TIMBER-99. ) 28,28,27
   27 TIMBER = 99.
C     WE HAVE NOW COMPUTED THE GRASS AND TIMBER SPREAD INDEXES
C     OF THE NATIONAL FIRE DANGER RATING SYSTEM. WE HAVE THE
C     BUILD UP INDEX AND NOW WE WILL COMPUTE THE FIRE LOAD RATING
   28 IF ( TIMBER ) 30,30,29
   29 IF ( BUO ) 30,30,31
C     IT IS NECESSARY THAT NEITHER TIMBER SPREAD NOR BUILD UP BE ZERO
C     IF EITHER TIMBER SPREAD OR BUILD UP IS ZERO, FIRE LOAD IS ZERO
   30 RETURN
C     BOTH TIMBER SPREAD AND BUILD UP ARE GREATER THAN ZERO
   31 FLOAD=1.75*ALOG10( TIMBER ) + .32*ALOG10( BUO ) - 1.640
C     ENSURE THAT FLOAD IS GREATER THAN ZERO, OTHERWISE SET IT TO ZERO.
      IF ( FLOAD ) 32,32,33
   32 FLOAD = 0.
      RETURN
   33 FLOAD = 10. ** FLOAD
      RETURN
      END