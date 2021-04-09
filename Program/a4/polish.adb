-- YIzhou Wang
-- 1013411

with Ada.Text_IO; use Ada.Text_IO;
with Ada.strings.unbounded.Text_IO; use Ada.strings.unbounded.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure polish is
-- Declare variables 
algebraic_expression, reverse_polish_expression, stack: String(1 .. 40);
polish_length: Integer;
algebraic_length: Integer;
head: Integer;
current_character: character;
end_process: character;

-- Return the priority of math expression
function check_priority(input_character:character) return Integer is
begin
    case input_character is
		when ')' | '%' =>
			return -1;
		when '(' =>
			return 0;
		when '+' | '-' =>
			return 1;
		when '*' | '/' =>
			return 2;
		when '^' =>
			return 3;			
		when others =>
			return -2;
    end case;
end check_priority;

-- stack push function
procedure push(input_character:character) is
begin
    if(head < 40) then
        head := head + 1;
        stack(head) := input_character;
    else
        put_line("Error: Stack Overflow");
    end if;
end push;

-- stack pop function
procedure pop is
begin
    if(head > 0) then
        polish_length := polish_length + 1;
        reverse_polish_expression(polish_length) := stack(head);
        head := head - 1;
    else
        put_line("Error: Stack Overflow");
    end if;
end pop;

-- Get the rest of the stuff in the stack
procedure complete_reverse_expression is
begin
    while head > 1 loop
            if(stack(head) = '(') then 
                put_line("Unmatched Bracket");
            else 
                polish_length := polish_length + 1;
                reverse_polish_expression(polish_length) := stack(head);
            end if;
            head := head - 1;
        end loop;
end complete_reverse_expression;

begin
    end_process := 'Y';

    -- this loop only end when user enter N
    loop
        -- initial the variable
        polish_length := 0;
        head := 1;
        stack(head) := '%';

        -- get the originl algebraic expression
        put_line("Enter the algebraic expression(Do not put space please): ");
        get_line(algebraic_expression, algebraic_length);
        put_line("The expression your enter: "
                &to_unbounded_string(algebraic_expression(1..algebraic_length)));

        for i in 1..algebraic_length loop
            current_character := algebraic_expression(i);
            case current_character is
                -- is current character is number or character
                when '0'..'9' | 'a'..'z' | 'A'..'Z' =>
                    polish_length := polish_length + 1;
                    reverse_polish_expression(polish_length) := current_character;
                -- if current character is symbol
                when '+' | '-' | '*' | '/' | '^' | '%' | '(' | ')' =>
                    if(current_character = '(') then 
                        push(current_character);
                    elsif (current_character = ')') then
                        -- pop the stack until it hit an open bracket
                        loop
                            if ( check_priority(stack(head)) = 0) then
                                exit;
                            else
                                pop;
                            end if;
                        end loop;
                        head := head - 1;
                    -- normal math expression
                    else
                        loop
                            if (check_priority(current_character) > check_priority(stack(head))) then
                                push(current_character);
                                exit;
                            else 
                                pop;
                            end if;
                        end loop;
                    end if;
                when others =>
                    put_line("Invalid Input!");
            end case;
        end loop;

        -- output the reverse polish expression
        put_line("The Reverse Polish Expression: " 
            &to_unbounded_string(reverse_polish_expression(1..polish_length)));

        put_line("Continue coverting another expression ? (Y / N)");
        get(end_process);
        if end_process = 'N' or else end_process = 'n' then
            put_line("Shutting Down");
            exit;
        end if;
    end loop;

end polish;