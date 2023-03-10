C INDEX file test for map reading: linear paths
C	%build%
C	fortran pthtst/list
C	link pthtst,dl0:forlib
C	%end%
      PROGRAM PTHTST
      REAL IA,XA,IO,XO,A1,O1,A2,O2
      INTEGER IXUNT,MPUNT,I,NPTS
      INTEGER ELEV(100)
C
      XA=-99.0
      IXUNT=1
      MPUNT=2
      NPTS=10
      OPEN(UNIT=IXUNT,NAME='INDEX.DAT',TYPE='OLD')
30    TYPE *,'ENTER START LATITUDE LONGITUDE:'
      ACCEPT *,A1,O1
      IF(A1.LE.-90)GOTO 40
      TYPE *,'ENTER END LATITUDE LONGITUDE:'
      ACCEPT *,A2,O2
      IF(A2.LE.-90)GOTO 40  
      CALL MAPPTH(IXUNT,MPUNT,IA,XA,IO,XO,
     CA1,O1,A2,O2,NPTS,ELEV)
35    FORMAT(' ELEVATION: ',I5,' METERS')
      DO 45 I=1,NPTS
45    TYPE 35,ELEV(I)
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
C Output: ELEV : elevation or -999 if no map 
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
      END
C
C Look up elevation along linear path
C Input: IXUNT : Unit of index file
C        MPUNT : Unit of current map file
C        IA    : southernmost latitude of current map
C        XA    : northernmost latitude of current map
C                (set to -99.0 if no current map loaded)
C        IO    : westernmost longitude of current map
C        XO    : easternmost longitude of current map
C        A1    : desired start latitude
C        O1    : desired startlongitude
C        A2    : desired end latitude
C        O2    : desired end longitude
C        NPTS  : number of elevation points to collect
C Output: ELEV : array of elevations or -999 if no map 
C                covers desired location
      SUBROUTINE MAPPTH(IXUNT,MPUNT,IA,XA,IO,XO,
     CA1,O1,A2,O2,NPTS,ELEV)
      INTEGER IXUNT,MPUNT,NPTS,I
      INTEGER ELEV(NPTS)
      REAL IA,XA,IO,XO,A1,O1,A2,O2,ASTP,OSTP
C
      ASTP=(A2-A1)/(NPTS-1)
      OSTP=(O2-O1)/(NPTS-1)
C
      DO 10 I=1,NPTS
      CALL MAPELV(IXUNT,MPUNT,IA,XA,IO,XO,
     CA1+ASTP*(I-1),O1+OSTP*(I-1),ELEV(I))
10    CONTINUE
      RETURN
      END                                                                                                                                                                                                                                                                                                                                                                                                                                                                