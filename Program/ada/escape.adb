with ada.float_text_io; use ada.float_text_io;
with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;
with ada.Numerics.Elementary_functions; use ada.Numerics.Elementary_functions;

procedure escape is 
    result: float;

    --earthMass: constant integer:= integer(6.0 * 10**(24));
    earthRadius: constant integer := integer(6.4 * 10**(6));
    --moonMass: constant real := 7.4 * 10**(22);
    --moonRadius: constant integer := 1.7 *10**(6);
    --jupiterMass: constant real := 1.9 * 10**(27);
    --jupiterRadius: constant integer := 7.1 * 10**(7);

    function calEscapteVolocity(radius: integer) return float is
        result :float;
    begin
        result := sqrt(float(2 * 6.0 * 10**(24) * 6.673 * 10**(-11))) / float(radius);
        return result;
    end calEscapteVolocity;    
begin
    result := 0.0;

    result := calEscapteVolocity(earthRadius);
    put(result, aft=>5, exp=>0);new_line;

end escape;