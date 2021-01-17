program wave_breaking
    implicit none
    real :: wavePeriod, waveHeight, beachSlope, B
    real, parameter :: gAcceleration = 981.0

    write(*,*) 'Enter beach slope, wave height, wave period in correct order'
    read(*,*) beachSlope, waveHeight, wavePeriod
    B = waveHeight / (981 * beachSlope * wavePeriod **(2))

    if (B < 0.003) then 
        write(*,*) 'suring'
    else if (B > 0.068) then 
        write(*,*) 'spilling'
    else
        write(*,*) 'plunging'
    end if

end program wave_breaking