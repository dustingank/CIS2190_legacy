! YIzhou Wang
! 1013411

program reverse_polish
    implicit none
    
    !Declear the variables
    character (len = 40):: stack
    character (len = 40):: algebraic_expression
    character (len = 40):: reverse_polish_expression
    character :: end_process
    integer :: is_continue = 1
    integer :: index, head
    integer :: algebraic_length, polish_length

    ! Declear the healper function
    integer :: check_priority

    do
        algebraic_length = 0
        polish_length = 0

        head = 1
        stack(head:head) = '%'

        ! get the user input and display the input
        write(*,*) "Enter the algebraic expression(Do not leave the sapce): "
        read(*,'(A)') algebraic_expression
        write(*,*) ''
        write(*,*) "The expression your enter: ", algebraic_expression

        algebraic_length = len_trim(algebraic_expression)

        do index = 1, algebraic_length, 1
            select case (algebraic_expression(index:index))
                ! if current character is character or number, assign is to result
                case('0':'9', 'a':'z', 'A':'Z')
                    polish_length = polish_length + 1
                    reverse_polish_expression(polish_length:polish_length) = algebraic_expression(index:index)
                ! if the current character is math expression
                case('+','-','*','/','%','^','(', ')')
                    if(algebraic_expression(index:index) == '(') then
                        call push(algebraic_expression, stack, index, head)
                    elseif (algebraic_expression(index:index) == ')') then
                        do
                            if (check_priority('(') .eq. 0) then
                                exit
                            else
                                call pop(reverse_polish_expression, stack, head, polish_length)
                            end if
                        end do
                        head = head - 1        
                    else
                        do
                            if (check_priority(algebraic_expression(index:index)) > check_priority(stack(head:head))) then
                                call push(algebraic_expression, stack, index, head)
                                exit
                            else 
                                call pop(reverse_polish_expression, stack, head, polish_length)          
                            endif
                        end do
                    end if
                
                case default
                    write(*,*) "Invalid Input!"
            end select
        end do

        ! Get the rest of the stuff in the stack
        call complete_reverse_expression(reverse_polish_expression, stack, polish_length, head)
        
        ! output the reverse polish expression
        write(*,*) "The Reverse Polish Expression: ", reverse_polish_expression(1:polish_length);

        write(*,*) 'Continue coverting another expression ? (Y / N)'
        read(*,*) end_process
        if ((end_process == 'N') .or. (end_process == 'n')) then
            is_continue = 0
        end if
        if (is_continue == 0) exit
    end do
end program reverse_polish

! Return the priority of math expression
integer function check_priority(input_character)
    character :: input_character

    select case(input_character)
        case(')','%')
            check_priority = -1
        case('(')
            check_priority = 0
        case('+','-')
            check_priority = 1
        case('*','/')
            check_priority = 2
        case('^')
            check_priority = 3
    end select
    return
end function

! stack push function
subroutine push(algebraic_expression, stack, index, head)
    character(len=40), intent(in):: algebraic_expression
    character(len=40), intent(inout):: stack
    integer, intent(in):: index
    integer, intent(inout):: head

    if (head <= 40) then
        head = head + 1
        stack(head:head) = algebraic_expression(index:index)
    end if;
    return 
end subroutine push

! stack pop function
subroutine pop(reverse_polish_expression, stack, head, polish_length)
    character(len=40), intent(inout):: reverse_polish_expression
    character(len=40), intent(inout):: stack
    integer, intent(inout):: head
    integer, intent(inout):: polish_length

    if (head > 1) then
        polish_length = polish_length + 1
        reverse_polish_expression(polish_length:polish_length) = stack(head:head)
        head = head - 1
    end if
end subroutine pop
! Get the rest of the stuff in the stack
subroutine complete_reverse_expression(reverse_polish_expression, stack, polish_length, head) 
    character(len=40), intent(inout):: reverse_polish_expression
    character(len=40), intent(inout):: stack
    integer, intent(inout):: head
    integer, intent(inout):: polish_length
    do
        if(head <= 1) then
            exit
        end if
        if(stack(head:head) == '(') then
            write(*,*) "Unmatched bracket"    
        else
            polish_length = polish_length + 1
            reverse_polish_expression(polish_length:polish_length) = stack(head:head)    
        end if
        head = head - 1 
    end do
end subroutine complete_reverse_expression
