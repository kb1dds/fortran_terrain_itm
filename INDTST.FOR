C INDEX file test for map reading
C	%build%
C	fortran indtst/list
C	link indtst,dl0:forlib
C	%end%
      PROGRAM INDTST
      REAL IA,XA,IO,XO,A,O
      INTEGER IXUNT,MPUNT
      INTEGER ELEV
C
      XA=-99.0
      IXUNT=1
      MPUNT=2
      OPEN(UNIT=IXUNT,NAME='INDEX.DAT',TYPE='OLD')
30    TYPE *,'ENTER LATITUDE LONGITUDE:'
      ACCEPT *,A,O
      IF(A.LE.-90)GOTO 40
      CALL MAPELV(IXUNT,MPUNT,IA,XA,IO,XO,A,O,ELEV)
35    FORMAT(' ELEVATION: ',I5,' METERS')
      TYPE 35,ELEV
      GOTO 30
40    CLOSE(UNIT=IXUNT)
      CLOSE(UNIT=MPUNT)
      STOP
      END
C
C Look up elevation from map file using index file
C Input: IXUNT : Unit of index file
C        MPUNT : Unit of current map file
C        IA    : southernmost latitude of current map
C        XA    : northernmost latitude of current map
C                (set to -99.0 if no current map loaded)
C        IO    : westernmost longitude of current map
C        XO    : easternmost longitude of current map
C        A     : desired latitude
C        O     : desired longitude
C Output: ELEV : elevation in feet or -999 if no map 
C                covers desired location
      SUBROUTINE MAPELV(IXUNT,MPUNT,IA,XA,IO,XO,A,O,ELEV)
      REAL IA,XA,IO,XO,A,O
      INTEGER I,IXUNT,MPUNT,DROW,ROW,COL,ELEV
      INTEGER*2 REC(2402)
      BYTE MAPFL(10)
C LOCATE THE CORRECT FILE USING THE INDEX
      REWIND IXUNT
C IS CORRECT FILE OPEN?
25    IF((A.GE.IA).AND.(A.LE.XA).AND.
     C(O.GE.IO).AND.(O.LE.XO))GOTO 20
C NO, CONSIDER NEXT FILE IN INDEX
15    FORMAT(F9.5,' ',F9.5,' ',F9.5,' ',F9.5,' ',10A)
      IF(XA.GE.-90)CLOSE(UNIT=MPUNT)
      XA=-99.0
      READ(IXUNT,15,END=35)IA,XA,IO,XO,MAPFL
      OPEN(UNIT=MPUNT,NAME=MAPFL,TYPE='OLD',ACCESS='DIRECT',  
     CRECORDSIZE=1201)
      GOTO 25
C DETERMINE ROW AND COL WITHIN FILE
C DROW IS THE RECORD NUMBER (RECORDS ARE PAIRS OF ROWS)
20    ROW=(XA-A)*1200+1
      COL=(O-IO)*1200+1
      DROW=(ROW-1)/2+1
C LOAD THE ROW CONTAINING THE DESIRED CELL
C NO NEED TO LOAD BEYOND DESIRED CELL...
      IF((ROW/2)*2.EQ.ROW)GOTO 55
      READ(MPUNT'DROW)(REC(I),I=1,COL)
      ELEV=REC(COL)
      RETURN
55    READ(MPUNT'DROW)(REC(I),I=1,COL+1201)
      ELEV=REC(COL+1201)
      RETURN
35    TYPE *,'MAP NOT FOUND'
      ELEV=-999
      RETURN
      END                                                                                                                                                                                                                               