C Testing that BIL terrain files make sense
C	%build%
C	fortran mptst2/list
C	link mptst2,dl0:forlib
C	run mptst2
C	%end%
      PROGRAM MPTST2
C 
      INTEGER*2 HGHT1(2402),HGHT2(2402)
      INTEGER*4 I,J,K
C
      DO 50 K=1,2
      IF(K.EQ.2) GOTO 60
      OPEN(UNIT=1,NAME='39078.BIL',TYPE='OLD',RECORDSIZE=1201,
     CACCESS='DIRECT')
      OPEN(UNIT=2,NAME='39077.BIL',TYPE='OLD',RECORDSIZE=1201,
     CACCESS='DIRECT')
      GOTO 70
60    CLOSE(UNIT=1)
      CLOSE(UNIT=2)
      OPEN(UNIT=1,NAME='38078.BIL',TYPE='OLD',RECORDSIZE=1201,
     CACCESS='DIRECT')
      OPEN(UNIT=2,NAME='38077.BIL',TYPE='OLD',RECORDSIZE=1201,
     CACCESS='DIRECT')
C
70    DO 40 J=1,10
      TYPE 32,J
32    FORMAT($I3,'|')
      READ(1'(J-1)*60+1)(HGHT1(I),I=1,2402)
      READ(2'(J-1)*60+1)(HGHT2(I),I=1,2402)
      DO 20 I=1,10
      TYPE 30,HGHT1((I-1)*120+1)
30    FORMAT($I4,' ')
20    CONTINUE
      DO 22 I=1,10
      TYPE 30,HGHT2((I-1)*120+1)
22    CONTINUE
      TYPE 35
35    FORMAT(' ')
40    CONTINUE
50    CONTINUE
      END
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   