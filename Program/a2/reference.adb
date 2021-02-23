--  GAME OF HANGMAN
--  Nathan Reymer
--  March 2nd 2015
--  0797359

with Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Numerics;
with Ada.Numerics.Discrete_Random;



procedure hangman is
    -- ASCII Art Hangman
    procedure printTitle is
    begin
        Put_Line(" ");
        Put_Line("$$\   $$\");
        Put_Line("$$ |  $$ |");
        Put_Line("$$ |  $$ | $$$$$$\  $$$$$$$\   $$$$$$\  $$$$$$\$$$$\   $$$$$$\  $$$$$$$\");
        Put_Line("$$$$$$$$ | \____$$\ $$  __$$\ $$  __$$\ $$  _$$  _$$\  \____$$\ $$  __$$\");
        Put_Line("$$  __$$ | $$$$$$$ |$$ |  $$ |$$ /  $$ |$$ / $$ / $$ | $$$$$$$ |$$ |  $$ |");
        Put_Line("$$ |  $$ |$$  __$$ |$$ |  $$ |$$ |  $$ |$$ | $$ | $$ |$$  __$$ |$$ |  $$ |");
        Put_Line("$$ |  $$ |\$$$$$$$ |$$ |  $$ |\$$$$$$$ |$$ | $$ | $$ |\$$$$$$$ |$$ |  $$ |");
        Put_Line("\__|  \__| \_______|\__|  \__| \____$$ |\__| \__| \__| \_______|\__|  \__|");
        Put_Line("                              $$\   $$ |                                  ");
        Put_Line("                              \$$$$$$  |                                  ");
        Put_Line("                               \______/ ");
        Put_Line(" ");
        Put_Line("");

    end printTitle;
    -- ASCII Art for tries
    procedure printHang(tries: in Natural) is
    begin
        case tries is
            when 0 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |");
            Put_Line("  |");
            Put_Line("  |");
            Put_Line("  |");
            Put_Line("  |");
            Put_Line("__|__");

            when 1 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |     (0_0)");
            Put_Line("  |");
            Put_Line("  |");
            Put_Line("  |");
            Put_Line("  |");
            Put_Line("__|__");

            when 2 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |     (0_0)");
            Put_Line("  |       |");
            Put_Line("  |");
            Put_Line("  |");
            Put_Line("  |");
            Put_Line("__|__");

            when 3 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |     (0_0)");
            Put_Line("  |       | ");
            Put_Line("  |       | ");
            Put_Line("  |");
            Put_Line("  |");
            Put_Line("__|__");

            when 4 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |     (0_0)");
            Put_Line("  |       | ");
            Put_Line("  |       | ");
            Put_Line("  |      /  ");
            Put_Line("  |");
            Put_Line("__|__");

            when 5 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |     (0_0)");
            Put_Line("  |       | ");
            Put_Line("  |       | ");
            Put_Line("  |      / \ ");
            Put_Line("  |");
            Put_Line("__|__");

            when 6 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |     (0_0)");
            Put_Line("  |      /| ");
            Put_Line("  |       | ");
            Put_Line("  |      / \  ");
            Put_Line("  |");
            Put_Line("__|__");

            when 7 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |     (0_0)");
            Put_Line("  |      /|\ ");
            Put_Line("  |       | ");
            Put_Line("  |      / \ ");
            Put_Line("  |");
            Put_Line("__|__");
            when 8 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |     (0_0)");
            Put_Line("  |      /|\ ");
            Put_Line("  |       | ");
            Put_Line("  |     _/ \ ");
            Put_Line("  |");
            Put_Line("__|__");
            when 9 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |     (0_0)");
            Put_Line("  |      /|\ ");
            Put_Line("  |       | ");
            Put_Line("  |     _/ \_ ");
            Put_Line("  |");
            Put_Line("__|__");
            when 10 =>
            Put_Line("");
            Put_Line("    _______ ");
            Put_Line("  |/      | ");
            Put_Line("  |     (X_X)");
            Put_Line("  |      /|\ ");
            Put_Line("  |       | ");
            Put_Line("  |     _/ \_ ");
            Put_Line("  |");
            Put_Line("__|__");
            when others =>
            null;
        end case;
    end printHang;

--  Declare variables, not war
    guess: character;
    wordGuess: String(1..60);
    realWord:Unbounded_String;
    compareGuess:Unbounded_String;
    realLen : Natural :=0;
    word: Unbounded_String;
    Guesses: Unbounded_String;
    len : Natural;
    crapCount: Natural:=0;
    check:Natural;
    gCheck:Natural:=0;
    File: file_type;
    type string_array is array(1..235887) of Unbounded_String;
    DICT:string_array;
    count:Natural:=1;
    dashCount:Natural:=0;

--  Random number definition
    type Rand_Range is range 1..235887;
    package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);
    seed : Rand_Int.Generator;
    Num : Rand_Range;

--  Play again code
    wordCheck:Natural:=0;
    startChoice: Integer:=0;
    startString:String(1..40);
    playAgain:String(1..100);
begin
    --Starting graphic
    printTitle;
    --Reset All variables
    wordCheck:=0;
    dashCount:=0;
    check:=0;
    gCheck:=0;
    crapCount:=0;
    word:=To_Unbounded_String("");
    realWord:=To_Unbounded_String("");
    realLen:=0;
    len:=0;
    Main_Loop:
    loop
        Put_Line("1. For manual word, 2. For random word");
        Ada.Integer_Text_IO.Get (startChoice);
        Skip_Line;
        Start_Loop:
--      Loop until player enters 1 or 2
        while startChoice /= 1 or startChoice /=2 loop
            if(startChoice=1) then

--              User defined words

                Put_Line("Enter the word:");
                Get_Line(startString,len);
                Put("The word is: ");
                Put(startString(1..len));
                startString:=To_Lower(startString);
                New_Line;
                realWord:=To_Unbounded_String(startString);
                realWord:=Ada.Strings.Unbounded.Trim(realWord,Ada.Strings.Both);
                realLen:=len;
                for i in 1..realLen loop
                    word:=word&"-";
                end loop;
                exit Start_Loop;

--              Randomly selected word

                elsif(startChoice=2) then
                    Put_Line("Enter the filename of the dictionary (ex. words.txt)");
                    Get_Line(startString,len );
                    New_Line;
                    open(File,in_file,startString);
                    loop
                        exit when end_of_file(File);
                        get_line(File,DICT(count));
                        count:=count+1;
                    end loop;
                    close (File);
                    Rand_Int.Reset(seed);
                    Num := Rand_Int.Random(seed);
--                  Random number is set to ~230K, so if count is lower, get a new random number
                    loop
                        if(Integer(Num) > count) then
                            Num := Rand_Int.Random(seed);
                        end if;
                        exit when Integer(Num)<=count;
                    end loop;
--                  Strip word
                    realWord:=DICT(Integer(Num));
                    realWord:=Ada.Strings.Unbounded.Trim(realWord,Ada.Strings.Both);
                    realLen:=Length(realWord);
                    for i in 1..realLen loop
                        word:=word&"-";
                    end loop;
                    exit Start_Loop;
                else
                    Put_Line("Not a choice, enter again");
                    Ada.Integer_Text_IO.Get (startChoice);
                    Skip_Line;
                end if;
            end loop Start_Loop;
            Put_Line(realWord);
            crapCount:=0;

            loop
--              Reset everything for new game
                wordCheck:=0;
                dashCount:=0;
                check:=0;
                gCheck:=0;
                printHang(crapCount);

--              End conditon for tries
                if (crapCount=10) then
                    New_Line;
                    Put_Line("Sorry, you ran out of guesses!");
                    Put("The word was: ");
                    Put(realWord);
                    New_Line;
                    exit;
                end if;
                New_Line;
                Put_Line("Word:");
                Put(word);
                New_Line;
                Put_Line("What is your guess? ");
                Get_Line( wordGuess, len );
                guess:=wordGuess(1);

--              Check to see if in fact character
                if(Is_Letter(guess)=false) then
                    gCheck:=1;
                    Put_Line("Not a character!");
                end if;
                guess:=To_Lower(guess);

--              Check for already entered letters
                for i in 1..Length(Guesses) loop
                    if(Element(Guesses,i))=guess then
                        Put_Line("You've guessed already!");
                        gCheck:=1;
                        check:=1;
                    end if;
                end loop;

--              Only add to guessed letters if valid
                if gCheck=0 then
                    New_Line;
                    Put("Guess: ");
                    Put(guess);
                    Guesses:= Guesses & guess;
                    Guesses:=Guesses & ',';
                end if;
                New_Line;
                Put_Line("All Guesses: ");
                Put_Line(Guesses);
                New_Line;

                --Replace '-'' with real letters
                for i in 1..realLen loop
                    if(Element(realWord,i))=guess then
                        Replace_Element(word, i, guess);
                        check:=1;
                    end if;
                    if((Element(word,i))='-') then
                        dashCount:=dashCount+1;
                    end if;
                end loop;

--              Add to noose count if letter isnt found
                if(check=0) then
                    crapCount:=crapCount+1;
                end if;

--              If the word has no more '-' game ends
                if (dashCount=0) then
                    printHang(crapCount);
                    New_Line;
                    Put_Line("Word: ");
                    Put_Line(realWord);
                    Put_Line("Yay! You guessed the correct word!");
                    Put("You had ");
                    crapCount:=10-crapCount;
                    Put(Integer'Image(crapCount));
                    Put_Line(" Guesses left");
                    exit;
                end if;

                --End condition for no more "-"
                if (dashCount=0) then
                    printHang(crapCount);
                    New_Line;
                    Put_Line("Word: ");
                    Put_Line(realWord);
                    Put_Line("Yay! You guessed the correct word!");
                    Put("You had ");
                    crapCount:=10-crapCount;
                    Put(Integer'Image(crapCount));
                    Put_Line(" Guesses left");
                    exit;
                end if;
            end loop;
--          Prompt for a new game
            Put_Line("Do you want to Play again? (Y/N)");
            Get_Line(playAgain,len);
            word:=To_Unbounded_String("");
            realWord:=To_Unbounded_String("");
            realLen:=0;
            len:=0;
--          Will continue if player doesnt put N or n
            exit when playAgain(playAgain'First)='N' or playAgain(playAgain'First)='n';
        end loop Main_Loop;
        Put_Line("Thanks for playing!");
    end;