program sun_kink
    implicit none
    real :: currentTemp, expectTemp, trackLength, result
    real, parameter:: alpha = 11.0 * 10.**(-6.)

    currentTemp = 15.0
    expectTemp = 60.0
    trackLength = 300.0

    result = alpha * trackLength * (expectTemp - currentTemp)
    write(*,*) result

end program sun_kink