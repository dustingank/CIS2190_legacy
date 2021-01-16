program radioactive_decay
    implicit none
    real :: time, halfTime, materialAmount, materialInitialAmount, lambda
    ! real, parameter :: e = 2.71828

    write (*,*) 'Enter the time, t'
    read (*,*) time
    write (*,*) 'Enter the half time, T'
    read (*,*) halfTime
    write (*,*) 'Enter the amount of material at time t, N'
    read (*,*) materialAmount

    lambda = log(2.0) / halfTime
    materialInitialAmount = materialAmount * exp(lambda * time)

    write(*,*) materialInitialAmount
    
end program radioactive_decay 
