!A4: Reverse polish form : Fortran
!Written by Christopher Katsaras
!April 7th/2017
!
!***********
!Compile/run
!***********
!Type "make fortran" or "gfortran polish.f95" to compile 
!Type "./a.out" to run
!
!*****************
!Known limitations
!*****************
!1.Spaces in inputted equation may cause incorrect output
!e.g 1   + 2 * (3-  2) = NOT SUPPORTED :(
!e.g 1+2*(3-2) = SUPPORTED :) 
!2.Equations should be inputted with NO spaces for best results
!3.Equations cannot be longer than 40 symbols (Approved by Prof Wirth)

program polish

    implicit none 
    character (len = 40) :: originalString, polishString, stack
    integer :: answerLength, i, polishLength, priority
    character :: playFlag
    integer top
    
    
    playFlag = 'Y'
    
    !Loops until user chooses to quit
    do while(playFlag == 'Y')
        polishLength = 0
        top = 1
        stack(top:top) = '%'
        write(*,*) "Please input an algebraic expression to convert (No spaces, please)"
        read(*,'(A)') originalString
        write(*,*) originalString
        answerLength = len_trim(originalString)
    
        !Uses a state based parsing method where each character is examined individually
        do i=1,answerLength
            select case (originalString(i:i))
                case ('%','+','-','*','/','^')
                    do
                        if (priority(originalString(i:i)) > priority(stack(top:top))) then
                            call push(originalString, stack)
                            exit
                        else 
                            call pop(polishString,stack)               
                        endif
                    end do
                case ('(',')')
                    if(originalString(i:i) == '(') then
                        call push(originalString,stack);
                    else if(originalString(i:i) == ')') then
                        do while(priority(stack(top:top)) /= priority('('))
                            call pop(polishString,stack)
                        end do
                        top = top - 1
                    end if
                case ('a':'z','A':'Z','0':'9')
                    polishLength = polishLength + 1
                    polishString(polishLength:polishLength) = originalString(i:i)
                case default
                    write(*,*) "Invalid operator!"        
            end select
        end do
    
        do
            if(top <= 1) then
                exit
            end if
            if(stack(top:top) == '(') then
                write(*,*) "Unmatched bracket"    
            else
                polishLength = polishLength + 1
                polishString(polishLength:polishLength) = stack(top:top)    
            end if
            top = top - 1 
        end do
    
        write(*,*) polishString(1:polishLength);
    
        write(*,*) 'Would you like to convert another expression? (Type Y to play again or any other key to exit)'
        read(*,*) playFlag !Prompts the user if they would like to convert another expression
    
    end do
    
    write(*,*) 'Goodbye!'
    
    !Subroutine and function definitions
    contains 
    !Pushes item to the stack
    subroutine push(originalString, stack)
        character (len=*) :: originalString, stack
        integer temp
        if(top < 41) then
            temp = top + 1
            top = temp
            stack(temp:temp) = originalString(i:i)
        else 
            write(*,*) "Stack overflow!"
        end if;    
    return 
    end subroutine push
    
    !Pops item off stack and put inserts it into the output string
    subroutine pop(polishString, stack)
        character (len=*) :: polishString, stack
        integer temp
        if(top > 1) then
            polishLength = polishLength + 1
            polishString(polishLength:polishLength) = stack(top:top)
            temp = top - 1
            top = temp
        else
            write(*,*) "Stack underflow!"    
        end if;    
    return
    end subroutine pop
end program polish
    
!Returns the priority of a specific symbol
integer function priority(sym)
    character :: sym
    select case(sym)
        case(')','%')
            priority = -1
        case('(')
            priority = 0
        case('+','-')   
            priority = 1
        case('*','/')
            priority = 2
        case('^')
            priority = 3        
    end select
end function priority