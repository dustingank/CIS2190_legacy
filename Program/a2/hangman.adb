-- Yizhou Wang
-- 1013411

with ada.text_io; use ada.text_io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Numerics;
with ada.numerics.discrete_random;

procedure hangman is 
missed,totalWords,tryCount,remainedLetter,wordLength, count,index: integer;
isInputCorrect, isRoundContinue: integer;
guess, isGameContinue: character;
chosenWord: unbounded_string;

b: string(1..26);
len: integer;

-- create a 2D character array type
type Two_Dimensional_Char_Array is array (positive range <>, positive range <>) of character;
subtype Twleve_Square is Two_Dimensional_Char_Array (1..12, 1..12);

correctLetter: array (1..20) of character;
usedLetter: array (1..26) of character;
usedWord: array (1..50) of integer;
print: Twleve_Square;

type dictionary is array(1..50) of unbounded_string;
words: constant dictionary := (to_unbounded_string("gum"), to_unbounded_string("sin"), to_unbounded_string("for"), to_unbounded_string("cry"), to_unbounded_string("lug"),
                      to_unbounded_string("bye"), to_unbounded_string("fly"), to_unbounded_string("ugly"), to_unbounded_string("each"), to_unbounded_string("from"),
                      to_unbounded_string("work"), to_unbounded_string("talk"), to_unbounded_string("with"), to_unbounded_string("self"), to_unbounded_string("pizza"),
                      to_unbounded_string("thing"), to_unbounded_string("feign"), to_unbounded_string("fiend"), to_unbounded_string("elbow"), to_unbounded_string("fault"),
                      to_unbounded_string("dirty"), to_unbounded_string("budget"), to_unbounded_string("spirit"), to_unbounded_string("quaint"), to_unbounded_string("maiden"),
                      to_unbounded_string("escort"), to_unbounded_string("pickax"), to_unbounded_string("example"), to_unbounded_string("tension"), to_unbounded_string("quinine"),
                      to_unbounded_string("kidney"), to_unbounded_string("replica"), to_unbounded_string("sleeper"), to_unbounded_string("triangle"), to_unbounded_string("kangaroo"),
                      to_unbounded_string("mahogany"), to_unbounded_string("sergeant"), to_unbounded_string("sequence"), to_unbounded_string("moustache"), to_unbounded_string("dangerous"),
                      to_unbounded_string("scientist"), to_unbounded_string("different"), to_unbounded_string("quiescent"), to_unbounded_string("magistrate"), to_unbounded_string("erroneously"),
                      to_unbounded_string("loudspeaker"), to_unbounded_string("phytotoxic"), to_unbounded_string("matrimonial"), to_unbounded_string("parasympathomimetic"), to_unbounded_string("thigmotropism"));

-- for randomly generntor
type randRange is new Integer range 1..50;
package Rand_Int is new ada.numerics.discrete_random(randRange);
use Rand_Int;
gen: Generator;
randomNum: randRange;

-- dispaly the hangman image 
procedure printHangImage(tries: in Natural; graph: in out Twleve_Square) is
begin
    case tries is 
        when 1 =>
            put_line("First we draw a head.");
            graph(3,6) := '-'; graph(3,7) := '-'; graph(3,8) := '-'; graph(4,5) := '(';
            graph(4,6) := '.';
            graph(4,8) := '.'; graph(4,9) := ')'; graph(5,6) := '-'; graph(5,7) := '-'; 
            graph(5,8) := '-';
        when 2 =>
            put_line("Now we draw a body.");
            for i in 6..9 loop
                graph(i,7) := 'X';
            end loop;
        when 3 =>
            put_line("Next we draw an arm");
            for i in 4..7 loop
                graph(i, i - 1) := '\';
            end loop;
        when 4 =>
            put_line("This time it's the other arm.");
            graph(4,11) := '/'; graph(5,10) := '/'; graph(6,9) := '/'; graph(7,8) := '/';
        when 5 =>
            put_line("Now, let's draw the right leg");
            graph(10,6) := '/'; graph(11,5) := '/';
        when 6 =>
            put_line("This time we draw the left leg");
            graph(10,8) := '\'; graph(11,9) := '\';
        when 7 =>
            put_line("Now we put a hand");
            graph(3,11) := '\';
        when 8 =>
            put_line("Next the other hand");
            graph(3,3) := '/';
        when 9 =>
            put_line("Now we draw one foot");
            graph(12,10) := '\'; graph(12,11) := '-';
        when 10 =>
            put_line("Here's the other foot -- You're hung!!.");
            graph(12,3) := '-'; graph(12,4) := '/';
        when others =>
            put_line("error");
    end case;
end printHangImage;

-- display the welcome image
procedure printWelcomeMessage is 
begin
    Put_Line(" ");
    Put_Line("##\   ##\");
    Put_Line("## |  ## |");
    Put_Line("## |  ## | ######\  #######\   ######\  ######\####\   ######\  #######\");
    Put_Line("######## | \____##\ ##  __##\ ##  __##\ ##  _##  _##\  \____##\ ##  __##\");
    Put_Line("##  __## | ####### |## |  ## |## /  ## |## / ## / ## | ####### |## |  ## |");
    Put_Line("## |  ## |##  __## |## |  ## |## |  ## |## | ## | ## |##  __## |## |  ## |");
    Put_Line("## |  ## |\####### |## |  ## |\####### |## | ## | ## |\####### |## |  ## |");
    Put_Line("\__|  \__| \_______|\__|  \__| \____## |\__| \__| \__| \_______|\__|  \__|");
    Put_Line("                              ##\   ## |                                  ");
    Put_Line("                              \######  |                                  ");
    Put_Line("                               \______/ ");
    Put_Line(" ");
    Put_Line("");

end printWelcomeMessage;


-- main control of the game
begin
    printWelcomeMessage;
    -- how many rounds have been play
    count := 1;
    -- total words in the game
    totalWords := 50;

    --initial used word list
    for i in 1..50 loop
        usedWord(i) := 0;
    end loop;

    loop
        index := 0;
        isInputCorrect := 0;
        isRoundContinue := 0;
        missed := 0;
        -- reset the seeds
        reset(gen);

        -- initial the hang image array
        for i in 1..12 loop
            for j in 1..12 loop
                print(i, j) := ' ';
            end loop;
        end loop;

        -- initial the correct letter array
        for i in 1..20 loop
            correctLetter(i) := '-';
        end loop;

        -- initial the used letter array
        for i in 1..26 loop
            usedLetter(i) := ' ';
        end loop;

        for i in 1..12 loop
            print(i, 1) := 'X';
        end loop;

        for j in 1..7 loop 
            print(1,j) := 'X';
        end loop;
        print(2,7) := 'X';

        -- if all the words have been used, end the game
        if count > totalWords then
            put_line("You did all the words");
            put_line("Ending...");
            exit;
        end if;

        -- get a random word from the dictionary
        randomNum := random(gen);

        -- check if this word has been used
        while usedWord(integer(randomNum)) - 1 = 0 loop
            randomNum := random(gen);
        end loop;

        usedWord(integer(randomNum)) := 1;
        count := count + 1;
        tryCount := 0;
        --put(integer(randomNum));new_line;
        --Testing(Remove b4 submit) put_line(to_string(words(integer(randomNum))));
        chosenWord := words(integer(randomNum));
        wordLength := length(chosenWord);

        -- show the hint
        for i in 1..wordLength loop 
            put(correctLetter(i));
        end loop;
        new_line;
        
        loop -- this loop only exit when either user win or lose
            isRoundContinue := 1;
            -- list all the letters have been used
            put_line("Here are the letters you used: ");
            for i in 1..26 loop
                if usedLetter(i) = ' ' then
                    exit;
                end if;

                put(usedLetter(i) & ',');
            end loop;
            put_line(" ");

            -- get user input
            put_line("What is your guess? ");
            remainedLetter := 0;
            get(guess);
            Skip_Line;

            loop --this loop only exit when user give vaild letters
                for i in 1..27 loop
                    if i < 27 then
                        if usedLetter(i) = ' ' then
                            isInputCorrect := 1;
                            index := i;
                            exit;
                        end if;

                        -- if this letter has alreay been used
                        if usedLetter(i) = guess then
                            isInputCorrect := 0;
                            put_line("You guessed that letter before");
                            exit;
                        end if;
                    else
                        -- invalid characters
                        isInputCorrect := 0;
                        put_line("Invalid character");
                        exit;
                    end if; 
                end loop;

                exit when isInputCorrect = 1;
                
                -- list all the letters have been used
                put_line("Here are the letters you used: ");
                for i in 1..26 loop
                    if usedLetter(i) = ' ' then
                        exit;
                    end if;

                    put(usedLetter(i) & ',');
                end loop;
                put_line(" ");

                -- get user input
                put_line("What is your guess? ");
                remainedLetter := 0;
                get(guess);
            end loop;

            usedLetter(index) := guess;
            tryCount := tryCount + 1;

            for i in 1..wordLength loop
                if Element(chosenWord, i) = guess then
                    correctLetter(i) := guess;
                    remainedLetter := remainedLetter + 1;
                end if;
            end loop;

            if remainedLetter = 0 then
                missed := missed + 1; -- go to 400
                put_line("Sorry, that letter isn't in the word");
                printHangImage(missed, print);

                for i in 1..12 loop
                    for j in 1..12 loop
                        put(print(i,j));
                    end loop;
                    new_line;
                end loop;

                -- if the user missed 10 times, game over
                if (missed - 10 = 0) then 
                    put_line("Sorry, you loose. The word was "&to_String(chosenWord));
                    put_line("You missed that one. ");
                    isRoundContinue := 0;
                end if;
            else
                for i in 1..wordLength + 1 loop -- 300
                    -- if user guess all correct letters
                    if (i > wordLength) then
                        put_line("You found the word.It took you "&Integer'Image(tryCount)&" guesses"); -- 390 go to 370
                        isRoundContinue := 0;
                        exit;
                    end if;

                    -- if user havn't guess all correct letters
                    if correctLetter(i) = '-' then -- go to 320
                        for i in 1..wordLength loop -- 320
                            put(correctLetter(i));
                        end loop;
                        new_line;
                        put_line("what is your guess for the word? ");
                        get_line(b,len);

                        --put_line(b(1..len));
                        if (chosenWord = b(1..len)) then -- 360
                            put_line("Right! It took you "&Integer'Image(tryCount)&" guesses");
                            isRoundContinue := 0;
                            exit;
                        else
                            put_line("Wrong. Try another letter");
                            isRoundContinue := 1;
                            exit;
                        end if;
                    end if;
                end loop;

            end if;
            exit when isRoundContinue = 0;
        end loop;

        put_line("Do you want another word? (Y(y)/N(n))");
        get(isGameContinue); 
        if isGameContinue = 'N' or else isGameContinue = 'n' then 
            put_line("It's been fun! Bye for now.");
            exit;
        end if;

    end loop;

end hangman;