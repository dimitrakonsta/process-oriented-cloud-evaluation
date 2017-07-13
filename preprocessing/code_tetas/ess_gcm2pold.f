C ================================================================
C
C     CALCULATION OF THE SOLAR HEIGHT AND THE AZIMUTH IN GIVEN PLACE 
C     FOR SEVERAL HOURS OF THE DAY
C
C ================================================================
C
ch    WRITE(6,*)'DAY, MONTH, IAN, XLAT, XLON (DEG.DECIMAL) :'
ch    READ(5,*)DAY,MONTH,IAN,XLAT,XLON
      real a(12)
      parameter (latmax=96)
      real latmod(latmax)
      integer*4 latmax      
      DAY=01
      IAN= 1982
      XLON=0
      open(15,file='tetas_lmdz96')

      open(14,file=
     & 'latitude_lmdz96')
      do ilat=1,latmax
          read(14,*) latmod(ilat)  !lmdz     
      enddo
c
      do ilat=1,latmax
      XLAT=latmod(ilat)
c      do XLAT=-80,80,2.5
       do   MONTH=1,12
       
      CALL NDAY(DAY,MONTH,IAN,JQ)
      WRITE(6,100)DAY,MONTH,IAN,JQ,XLAT,XLON
  100 FORMAT(2X,I2,'/',I2,'/',I4,3X,'(QUANT. ',I3,')',3X,'LATITUDE ',
     &F6.2,3X,'LONGITUDE ',F6.2,/,2X,62(1H=),/,/)
ch      WRITE(6,101)
  101 FORMAT(2X,'HEURE :  ',' H.SOL',4X,'TETA0',3X,'MUZERO',3X,
     &'AZIMUT',/,2X,43(1H-),/)
  10  CONTINUE
       
      PI=3.1416

c  FOR PARASOL
c     TSM_EQ=01.34   (Mean Solar Time = Local Mean Time , downward node)

      IHS=98.23    ! for Aqua , inclination to the Equator in degrees.
      TSM_EQ=13.34 !(Mean Solar time = Local Mean Time , ascending node at the l'Equator)
      DELTAH=ASIN(TAN(XLAT*PI/180)/TAN(IHS*PI/180))  ! LAT and IHS in degrees
      TSM_LAT=TSM_EQ-1/15*DELTAH  ! in hour 

c     WRITE(6,*)'HOUR TU (DECIMAL HOUR) :'
c     READ(5,*)TU
      CALL POSSOL(JQ,TSM_LAT,XLON,XLAT,ELEV,PHI0,AMUZERO)
      TET0=90.0-ELEV
ch      WRITE(6,102)TU,ELEV,TET0,AMUZERO,PHI0
  102 FORMAT(2X,F5.2,' :  ',F6.2,3X,F6.2,3X,F6.4,3X,F6.2)
c     GOTO 10
      a(MONTH)=TET0
      write(15,105) XLAT,a(MONTH)
      enddo
      write(6,*) XLAT, a
      enddo
  105 FORMAT(2X,F9.4,2X,F9.4)    
      END

c
C
C ================================================================
C
      SUBROUTINE POSSOL (JQUANT,TSM,XLON,XLAT,ELEV,PHI0,AMUZERO) 
C     SUBROUTINE POSSOL (JQUANT,TU,XLON,XLAT,ELEV,PHI0,AMUZERO) 
C     SOLAR POSITION (ZENITHAL ANGLE ASOL,AZIMUTHAL ANGLE PHI0 
C                     IN DEGREES)                             
C     JDAY IS THE NUMBER OF THE DAY IN THE MONTH                       
C     JQUANT IS THE NUMBER OF THE DAY IN THE YEAR 
                                                                      
      PI=ACOS(-1.)
      FAC=PI/180.                                                     
                                                                     
      J=JQUANT
  3   CONTINUE
C
C    MEAN SOLAR TIME (DECIMAL HOUR)
                                                                        
c     TSM=TU+XLON/15.                                                  
      XLO=XLON*FAC                                                      
      XLA=XLAT*FAC                                                     
      XJ=FLOAT(J)                                                       
      TET=2.*PI*XJ/365.
                                                                       
C    TIME EQUATION (IN mn.dec)                                         
      A1=.000075
      A2=.001868
      A3=.032077
      A4=.014615
      A5=.040849
      ET=A1+A2*COS(TET)-A3*SIN(TET)-A4*COS(2.*TET)-A5*SIN(2.*TET)         
      ET=ET*12.*60./PI
                                                                        
C     TRUE SOLAR TIME                                                  
                                                                      
      TSV=TSM+ET/60.                                                    
      TSV=(TSV-12.)                                                    
                                                                        
C     HOUR ANGLE                                                        
                                                                       
      AH=TSV*15.*FAC                                                    
                                                                        
C     SOLAR DECLINATION   (IN RADIAN)                                  
                                                                        
      B1=.006918
      B2=.399912
      B3=.070257
      B4=.006758
      B5=.000907
      B6=.002697
      B7=.001480
      DELTA=B1-B2*COS(TET)+B3*SIN(TET)-B4*COS(2.*TET)+B5*SIN(2.*TET)-
     &B6*COS(3.*TET)+B7*SIN(3.*TET)
                                                                        
C     ELEVATION,AZIMUTH                                               
                                                                      
      AMUZERO=SIN(XLA)*SIN(DELTA)+COS(XLA)*COS(DELTA)*COS(AH)           
      ELEV=ASIN(AMUZERO)                                                
      AZ=COS(DELTA)*SIN(AH)/COS(ELEV)                                  
      if(az.gt.1) az=1
      if(az.lt.-1) az=-1
      CAZ=(-COS(XLA)*SIN(DELTA)+SIN(XLA)*COS(DELTA)*COS(AH))/COS(ELEV)
      AZIM=ASIN(AZ)                                                    
      IF(CAZ.LE.0.) AZIM=PI-AZIM                                       
      IF(CAZ.GT.0.AND.AZ.LE.0) AZIM=2*PI+AZIM                         
      AZIM=AZIM+PI                                                     
      PI2=2*PI                                                         
      IF(AZIM.GT.PI2) AZIM=AZIM-PI2                                    
      ELEV=ELEV*180./PI                                                
                                                                        
C     CONVERSION IN DEGREES                                            
                                                                      
      ASOL=90.-ELEV                                                     
      PHI0=AZIM/FAC                                                   
      RETURN                                                           
      END                                                              

C
C =======================================================
C
      SUBROUTINE NDAY(JDAY,MONTH,IAN,J)
C
C     DELIVER THE QUANTIEME DAY ACCORDING TO DAY BETWEEN 1 AND 31, MONTH
C     BETWEEN 1 AND 12 AND YEAR BETWEEN 1 AND 99
C
      IF (MONTH.LE.2) GOTO 1   
      IF (MONTH.GT.8) GOTO 2  
      J=31*(MONTH-1)-((MONTH-1)/2)-2+JDAY
      IF(MOD(IAN,4).GT.0.)GOTO 3
       J=J+1
       GOTO 3
    1 J=31*(MONTH-1)+JDAY
      GOTO 3
    2 J=31*(MONTH-1)-((MONTH-2)/2)-2+JDAY
      IF(MOD(IAN,4).GT.0.)GOTO 3
       J=J+1
       GOTO 3
    3  RETURN
       END
       
        
