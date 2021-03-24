           identification division.
           program-id. stateNew.

           environment division.
           input-output section.
           file-control.
           select input-file assign to "numsInput.txt"
               organization is line sequential.
           select output-file assign to "numsOutput.txt"
               organization is line sequential.
           
           data division.
           file section
           fd input-file.
           01 sample-input     pic X(80).
           fd output-file.
           01 output-input     pic X(80).

           working-storage section.
           77 sx   pic S9(14)V9(4) usage is computational-3.
           77 n    pic S9999 usage is computational.
           77 m    pic S9(14)V9(4) is computational-3.
           77 i    pic S9999 is computational.
           77 std  pic S9(14)V9(4) usage is computational-3.
           77 temp pic S9(14)V9(4) usage is computational-3.
           01 array-area.
               02 x pic S9(14)V9(4) usage is computational-3
                   occurs 1000 times.
           01 input-value.
               02 in-x pic S9(14)V9(4).
               02 filler pic X(62).
           01 title-line.
               02 filler pic X(29) value 
                   '  MEAN AND STANDARD DEVIATION'.
           01 under-line.
               02 filler pic X(30) value
                   '------------------------------'.
           01 col-heads.
               02 filler pic X(21) value '          DATA VALUES'.
           01 data-line.
               02 filler pic X(5) value space.
               02 out-x pic -(14)9.9(4).
           01 print-line-1
               02 filler pic X(9) value ' MEAN =  '.
               02 out-mn pic -(14)9.9(4).
           01 print-line-2
               02 filler pic X(9) value ' STDDEV =  '.
               02 out-st pic -(14)9.9(4).
           