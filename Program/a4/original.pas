program polish;

const  maxin = 40;
       maxout = 40;
       maxstack = 40;
       
type   stores = array[0..maxout] of char;

var    instring: string[maxin];
       outstring, stack: stores;
       operandset, operatorset: set of char;
       out, top, lastout, lastin, item: integer;
       discard: char;
       
procedure push(it: char);
begin
    if top < maxstack
    then begin
        top := top + 1;
        stack[top] := it
    end else begin
        writeln('stack overflow');
        exit()
    end
end;

function pop: char;
begin
    if top > 0
    then begin
        pop := stack[top];
        top := top - 1;
    end else begin
        writeln('stack underflow');
        exit()
    end
end;

procedure move(it: char);
begin
    if it = '('
    then begin
        writeln(' unmatched bracket ');
        exit()
    end else if lastout < maxout
             then begin
                 lastout := lastout + 1;
                 outstring[lastout] := it;
             end else begin
                 writeln(' output string full ');
                 exit()
             end
end;

function priority(it: char): integer;
begin
    case it of
    ')','%' : priority := -1;
        '(' : priority := 0;
    '+','-' : priority := 1;
    '*','/' : priority := 2;
        '^' : priority := 3;
    end
end;

procedure pushORmove(its: char);
var itemtostack: boolean;
begin
    if its = '('
    then push(its)
    else if its = ')'
         then begin
             while priority(stack[top]) <> priority('(') do move(pop);
             discard := pop;
             writeln('test',discard);
         end else if its in operatorset
                  then repeat
                      itemtostack := priority(its) > priority(stack[top]);
                      if itemtostack
                      then push(its)
                      else move(pop)
                  until itemtostack
                  else begin
                      writeln(' invalid operator ', its);
                      exit()
                  end
end;

begin
    lastin := 0;
    operatorset := ['%','+','-','*','/','^'];
    operandset := ['a'..'z','0'..'9'];
    
    while lastin <> 1 do
    begin
        write(' type an expression: ');
        readln(instring);
        lastin := length(instring);
        item := 0;
        lastout := -1;
        stack[0] := '%';
        top := 0;
        
        repeat 
            item := item + 1;
            if instring[item] in operandset
            then move(instring[item])
            else if instring[item] in (operatorset + ['(',')'])
                 then pushORmove(instring[item])
            else begin
                 writeln(' illegal symbol ', instring[item]);
                 item := lastin;
            end
        until item = lastin;
        
        while top > 0 do move(pop); {purge stack}
        
        for out := 0 to lastout do write(outstring[out]);
    end
end.