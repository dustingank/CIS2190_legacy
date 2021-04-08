--A4: Reverse polish form : ADA
--Written by Christopher Katsaras
--April 7th/2017
--
--***********
--Compile/run
--***********
--Type "make ada"
--Type "./a.out" to run
--
--*****************
--Known limitations
--*****************
--1.Spaces in inputted equation may cause incorrect output
--e.g 1   + 2 * (3-  2) = NOT SUPPORTED :(
--e.g 1+2*(3-2) = SUPPORTED :)
--2.Equations should be inputted with NO spaces for best results
--3.Equations cannot be longer than 40 symbols (Approved by Prof Wirth) 

with Ada.Text_IO; use Ada.Text_IO;
with Ada.integer_text_IO; use Ada.integer_text_IO;
with Ada.strings.unbounded; use ada.strings.unbounded;
with Ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;

procedure polish is

originalString: String(1 .. 40);
polishString: String(1 .. 40);
stack : String(1 .. 40);
garbageString : String(1..100);
polishLength : Integer;
length : Integer;
top : Integer;
currentChar : character;
playFlag : character;

--Function definitions
--Returns the priority of a specific symbol
function priority(sym:character) return Integer is
begin
	case sym is
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
			put_line("Invalid symbol");
			return -2;
	end case;
end priority;

--Pushes item to the stack
procedure push(sym:character) is
begin
   if(top < 40) then
   	top := top + 1;
   	stack(top) := sym;
   else
      put_line("Stack overflow!");   
   end if;
end push;

--Pops item off stack and put inserts it into the output string
procedure pop(sym:character) is
begin
   if(top > 0) then
      polishLength := polishLength + 1;
      polishString(polishLength) := stack(top);
      top := top - 1;
   else
      put_line("Stack underflow");   
   end if;   
end pop;
	
begin
   playFlag := 'Y';
   --Loops until user chooses to quit
   while (playFlag = 'Y') loop
      polishLength := 0;
      top := 1;
      stack(top) := '%';

      Put_Line("Please input an algebraic expression to convert (No spaces, please)");
      Get_Line(originalString, length);

      --Uses a state based parsing method where each character is examined individually 
      for i in 1..length loop
      		currentChar := originalString(i);
      		case currentChar is
      			when 'a'..'z' | 'A'..'Z' | '0'..'9' => 
      				polishLength := polishLength + 1;
      				polishString(polishLength) := currentChar;
      			when '%' | '+' | '-' | '*' | '/' | '^' => 
         			loop
                     if(priority(currentChar) > priority(stack(top))) then
         					push(currentChar);
                        exit;
                     else
                        pop(currentChar);    
         				end if;
                  end loop;

      			when '(' | ')' => 
      				if(currentChar = '(') then
                     push(currentChar);
                  else
                     while (priority(stack(top)) /= priority('(')) loop
                        pop(currentChar);
                     end loop;   
                     top := top - 1;
                  end if;
      			when others => 
      				put_line("Invalid operator!");
      		end case;	
      end loop;

      while top > 1 loop
         if(stack(top) = '(') then
            put_line("Unmatched bracket");
         else
            polishLength := polishLength + 1;
            polishString(polishLength) := stack(top);
         end if;
         top := top - 1;
      end loop;

      for i in 1..polishLength loop
      		put(polishString(i));
      end loop;
      new_line;
      put_line("Would you like to convert another expression? (Type Y to play again or any other key to exit)");
      get(playFlag); --Gets user input
      Get_Line(garbageString,length);--Removes any leftover values in the buffer
   end loop;
   new_line;
   put_line("Goodbye");
end polish;