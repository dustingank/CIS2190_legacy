program triangle
    real :: a, b, c, theta
    write (*,*) 'Enter the length of the hypotenuse C: '
    read (*,*) c
    write (*,*) 'Enter the angle theta in degrees: '
    read (*,*) theta
    a = c * cos(theta)
    b = c * sin(theta / 57.3) ! need to divide 180 / pi (or 57.3) when using sin
    write (*,*) 'The length of the adjacent side is ', a
    write (*,*) 'The length of the opposite side is ', b
end program triangle