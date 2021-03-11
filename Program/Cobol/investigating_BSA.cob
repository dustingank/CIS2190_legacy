           identification division.
           program-id. BodySurfaceArea.
           
           environment division.
           data division.
           working-storage section.
           01 weight pic 999V9.
           01 height pic 999v9.
           01 w2     pic 999V9.
           01 h2     pic 999V9.
           *> body_SA pic ZZZ.99.
           01 body_SA pic 999V99.
           01 body_SAo pic ZZZ.99.

           procedure division.
               display "Body Surface Area Calculator".
               display " Weight(kg)?  ".
               accept weight.
               display " Height(cm)?  ".
               accept height.
               
               compute w2 = (weight**0.425).
               compute h2 = (height**0.725).
               multiply w2 by h2 giving body_SA.
               multiply 0.007184 by body_SA.
               move body_SA to body_SAo.
               *> compute body_SA = 0.00718 * (weight**0.425) * (height ** 0.725).
               display "Body surface area = "body_SA"(body_SA) m^2".
               display "Body surface area = "body_SAo"(body_SAo) m^2".
           stop run.
