with ada.float_text_io; use ada.float_text_io;
with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;
procedure activity_ada is
    x, y, z: integer;
    result: float;
begin
    x := 5;
    y := 10000;
    z := 3000;
    result := 0.0;

    for i in 1..1000 loop
        x := 171 * (x rem 177) - 2 * (x / 177);
        --put(x);new_line;
        if x < 0 then
            x := x + 30269;
        end if;

        y := 172 * (y rem 176) - 35 * (y / 176);
        --put(y);new_line;
        if y < 0 then
            y := y + 30307;
        end if;

        z := 170 * (z rem 178) - 63 * (z / 178);
        --put(z);new_line;
        if z < 0 then
            z := z + 30323;
        end if;

        result := float(x) / float(30269) + float(y) / float(30307) + float(z) / float(30323);
        result := result - Float'Floor(result);
        put(result, aft=>5, exp=>0);new_line;
    end loop;
end activity_ada;