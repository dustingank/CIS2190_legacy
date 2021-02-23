with ada.text_io; use ada.text_io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Numerics;
with ada.numerics.discrete_random;

procedure hangman is 
m,totalWords,T1,r,wordLength, count,index: integer;
isInputCorrect, isRoundContinue: integer;
guess, isGameContinue: character;
chosenWord: unbounded_string;

b: string(1..26);
len: integer;

d: array (1..20) of character;
n: array (1..26) of character;
u: array (1..50) of integer;
p: array(1..12, 1..12) of character;

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

type randRange is new Integer range 1..50;
package Rand_Int is new ada.numerics.discrete_random(randRange);
use Rand_Int;
gen: Generator;
randomNum: randRange;
begin
    put_line("The Game Of Hangman");
    loop
        count := 1;
        index := 0;
        totalWords := 50;
        isInputCorrect := 0;
        isRoundContinue := 0;
        m := 0;
        reset(gen);

        for i in 1..12 loop
            for j in 1..12 loop
                p(i, j) := ' ';
            end loop;
        end loop;

        for i in 1..20 loop
            d(i) := '-';
        end loop;

        for i in 1..26 loop
            n(i) := ' ';
        end loop;

        for i in 1..50 loop
            u(i) := 0;
        end loop;

        for i in 1..12 loop
            p(i, 1) := 'X';
        end loop;

        for j in 1..7 loop 
            p(1,j) := 'X';
        end loop;
        p(2,7) := 'X';

        -- if all the words have been used, end the game
        if count > totalWords then
            put_line("You did all the words");
            put_line("Ending...");
            exit;
        end if;

        -- get a random word from the dictionary
        randomNum := random(gen);
        while u(integer(randomNum)) - 1 = 0 loop
            randomNum := random(gen);
        end loop;
        u(integer(randomNum)) := 1;
        count := count + 1;
        T1 := 0;
        --put(integer(randomNum));new_line;
        put_line(to_string(words(integer(randomNum))));
        chosenWord := words(integer(randomNum));
        wordLength := length(chosenWord);

        -- show the hint
        for i in 1..wordLength loop 
            put(d(i));
        end loop;
        new_line;
        
        loop -- this loop only exit when either user win or lose
            isRoundContinue := 1;
            -- list all the letters have been used
            put_line("Here are the letters you used: ");
            for i in 1..26 loop
                if n(i) = ' ' then
                    exit;
                end if;

                put(n(i) & ',');
            end loop;
            put_line(" ");

            -- get user input
            put_line("What is your guess? ");
            r := 0;
            get(guess);
            Skip_Line;

            loop --this loop only exit when user give vaild letters
                for i in 1..27 loop
                    if i < 27 then
                        if n(i) = ' ' then
                            isInputCorrect := 1;
                            index := i;
                            exit;
                        end if;

                        if n(i) = guess then
                            isInputCorrect := 0;
                            put_line("You guessed that letter before");
                            exit;
                        end if;
                    else
                        isInputCorrect := 0;
                        put_line("Invalid character");
                        exit;
                    end if; 
                end loop;

                exit when isInputCorrect = 1;
                
                -- list all the letters have been used
                put_line("Here are the letters you used: ");
                for i in 1..26 loop
                    if n(i) = ' ' then
                        exit;
                    end if;

                    put(n(i) & ',');
                end loop;
                put_line(" ");

                -- get user input
                put_line("What is your guess? ");
                r := 0;
                get(guess);
            end loop;

            n(index) := guess;
            T1 := T1 + 1;

            for i in 1..wordLength loop
                if Element(chosenWord, i) = guess then
                    d(i) := guess;
                    r := r + 1;
                end if;
            end loop;

            if r = 0 then
                m := m + 1; -- go to 400
                put_line("Sorry, that letter isn't in the word");
                case m is 
                    when 1 =>
                        put_line("First we draw a head.");
                    when 2 =>
                        put_line("Now we draw a body.");
                    when 3 =>
                        put_line("Next we draw an arm");
                    when 4 =>
                        put_line("This time it's the other arm.");
                    when 5 =>
                        put_line("Now, let's draw the right leg");
                    when 6 =>
                        put_line("This time we draw the left leg");
                    when 7 =>
                        put_line("Now we put a hand");
                    when 8 =>
                        put_line("Next the other hand");
                    when 9 =>
                        put_line("Now we draw one foot");
                    when 10 =>
                        put_line("Here's the other foot -- You're hung!!.");
                    when others =>
                        put_line("error");
                end case;
                case m is
                    when 1 =>
                        P(3,6) := '-'; P(3,7) := '-'; P(3,8) := '-'; P(4,5) := '(';
                        p(4,6) := '.';
                        P(4,8) := '.'; P(4,9) := ')'; P(5,6) := '-'; P(5,7) := '-'; 
                        P(5,8) := '-';
                    when 2 => 
                        for i in 6..9 loop
                            p(i,7) := 'X';
                        end loop;
                    when 3 =>
                        for i in 4..7 loop
                            p(i, i - 1) := '\';
                        end loop;
                    when 4 =>
                        p(4,11) := '/'; p(5,10) := '/'; p(6,9) := '/'; p(7,8) := '/';
                    when 5 =>
                        p(10,6) := '/'; p(11,5) := '/';
                    when 6 =>
                        p(10,8) := '\'; p(11,9) := '\';
                    when 7 =>
                        p(3,11) := '\';
                    when 8 =>
                        p(3,3) := '/';
                    when 9 =>
                        p(12,10) := '\'; p(12,11) := '-';
                    when 10 =>
                        p(12,3) := '-'; p(12,4) := '/';
                    when others =>
                        put_line("error");
                end case;

                for i in 1..12 loop
                    for j in 1..12 loop
                        put(p(i,j));
                    end loop;
                    new_line;
                end loop;

                if (m - 10 = 0) then 
                    put_line("Sorry, you loose. The word was "&to_String(chosenWord));
                    put_line("You missed that one. ");
                    isRoundContinue := 0;
                end if;
            else
                for i in 1..wordLength + 1 loop -- 300
                    -- if user guess all correct letters
                    if (i > wordLength) then
                        put_line("You found the word."); -- 390 go to 370
                        isRoundContinue := 0;
                        exit;
                    end if;

                    -- if user havn't guess all correct letters
                    if d(i) = '-' then -- go to 320
                        for i in 1..wordLength loop -- 320
                            put(d(i));
                        end loop;
                        new_line;
                        put_line("what is your guess for the word? ");
                        get_line(b,len);

                        --put_line(b(1..len));
                        if (chosenWord = b(1..len)) then -- 360
                            put_line("Right! It took you "&Integer'Image(T1)&" guesses");
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

        put_line("Do you want another word? (Y/N)");
        get(isGameContinue); 
        if isGameContinue = 'N' then 
            put_line("It's been fun! Bye for now.");
            exit;
        end if;

    end loop;

end hangman;