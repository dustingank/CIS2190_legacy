
with Ada.Text_IO; use Ada.Text_IO;
with Ada.strings.unbounded.Text_IO; use Ada.strings.unbounded.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure reverseAda is
-- Declare variables 
algebraic_expression, reverse_polish_expression, stack: String(1 .. 40);
polish_length: Integer;
algebraic_length: Integer;
head: Integer;
current_character: character;
end_process: character;

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

procedure push(input_character:character) is
begin
    if(head < 40) then
        head := head + 1;
        stack(head) := input_character;
    else
        put_line("Error: Stack Overflow");
    end if;
end push;

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

begin
    end_process := 'Y';

    loop
        polish_length := 0;
        head := 1;
        stack(head) := '%';
        put_line("Enter the algebraic expression: ");
        get_line(algebraic_expression, algebraic_length);
        put_line("The expression your enter: "
                &to_unbounded_string(algebraic_expression(1..algebraic_length)));

        for i in 1..algebraic_length loop
            current_character := algebraic_expression(i);
            case current_character is
                when '0'..'9' | 'a'..'z' | 'A'..'Z' =>
                    polish_length := polish_length + 1;
                    reverse_polish_expression(polish_length) := current_character;
                when '+' | '-' | '*' | '/' | '^' | '%' | '(' | ')' =>
                    if(current_character = '(') then 
                        push(current_character);
                    elsif (current_character = ')') then
                        loop
                            if (check_priority('(') = check_priority(stack(head))) then
                                exit;
                            else
                                pop;
                            end if;
                        end loop;
                        head := head - 1;
                        --while(check_priority('(') /= check_priority(stack(head))) loop
                        --    pop(current_character);
                        --end loop;
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

        while head > 1 loop
            if(stack(head) = '(') then 
                put_line("Unmatched Bracket");
            else 
                polish_length := polish_length + 1;
                reverse_polish_expression(polish_length) := stack(head);
            end if;
            head := head - 1;
        end loop;
        put_line("The Reverse Polish Expression: " &to_unbounded_string(reverse_polish_expression(1..polish_length)));
        put_line("Continue coverting another expression ? (Y / N)");
        get(end_process);
        if end_process = 'N' or else end_process = 'n' then
            put_line("Shutting Down");
            exit;
        end if;
    end loop;

end reverseAda;