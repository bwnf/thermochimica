
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
    !    Date          Programmer          Description of change
    !    ----          ----------          ---------------------
    !    30/11/2018    M. Poschmann        File creation.
    !
    ! Purpose:
    ! ========
    !
    ! Test implementation of restart data usage.
    !
    !-------------------------------------------------------------------------------------------------------------

program nucProf

    USE ModuleThermoIO
    USE ModuleThermo

    implicit none

    integer                                :: j

    do j = 1, 1000
        ! Reset Thermochimica:
        call ResetThermoAll

        dTemperature            = 1173.15D0
        dPressure               = 1D0
        dElementMass(94)        = 0D0
        dElementMass(93)        = 0D0
        dElementMass(92)        = 0.56849D-2
        dElementMass(60)        = 0.18974d-6
        dElementMass(59)        = 0D0
        dElementMass(58)        = 0.75956d-7
        dElementMass(57)        = 0.3831d-7
        dElementMass(56)        = 0.99634d-7
        dElementMass(55)        = 0.12584d-8
        dElementMass(54)        = 0D0
        dElementMass(53)        = 0D0
        dElementMass(52)        = 0D0
        dElementMass(46)        = 0.10003d-4
        dElementMass(45)        = 0.73875d-6
        dElementMass(44)        = 0.42121d-5
        dElementMass(43)        = 0D0
        dElementMass(42)        = 0.14263d-4
        dElementMass(40)        = 0.11667d-6
        dElementMass(39)        = 0D0
        dElementMass(38)        = 0.86762d-7
        dElementMass(37)        = 0D0
        dElementMass(8)         = 1.14467207D-2
        dElementMass(1)         = 0D0
        cInputUnitTemperature   = 'K'
        cInputUnitPressure      = 'atm'
        cInputUnitMass          = 'moles'
        cThermoFileName         = DATA_DIRECTORY // 'Example7c.dat'

        ! Parse the ChemSage data-file:
        call ParseCSDataFile(cThermoFileName)

        ! Call Thermochimica:
        call Thermochimica

        ! print *, j

    end do

end program nucProf
