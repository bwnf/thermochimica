

    !-------------------------------------------------------------------------------------------------------------
    !
    ! DISCLAIMER
    ! ==========
    !
    ! All of the programming herein is original unless otherwise specified.  Details of contributions to the
    ! programming are given below.
    !
    !
    ! Revisions:
    ! ==========
    !
    !    Date          Programmer        Description of change
    !    ----          ----------        ---------------------
    !    09/02/2013    M.H.A. Piro       Original code
    !
    !
    ! Purpose:
    ! ========
    !
    ! The purpose of this application test is to ensure that Thermochimica computes the correct results for a
    ! sample problem representing the Zr-H binary system.  Unlike other tests involving CEF phases, this particular
    ! system contains phases where there is only one constituent on the first sublattice and the mixing terms
    ! represent constituents mixing on the second sublattice (i.e., other phases mix constituents on the first
    ! sublattice).  A reference for the thermodynamic database for this test follows:
    !
    !   N. Dupin, I. Ansara, C. Servant, C. Toffolon, C. Lemaignan, J.C. Brachet, "A Thermodynamic Database for
    !   Zirconium Alloys," Journal of Nuclear Materials, 275 (1999) 287-295.
    !
    ! This test considers the same system as TestThermo25.f90, but a different region of the phase diagram.
    !
    !-------------------------------------------------------------------------------------------------------------


program TestThermo27

    USE ModuleThermoIO
    USE ModuleThermo

    implicit none

    integer :: STATUS = 0


    ! Specify units:
    cInputUnitTemperature  = 'K'
    cInputUnitPressure     = 'atm'
    cInputUnitMass         = 'moles'
    cThermoFileName        = '../data/ZRHD_MHP.dat'

    ! Specify values:
    dPressure              = 1D0
    dTemperature           = 300D0
    dElementMass(1)        = 0.05D0
    dElementMass(40)       = 1D0 - dElementMass(1)

    ! Parse the ChemSage data-file:
    call ParseCSDataFile(cThermoFileName)

    ! Call Thermochimica:
    call Thermochimica

    ! Check results:
    if (INFOThermo == 0) then
        if ((DABS(dMolFraction(8) - 1.9093D-6)/1.9093D-6 < 1D-3).AND. &
        (DABS(dMolFraction(10) - 0.78724D0)/0.78724D0 < 1D-3).AND. &
        (DABS(dGibbsEnergySys - (-15463.4D0))/(-15463.4D0) < 1D-3)) then
            ! The test passed:
            print *, 'TestThermo27: PASS'
        else
            ! The test failed.
            print *, 'TestThermo27: FAIL <---'
            STATUS  = 1
        end if
    else
        ! The test failed.
        print *, 'TestThermo27: FAIL <---'
        STATUS  = 1
    end if

    ! Reset Thermochimica:
    call ResetThermo

    call EXIT(STATUS)
end program TestThermo27