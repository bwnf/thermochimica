subroutine CalculateCompositionSUBG(iSolnIndex)

    USE ModuleThermo
    USE ModuleThermoIO
    USE ModuleGEMSolver

    implicit none

    integer :: i, j, k, l, m, ii, jj
    integer :: iSolnIndex, iSPI, nPhaseElements
    integer :: iFirst, iLast, nSub1, nSub2, iMax
    real(8) :: dSum, dMax, dSumElementQuads, dSumElementPairs,dMolesPairs
    real(8) :: dZa, dZb, dZx, dZy!, dXtot, dYtot
    real(8), allocatable, dimension(:) :: dXi, dYi, dNi
    real(8), allocatable, dimension(:,:) :: dXij, dNij
    ! X_ij/kl corresponds to dMolFracion


    ! Only proceed if the correct phase type is selected:
    if (.NOT. (cSolnPhaseType(iSolnIndex) == 'SUBG' .OR. cSolnPhaseType(iSolnIndex) == 'SUBQ')) return

    ! Define temporary variables for sake of convenience:
    iFirst = nSpeciesPhase(iSolnIndex-1) + 1
    iLast  = nSpeciesPhase(iSolnIndex)
    iSPI = iPhaseSublattice(iSolnIndex)
    nSub1 = nSublatticeElements(iSPI,1)
    nSub2 = nSublatticeElements(iSPI,2)

    ! Allocate allocatable arrays:
    if (allocated(dXi)) deallocate(dXi)
    if (allocated(dYi)) deallocate(dYi)
    if (allocated(dNi)) deallocate(dNi)
    if (allocated(dXij)) deallocate(dXij)
    if (allocated(dNij)) deallocate(dNij)
    j = iLast - iFirst + 1
    nPhaseElements = nSub1 + nSub2
    allocate(dXi(nPhaseElements),dYi(nPhaseElements),dNi(nPhaseElements))
    allocate(dXij(nSub1,nSub2))
    allocate(dNij(nSub1,nSub2))

    ! Initialize variables:
    dXi                               = 0D0
    dYi                               = 0D0
    dNi                               = 0D0
    dXij                              = 0D0
    dNij                              = 0D0

    ! Compute X_i and Y_i
    ! Do cations first:
    dSum = 0D0
    do i = 1, nSub1
        do k = 1, nPairsSRO(iSPI,2)
            l = iFirst + k - 1
            dZa = dCoordinationNumber(iSPI,k,1)
            dZb = dCoordinationNumber(iSPI,k,2)
            if (i == iPairID(iSPI,k,1))  then
                dNi(i) = dNi(i) + (dMolFraction(l) / dZa)
                dYi(i) = dYi(i) + (dMolFraction(l) / 2)
            end if
            if (i == iPairID(iSPI,k,2))  then
                dNi(i) = dNi(i) + (dMolFraction(l) / dZb)
                dYi(i) = dYi(i) + (dMolFraction(l) / 2)
            end if
        end do
        dSum = dSum + dNi(i)
    end do
    print *, "Cation fractions:"
    do i = 1, nSub1
        dXi(i) = dNi(i) / dSum
        if (iSublatticeElements(iSPI,1,i) > 0) then
            print *, cElementName(iSublatticeElements(iSPI,1,i)), dXi(i)
        else if (iSublatticeElements(iSPI,1,i) == -1) then
            print *, 'Va          ', dXi(i)
        end if
    end do
    ! Do anions now:
    dSum = 0D0
    do i = 1, nSub2
        j = i + nSub1
        do k = 1, nPairsSRO(iSPI,2)
            l = iFirst + k - 1
            dZx = dCoordinationNumber(iSPI,k,3)
            dZy = dCoordinationNumber(iSPI,k,4)
            if (j == iPairID(iSPI,k,3))  then
                dNi(j) = dNi(j) + (dMolFraction(l) / dZx)
                dYi(j) = dYi(j) + (dMolFraction(l) / 2)
            end if
            if (j == iPairID(iSPI,k,4))  then
                dNi(j) = dNi(j) + (dMolFraction(l) / dZy)
                dYi(j) = dYi(j) + (dMolFraction(l) / 2)
            end if
        end do
        dSum = dSum + dNi(j)
    end do
    print *, "Anion fractions:"
    do i = 1, nSub2
        j = i + nSub1
        dXi(j) = dNi(j) / dSum
        if (iSublatticeElements(iSPI,2,i) > 0) then
            print *, cElementName(iSublatticeElements(iSPI,2,i)), dXi(j)
        else if (iSublatticeElements(iSPI,2,i) == -1) then
            print *, 'Va          ', dXi(j)
        end if
    end do

    dSum = 0D0
    do m = 1, nPairsSRO(iSPI,1)
        i = iConstituentSublattice(iSPI,1,m)
        ii = iSublatticeElements(iSPI,1,i)
        j = iConstituentSublattice(iSPI,2,m)
        jj = iSublatticeElements(iSPI,2,j)
        if (i > 0) then
            do k = 1, nPairsSRO(iSPI,2)
                l = iFirst + k - 1
                dZa = dCoordinationNumber(iSPI,k,1)
                dZb = dCoordinationNumber(iSPI,k,2)
                if ((i == iPairID(iSPI,k,1)) .AND. ((j + nSub1) == iPairID(iSPI,k,3)))  then
                    dNij(i,j) = dNij(i,j) + (dMolFraction(l) / dZa) / dStoichPairs(iSPI,m,ii)
                end if
                if ((i == iPairID(iSPI,k,1)) .AND. ((j + nSub1) == iPairID(iSPI,k,4)))  then
                    dNij(i,j) = dNij(i,j) + (dMolFraction(l) / dZa) / dStoichPairs(iSPI,m,ii)
                end if
                if ((i == iPairID(iSPI,k,2)) .AND. ((j + nSub1) == iPairID(iSPI,k,3)))  then
                    dNij(i,j) = dNij(i,j) + (dMolFraction(l) / dZb) / dStoichPairs(iSPI,m,ii)
                end if
                if ((i == iPairID(iSPI,k,2)) .AND. ((j + nSub1) == iPairID(iSPI,k,4)))  then
                    dNij(i,j) = dNij(i,j) + (dMolFraction(l) / dZb) / dStoichPairs(iSPI,m,ii)
                end if
            end do
        else if ((i == -1) .AND. (j > 0)) then
            do k = 1, nPairsSRO(iSPI,2)
                l = iFirst + k - 1
                dZx = dCoordinationNumber(iSPI,k,3)
                dZy = dCoordinationNumber(iSPI,k,4)
                if ((i == iPairID(iSPI,k,1)) .AND. ((j + nSub1) == iPairID(iSPI,k,3)))  then
                    dNij(i,j) = dNij(i,j) + (dMolFraction(l) / dZx) / dStoichPairs(iSPI,m,jj)
                end if
                if ((i == iPairID(iSPI,k,1)) .AND. ((j + nSub1) == iPairID(iSPI,k,4)))  then
                    dNij(i,j) = dNij(i,j) + (dMolFraction(l) / dZx) / dStoichPairs(iSPI,m,jj)
                end if
                if ((i == iPairID(iSPI,k,2)) .AND. ((j + nSub1) == iPairID(iSPI,k,3)))  then
                    dNij(i,j) = dNij(i,j) + (dMolFraction(l) / dZy) / dStoichPairs(iSPI,m,jj)
                end if
                if ((i == iPairID(iSPI,k,2)) .AND. ((j + nSub1) == iPairID(iSPI,k,4)))  then
                    dNij(i,j) = dNij(i,j) + (dMolFraction(l) / dZy) / dStoichPairs(iSPI,m,jj)
                end if
            end do
        end if
        dSum = dSum + dNij(i,j)
    end do

    ! Use most abundant element on 1st sublattice to convert # of moles
    dMax = 0D0
    do i = 1, nSub1
        ii = iSublatticeElements(iSPI,1,i)
        if (ii > 0) then
            if (dNi(i) > dMax) then
                dMax = dNi(i)
                iMax = ii
            end if
        end if
    end do
    dSumElementQuads = 0D0
    do k = 1, nPairsSRO(iSPI,2)
        l = iFirst + k - 1
        dSumElementQuads = dSumElementQuads + dStoichSpecies(l,iMax)*dMolesSpecies(l)
    end do
    dSumElementPairs = 0D0
    do m = 1, nPairsSRO(iSPI,1)
        i = iConstituentSublattice(iSPI,1,m)
        j = iConstituentSublattice(iSPI,2,m)
        dSumElementPairs = dSumElementPairs + dStoichPairs(iSPI,m,iMax)*dNij(i,j)
    end do

    dMolesPairs = dSum*dSumElementQuads/dSumElementPairs
    print *, ""
    print *, dMolesPairs, " Moles of pairs, fractions:"
    do m = 1, nPairsSRO(iSPI,1)
        i = iConstituentSublattice(iSPI,1,m)
        j = iConstituentSublattice(iSPI,2,m)
        dXij(i,j) = dNij(i,j) / dSum
        print *, cPairName(iSPI,m), dXij(i,j)
    end do



    ! Deallocate allocatable arrays:
    deallocate(dXi,dYi,dNi,dXij,dNij)

end subroutine CalculateCompositionSUBG
