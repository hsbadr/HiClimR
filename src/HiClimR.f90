!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
!  HIERARCHICAL CLIMATE REGIONALIZATION (HiClimR):                     !
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
!  HiClimR package modifies and improves hierarchical clustering in R  !
!  ('hclust' function in 'stats' library), climate regionalization.    !
!  It adds a new clustering method (called, regional linkage) to the   !
!  set of available methods  together with several features including  !
!  regridding (grid2D function), coarsening spatial resolution         !
!  (coarseR function), geographic masking (geogMask function), data    !
!  thresholds, detrending and standardization preprocessing, faster    !
!  correlation function (fastCor function), and cluster validation     !
!  (validClimR and minSigCor functions). The regional linkage method   !
!  is explained in the context of a spatio-temporal problem, in which  !
!  N spatial elements (e.g., weather stations) are divided into k      !
!  regions, given that each element has a time series of length M.     !
!  It is based on inter-regional correlation distance between the      !
!  temporal means of different regions (or elements at the first       !
!  merging step). It modifies the update formulae of average linkage   !
!  method by incorporating the standard deviation of the timeseries    !
!  of the the merged region, which is a function of the correlation    !
!  between the individual regions, and their standard deviations       !
!  before merging. It is equal to the average of their standard        !
!  deviations if and only if the correlation between the two merged    !
!  regions is 100%. In this special case, the regional linkage method  !
!  is reduced to the classic average linkage clustering method. The    !
!  added features facilitate spatiotemporal analysis applications as   !
!  well as cluster validation function validClimR, which implements    !
!  an objective tree cutting to find the optimal number of clusters    !
!  for a user-specified confidence level. These include options for    !
!  preprocessing and postprocessing as well as efficient code          !
!  execution for large datasets.                                       !
!  It is applicable to any correlation-based clustering.               !
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !                                        
!  References:                                                         !
!                                                                      !
!  Badr, H. S., Zaitchik, B. F. and Dezfuli, A. K. (2015).             !
!  Hierarchical Climate Regionalization. CRAN,                         !
!  http://cran.r-project.org/package=HiClimR.                          !
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
!  Clustering Methods:                                                 !
!                                                                      !
!  0. REGIONAL linkage or minimum inter-regional correlation.          !
!  1. WARD's minimum variance or error sum of squares method.          !
!  2. SINGLE linkage or nearest neighbor method.                       !
!  3. COMPLETE linkage or diameter.                                    !
!  4. AVERAGE linkage, group average, or UPGMA method.                 !
!  5. MCQUITTY's or WPGMA method.                                      !
!  6. MEDIAN, Gower's or WPGMC method.                                 !
!  7. CENTROID or UPGMC method.                                        !
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
!  Parameters:                                                         !
!                                                                      !
!  N                 the number of points being clustered              !
!                                                                      !
!  LEN               index for lower triangle; LEN = N.N-1/2           !
!                                                                      !
!  IOPT              clustering method to be used                      !
!                                                                      !
!  VAR(N)            variances of all variables                        !
!                                                                      !
!  DISS(LEN)         dissimilarities in lower half diagonal storage    !
!                                                                      !
!  IA, IB, CRIT      history of agglomerations; dimensions N,          !
!                    first N-1 locations only used                     !
!                                                                      !
!  MEMBR, NN, DISNN  vectors of length N, used to store cluster        !
!                    cardinalities, current nearest neighbour, and     !
!                    the dissimilarity assoc. with the latter.         !
!                    MEMBR must be initialized by R to the             !
!                    default of rep(1, N).                             !
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
!  This code is modified by Hamada Badr <badr@jhu.edu> from:           !
!               File src/library/stats/src/hclust.f                    !
!  Part of the R package, http://www.R-project.org                     !
!                                                                      !
!  Copyright(C)  1995-2015  The R Core Team                            !
!                                                                      !
!  This program is free software; you can redistribute it and/or       !
!  modify it under the terms of the GNU General Public License as      !
!  published by the Free Software Foundation; either version 2 of      !
!  the License, or (at your option) any later version.                 !
!                                                                      !
!  This program is distributed in the hope that it will be useful,     !
!  but WITHOUT ANY WARRANTY; without even the implied warranty of      !
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       !
!  GNU General Public License for more details.	                       !
!                                                                      !
!  A copy of the GNU General Public License is available at            !
!  http://www.r-project.org/Licenses                                   !
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
!  HISTORY:                                                            !
!                                                                      !
!----------------------------------------------------------------------!
!  Version  |  Date      |  Comment   |  Author       |  Email         !
!----------------------------------------------------------------------!
!           |  May 1992  |  Original  |  F. Murtagh   |                !
!           |  Dec 1996  |  Modified  |  Ross Ihaka   |                !
!           |  Apr 1998  |  Modified  |  F. Leisch    |                !
!           |  Jun 2000  |  Modified  |  F. Leisch    |                !
!----------------------------------------------------------------------!
!  1.00     |  03/07/14  |  Modified  |  Hamada Badr  |  badr@jhu.edu  !
!  1.01     |  03/08/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.02     |  03/09/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.03     |  03/12/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.04     |  03/14/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.05     |  03/18/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.06     |  03/25/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.07     |  03/30/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.08     |  05/06/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!----------------------------------------------------------------------!
!  1.0.9    |  05/07/14  |  CRAN      |  Hamada Badr  |  badr@jhu.edu  !
!  1.1.0    |  05/15/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.1.1    |  07/14/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.1.2    |  07/26/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.1.3    |  08/28/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.1.4    |  09/01/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!  1.1.5    |  11/12/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  !
!----------------------------------------------------------------------!
!  1.1.6    |  01/03/15  |  GitHub    |  Hamada Badr  |  badr@jhu.edu  !
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
! COPYRIGHT(C) 2013-2015 Earth and Planetary Sciences (EPS), JHU.      !
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
!  Function: Hierarchical Climate Regionalization                      !
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
    SUBROUTINE HiClimR(N,LEN,IOPT,IA,IB,CRIT,MEMBR,VAR,DISS)
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

!  Args

    INTEGER :: N,LEN,IOPT,IA(N),IB(N),NN(N)
    DOUBLE PRECISION :: CRIT(N),MEMBR(N),DISS(LEN),DISNN(N),VAR(N)

!  Vars

    LOGICAL :: FLAG(N)
    INTEGER :: IM,JM,JJ,I,NCL,J,IND,I2,J2,K,IND1,IND2
    DOUBLE PRECISION :: INF,DMIN,D12,V12

!  External function

    INTEGER :: IOFFST

!  This was 1D+20
    DATA INF/1.D+300/

!  Initializations
    
    IM=1
    JM=1
    JJ=1
    D12=1
    V12=1
    
    DO I=1,N
        FLAG(I)= .TRUE. 
    END DO
    NCL=N

!  Carry out an agglomeration - first create list of NNs
!  Note NN and DISNN are the nearest neighbour and its distance
!  TO THE RIGHT of I.

    DO I=1,N-1
        DMIN=INF
        DO J=I+1,N
            IND=IOFFST(N,I,J)
            IF (DMIN > DISS(IND)) THEN
                DMIN=DISS(IND)
                JM=J
            END IF
        END DO
        NN(I)=JM
        DISNN(I)=DMIN
    END DO

!  REPEAT --------------------------------------------------------------

    400 CONTINUE

!  Next, determine least diss. using list of NNs
    DMIN=INF
    DO I=1,N-1
        IF (FLAG(I) .AND. DISNN(I) < DMIN) THEN
            DMIN=DISNN(I)
            IM=I
            JM=NN(I)
        END IF
    END DO
    NCL=NCL-1

!  This allows an agglomeration to be carried out.

    I2=MIN0(IM,JM)
    J2=MAX0(IM,JM)
    IA(N-NCL)=I2
    IB(N-NCL)=J2
    CRIT(N-NCL)=DMIN
    FLAG(J2)= .FALSE. 

    D12=DISS(IOFFST(N,I2,J2))

!  Update variances and correlations for the new cluster

    IF (IOPT == 0) THEN
        V12=(MEMBR(I2)**2)*VAR(I2)+(MEMBR(J2)**2)*VAR(J2)
        V12=V12+2*MEMBR(I2)*MEMBR(J2)* &
        SQRT(VAR(I2))*SQRT(VAR(J2))*(1-D12)
        V12=V12/(MEMBR(I2)+MEMBR(J2))**2
    ENDIF

    DMIN=INF
    DO K=1,N
    
        IF (FLAG(K) .AND. K /= I2) THEN
            IF (I2 < K) THEN
                IND1=IOFFST(N,I2,K)
            ELSE
                IND1=IOFFST(N,K,I2)
            ENDIF
            IF (J2 < K) THEN
                IND2=IOFFST(N,J2,K)
            ELSE
                IND2=IOFFST(N,K,J2)
            ENDIF
        
!  Update Dissimilarities
        
            !------------------------------------------------------------------!
            !     REGIONAL LINKAGE METHOD - IOPT=0.                            !
            !------------------------------------------------------------------!
            IF (IOPT == 0) THEN
                DISS(IND1)=MEMBR(I2)*SQRT(VAR(I2)/V12)*(1.0-DISS(IND1))+ &
                MEMBR(J2)*SQRT(VAR(J2)/V12)*(1.0-DISS(IND2))
                DISS(IND1)=DISS(IND1)/(MEMBR(I2)+MEMBR(J2))
                DISS(IND1)=1.0-DISS(IND1)
            !------------------------------------------------------------------!
            !     WARD'S MINIMUM VARIANCE METHOD - IOPT=1.                     !
            !------------------------------------------------------------------!
            ELSEIF (IOPT == 1) THEN
                DISS(IND1)=(MEMBR(I2)+MEMBR(K))*DISS(IND1)+ &
                (MEMBR(J2)+MEMBR(K))*DISS(IND2) - MEMBR(K)*D12
                DISS(IND1)=DISS(IND1)/(MEMBR(I2)+MEMBR(J2)+MEMBR(K))
            !------------------------------------------------------------------!
            !     SINGLE LINK METHOD - IOPT=2.                                 !
            !------------------------------------------------------------------!
            ELSEIF (IOPT == 2) THEN
                DISS(IND1)=MIN(DISS(IND1),DISS(IND2))
            !------------------------------------------------------------------!
            !     COMPLETE LINK METHOD - IOPT=3.                               !
            !------------------------------------------------------------------!
            ELSEIF (IOPT == 3) THEN
                DISS(IND1)=MAX(DISS(IND1),DISS(IND2))
            !------------------------------------------------------------------!
            !     AVERAGE LINK (OR GROUP AVERAGE) METHOD - IOPT=4.             !
            !------------------------------------------------------------------!
            ELSEIF (IOPT == 4) THEN
                DISS(IND1)=(MEMBR(I2)*DISS(IND1)+MEMBR(J2)*DISS(IND2)) &
                /(MEMBR(I2)+MEMBR(J2))
            !------------------------------------------------------------------!
            !     MCQUITTY'S METHOD - IOPT=5.                                  !
            !------------------------------------------------------------------!
            ELSEIF (IOPT == 5) THEN
                DISS(IND1)=(DISS(IND1)+DISS(IND2))/2
            !------------------------------------------------------------------!
            !     MEDIAN (GOWER'S) METHOD aka "Weighted Centroid" - IOPT=6.    !
            !------------------------------------------------------------------!
            ELSEIF (IOPT == 6) THEN
                DISS(IND1)=((DISS(IND1)+DISS(IND2))-D12/2)/2
            !------------------------------------------------------------------!
            !     Unweighted CENTROID METHOD - IOPT=7.                         !
            !------------------------------------------------------------------!
            ELSEIF (IOPT == 7) THEN
                DISS(IND1)=(MEMBR(I2)*DISS(IND1)+MEMBR(J2)*DISS(IND2)- &
                MEMBR(I2)*MEMBR(J2)*D12/(MEMBR(I2)+MEMBR(J2)))/ &
                (MEMBR(I2)+MEMBR(J2))
            ENDIF
        
            IF (I2 < K) THEN
                IF (DISS(IND1) < DMIN) THEN
                    DMIN=DISS(IND1)
                    JJ=K
                ENDIF
            ELSE  ! I2 > K

!  FIX: the rest of the else clause is a fix by JB to ensure
!  correct nearest neighbours are found when a non-monotone
!  clustering method (e.g. the centroid methods) are used

                IF(DISS(IND1) < DISNN(K)) THEN ! Find nearest neighbour I2
                    DISNN(K) = DISS(IND1)
                    NN(K) = I2
                END IF
            ENDIF
        ENDIF
    ENDDO
    MEMBR(I2)=MEMBR(I2)+MEMBR(J2)
    DISNN(I2)=DMIN
    NN(I2)=JJ

!  Update variance of the new cluter’s mean

    IF (IOPT == 0) THEN
        VAR(I2)=V12
    ENDIF

!  Update list of NNs insofar as this is required.

    DO I=1,N-1
        IF (FLAG(I) .AND. &
        ((NN(I) == I2) .OR. (NN(I) == J2))) THEN
!  (Redetermine NN of I:)
            DMIN=INF
            DO J=I+1,N
                IF (FLAG(J)) THEN
                    IND=IOFFST(N,I,J)
                    IF (DISS(IND) < DMIN) THEN
                        DMIN=DISS(IND)
                        JJ=J
                    END IF
                END IF
            END DO
            NN(I)=JJ
            DISNN(I)=DMIN
        END IF
    END DO

!  Repeat previous steps until N-1 agglomerations carried out.

    IF (NCL > 1) GOTO 400


    RETURN
    END SUBROUTINE HiClimR
!     of HiClimR()


    INTEGER FUNCTION IOFFST(N,I,J)

!  Map row I and column J of upper half diagonal symmetric matrix
!  onto vector.

    INTEGER :: N,I,J
    IOFFST=J+(I-1)*N-(I*(I+1))/2
    RETURN
    END FUNCTION IOFFST

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
!  Given a HIERARCHIC CLUSTERING, described as a sequence of           !
!  agglomerations, prepare the seq. of aggloms. and "horiz." order of  !
!  objects for plotting the dendrogram using S routine 'plclust'.      !
!                                                                      !
!  Parameters:                                                         !
!                                                                      !
!  IA, IB:       vectors of dimension N defining the agglomerations.   !
!                                                                      !
!  IIA, IIB:     used to store IA and IB values differently            !
!                (in form needed for S command 'plclust'               !
!                                                                      !
!  IORDER:       "horiz." order of objects for dendrogram              !
!                                                                      !
!  F. Murtagh, ESA/ESO/STECF, Garching, June 1991                      !
!                                                                      !
!  HISTORY                                                             !
!                                                                      !
!  Adapted from routine HCASS, which additionally determines cluster   !
!  assignments at all levels, at extra comput. expense                 !
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                                                                      !
    SUBROUTINE HCASS2(N,IA,IB,IORDER,IIA,IIB)
!                                                                      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

!  Args

    INTEGER :: N,IA(N),IB(N),IORDER(N),IIA(N),IIB(N)

!  Vars

    INTEGER :: I, J, K, K1, K2, LOC

!  Following bit is to get seq. of merges into format acceptable to plclust
!  I coded clusters as lowest seq. no. of constituents; S's 'hclust' codes
!  singletons as -ve numbers, and non-singletons with their seq. nos.

    DO I=1,N
        IIA(I)=IA(I)
        IIB(I)=IB(I)
    END DO
    DO I=1,N-2
!  In the following, smallest (+ve or -ve) seq. no. wanted
        K=MIN(IA(I),IB(I))
        DO J=I+1, N-1
            IF(IA(J) == K) IIA(J)=-I
            IF(IB(J) == K) IIB(J)=-I
        END DO
    END DO
    DO I=1,N-1
        IIA(I)=-IIA(I)
        IIB(I)=-IIB(I)
    END DO
    DO I=1,N-1
        IF (IIA(I) > 0 .AND. IIB(I) < 0) THEN
            K = IIA(I)
            IIA(I) = IIB(I)
            IIB(I) = K
        ENDIF
        IF (IIA(I) > 0 .AND. IIB(I) > 0) THEN
            K1 = MIN(IIA(I),IIB(I))
            K2 = MAX(IIA(I),IIB(I))
            IIA(I) = K1
            IIB(I) = K2
        ENDIF
    END DO


!  New part for 'ORDER'

    IORDER(1) = IIA(N-1)
    IORDER(2) = IIB(N-1)
    LOC=2
    DO I=N-2,1,-1
        DO J=1,LOC
            IF(IORDER(J) == I) THEN
!  Replace IORDER(J) with IIA(I) and IIB(I)
                IORDER(J)=IIA(I)
                IF (J == LOC) THEN
                    LOC=LOC+1
                    IORDER(LOC)=IIB(I)
                ELSE
                    LOC=LOC+1
                    DO K=LOC,J+2,-1
                        IORDER(K)=IORDER(K-1)
                    END DO
                    IORDER(J+1)=IIB(I)
                END IF
                GOTO 171
            ENDIF
        END DO
!  should never reach here
        171 CONTINUE
    END DO


    DO I=1,N
        IORDER(I) = -IORDER(I)
    END DO


    RETURN
    END SUBROUTINE HCASS2
