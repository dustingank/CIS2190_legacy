! Yizhou Wang
! 1013411
! wang15@uoguelph.ca

program fire
    implicit none

!   variable decalaration
    real :: dryBulbTemp, wetBuldTemp, windSpeed, buildUpIndex, precipitation
    real :: dryingFactor, fineFuelMois, adjustedFuelMois, fireLoadRating
    real :: grassSpredIndex, timberSpredIndex 
    integer :: currentHerbState, isSnow
    character :: boolean = 'y'

!    input of variables
    write(*,*) 'INPUT:'
    write(*,*) 'Enter the value of dry bulb temperature in degrees Fahrenheit'
    read(*,*) dryBulbTemp
    write(*,*) 'Dry bulb temperature = ', dryBulbTemp

    write(*,*) 'Enter the value of wet bulb temperature in degrees Fahrenheit'
    read(*,*) wetBuldTemp
    write(*,*) 'Wet bulb temperature = ', wetBuldTemp

    write(*,*) 'Is there snow on the ground? (y/n): '
    read(*,*) boolean
    if (boolean == 'y') then
        isSnow = 1
    else
        isSnow = 0
    end if
    write(*,*) 'Is there snow? = ', isSnow

    write(*,*) 'Enter the current wind speed:'
    read(*,*) windSpeed
    write(*,*) 'Wind speed mph? = ', windSpeed

    write(*,*) 'Enter the last value of the build up index'
    read(*,*) buildUpIndex
    write(*,*) 'Build up index = ', buildUpIndex

    write(*,*) 'what is the current herb state of the district?'
    write(*,*) '    1) Cured'
    write(*,*) '    2) Transition'
    write(*,*) '    3) Green'
    read(*,*) currentHerbState
    write (*,*) 'Herb state = ', currentHerbState

    write(*,*) 'Enter the preceding 24-hour precipitation:'
    read(*,*) precipitation
    write(*,*) 'Precipitation = ', precipitation

!   calling subroutine danger
    call danger(dryBulbTemp, wetBuldTemp, isSnow, precipitation, windSpeed, buildUpIndex, currentHerbState, &
                dryingFactor,  fineFuelMois, adjustedFuelMois, grassSpredIndex, timberSpredIndex, fireLoadRating)
    
!   Output of calculated info fomr subroutine danger
    write(*,*) '' 
    write(*,*) ''
    write(*,*) 'OUTPUT: '
    write(*,900) '  Fine Fuel Moisture          = ', fineFuelMois
    write(*,900) '  Adjusted Fuel Moisture      = ', adjustedFuelMois
    write(*,900) '  Fine Fuel Spread            = ', grassSpredIndex
    write(*,900) '  Timber Spread Index         = ', timberSpredIndex
    write(*,900) '  Fine load Index             = ', fireLoadRating
    write(*,900) '  Buildup Index               = ', buildUpIndex

    900 format(A, F10.5)
    
end program fire

subroutine danger(dryBulbTemp, wetBuldTemp, isSnow, precipitation, windSpeed, buildUpIndex, currentHerbState, &
                    dryingFactor,  fineFuelMois, adjustedFuelMois, grassSpredIndex, timberSpredIndex, fireLoadRating)
    implicit none
!   dummy variables
    real :: dryBulbTemp, wetBuldTemp, windSpeed, buildUpIndex, precipitation
    real :: dryingFactor, fineFuelMois, adjustedFuelMois, fireLoadRating
    real :: grassSpredIndex, timberSpredIndex 
    integer :: currentHerbState, isSnow

!   acturally variables 
    real, dimension(4) :: a = (/-0.185900, -0.85900, -0.059660, -0.077373/)
    real, dimension(4) :: b = (/30.0, 19.2, 13.8, 22.5/)
    real, dimension(3) :: c = (/4.5, 12.5, 27.5/)
    real, dimension(6) :: d = (/16.0, 10.0, 7.0, 5.0, 4.0, 3.0/)
    real :: different = 0.

!   declear healper function
    real :: calFineFuelMois
    real :: calDryingFactor

!   initialized values
    dryingFactor = 0.
    adjustedFuelMois = 99.
    fineFuelMois = 99.
    fireLoadRating = 0.
    
!   test to see if there is snow on the ground
    if (isSnow <= 0) then
!       there is no snow on the ground and we will compute the spread indexes
!       and fire load 
        different = dryBulbTemp - wetBuldTemp
    else
!     there is snow on the ground and the timberSpredIndex and grassSpredIndex index
!     must be set to zero. With a zero timberSpredIndex the fire load is must be set to zero
!     also zero. Build up will be adjusted for precipitation
        grassSpredIndex = 0.
        timberSpredIndex = 0.

        if (precipitation - 0.1 <= 0) then
            return
        else
            ! precipitation exceeded .1 inches and we reduce the build up index
            buildUpIndex = -50. * ALOG(1. - (1.- EXP(-buildUpIndex / 50.))*EXP( -1.175 * (precipitation - .1)))

            if (buildUpIndex < 0) then
                buildUpIndex = 0
                return
            else
                return
            end if
        end if
    end if

!   calculate the fine fuel moisture with the helper function
    fineFuelMois = calFineFuelMois(different, a, b, c)

!   calculate the drying factor with the helper function
    dryingFactor = calDryingFactor(fineFuelMois, d)

!   test to see if the fine fuel mosture is one or less
    if (fineFuelMois - 1. < 0) then
!       if fine fuel moisture is nor or less we set it to one
        fineFuelMois = 1
    end if

!   add 5 percent fine fuel moisture for each herb stage greater then one
    fineFuelMois = fineFuelMois + (currentHerbState - 1) * 5.

!   adjust the build up index for precipitation before adding the drying factor
    if (precipitation - .1 <= 0) then
!       after correction for rain, if nay, we are ready to add today's
!       drying factor to obtain the current build up index
        buildUpIndex = buildUpIndex + dryingFactor
    else
!       precipitation exceeded 0.10 inches we must redece the
!       build up index by an amount equal to the rain fall
        buildUpIndex = -50. * ALOG(1. - (1.- exp(-buildUpIndex / 50.))*exp( -1.175 * (precipitation - .1)))

        if (buildUpIndex < 0) then
            buildUpIndex = 0.0
        end if

        buildUpIndex = buildUpIndex + dryingFactor
    end if
    
!   compute the adjusted fuel moisture
    adjustedFuelMois = .9 * fineFuelMois + .5 + 9.5 * exp(-buildUpIndex / 50.)

!   test to see if the fuel moistures are greater then 30 percent, if they are, set their index value to 1
    if (adjustedFuelMois - 30. >= 0) then ! line 109 (fireORIG.for)
        if (fineFuelMois - 30. >= 0) then ! line 110 (fireORIG.for)
!           fine fuel moisture is greater then 30 percent, thus we set the grassSpredIndex
!           and timber spread index to one
            grassSpredIndex = 1.
            timberSpredIndex = 1.
            return
        else
            timberSpredIndex = 1.
!           test to see if the wind speed is greater than 14 mph
            if (windSpeed - 14. >= 0) then ! line 118 (fireORIG.for)
                grassSpredIndex  = .00918 * (windSpeed + 14.) * (33.- fineFuelMois)**1.65 - 3.
                if (grassSpredIndex - 99. > 0) then ! line 130 (fireORIG.for)
                    grassSpredIndex = 99.
                    if (timberSpredIndex - 99. > 0) then ! line 133 (fireORIG.for)
                        timberSpredIndex = 99.    
                    end if
                end if
            else
                grassSpredIndex = .01312 * (windSpeed + 6.) * (33.- fineFuelMois)**1.65 - 3.
                if ( timberSpredIndex - 1. <= 0) then ! line 122 (fireORIG.for)
                    timberSpredIndex = 1.
                    if (grassSpredIndex - 1. < 0) then ! line 124 (fireORIG.for)
                        grassSpredIndex = 1.
                    end if
                end if
            end if
        end if
    else
        if (windSpeed - 14. >= 0) then ! line 119 (fireORIG.for)
!           wind speed is greater then 14mph, use a a different formula
            timberSpredIndex = .00918 * (windSpeed + 14.) * (33.- adjustedFuelMois)**1.65 - 3.
            grassSpredIndex  = .00918 * (windSpeed + 14.) * (33.- fineFuelMois)**1.65 - 3.

            if (grassSpredIndex - 99. > 0) then ! line 130 (fireORIG.for)
                grassSpredIndex = 99.
            end if

            if (timberSpredIndex - 99. > 0) then ! line 133 (fireORIG.for)
                timberSpredIndex = 99.
            end if
        else
            timberSpredIndex = .01312 * (windSpeed + 6.) * (33.- adjustedFuelMois)**1.65 - 3.
            grassSpredIndex = .01312 * (windSpeed + 6.) * (33.- fineFuelMois)**1.65 - 3.

            if (timberSpredIndex - 1. <= 0) then !line 122 (fireORIG.for)
                grassSpredIndex = 1.
            end if
        end if
    end if

!   we have noe computed the grass and timber spread indexes
!   of the motional fire danger rating system. We have the
!   build up index and now er will compute the fire load rating
    if (timberSpredIndex > 0) then ! line 138
        if (buildUpIndex > 0) then ! line 139
!           both timber spread and build up are greater then zero
            fireLoadRating =1.75 * ALOG10( timberSpredIndex ) + .32*ALOG10( buildUpIndex ) - 1.640

!           ensure that fire load rating is greater than zero, otherwise set it to zero
            if (fireLoadRating > 0) then ! line 146
                fireLoadRating = 10. ** fireLoadRating
                return
            else 
                fireLoadRating = 0.
                return
            end if
        else
!           it is necessary that neither tumber spread nor build up be zero
!           if either timber spread or build up is zero, fire load is zero
            return
        end if
    else 
        return
    end if
end subroutine danger

! helper function for calculate the fine fuel moisture
function calFineFuelMois(inputOne, arrayA, arrayB, arrayC)
    real :: calFineFuelMois
    real :: inputOne
    real, dimension(4) :: arrayA
    real, dimension(4) :: arrayB
    real, dimension(3) :: arrayC
    integer :: i = 0
    
    do i = 1, 4
!       if the condition never met, set i to 4
        if (i == 4) then
            exit
        else if (inputOne - arrayC(i) <= 0) then
            exit
        end if
    end do
    
!   calculate the fine fue moisture
    calFineFuelMois = arrayB(i) * exp( arrayA(i) * inputOne)
    return
end function

!   helper function for calculate the drying factor
function calDryingFactor(inputOne, arrayD)
    real :: calDryingFactor
    real :: inputOne
    real, dimension(6) :: arrayD
    integer :: i = 0

    do i = 1, 7
!       if the condition never met, set drying factor to 7
        if ( i == 7) then
            calDryingFactor = 7
        else if (inputOne - arrayD(i) > 0) then
            calDryingFactor = i - 1
            exit
        end if  
    end do
    return
end function