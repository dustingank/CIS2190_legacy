identification division.
program-id. BodySurfaceArea.

environment division.

data division.
working-storage section.
01 weight   pic 999V9.
01 height   pic 999V9.
01 body_SA  pic ZZZ.99.

procedure division.
    display "Body Surface Area Calculator".
    display " Weight (kg)?  ".
    accept weight.
    display " Height (cm)?  ".
    accept height.

    compute body_SA = 0.007184 * (weight**0.425) * (height**0.725). 

    display "Body surface area = " body_SA " m^2".
stop run.
