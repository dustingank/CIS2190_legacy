           identification division.
           program-id. stateNew.

           environment division.

           input-output section.
           file-control.
           select input-file assign to "NUMS.TXT"
               organization is line sequential.
           select output-file assign to "NOUT.TXT"
               organization is line sequential.
           
           data division.
           file section.
           fd input-file.
           01 sample-input     pic X(80).
           fd output-file.
           01 output-line     pic X(80).

           working-storage section.
           77 sx   pic S9(14)V9(4) usage is COMPUTATIONAL-3.
           77 n    pic S9999 usage is COMPUTATIONAL.
           77 m    pic S9(14)V9(4) usage is COMPUTATIONAL-3.
           77 i    pic S9999 usage is COMPUTATIONAL.
           77 std  pic S9(14)V9(4) usage is COMPUTATIONAL-3.
           77 temp pic S9(14)V9(4) usage is COMPUTATIONAL-3.
           01 array-area.
               02 x pic S9(14)V9(4) usage is COMPUTATIONAL-3
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
           01 print-line-1.
               02 filler pic X(9) value ' MEAN=   '.
               02 out-mn pic -(14)9.9(4).
           01 print-line-2.
               02 filler pic X(9) value ' STDDEV= '.
               02 out-st pic -(14)9.9(4).
           
           01 endOfFile pic A(1).

           procedure division.
           open input input-file, output output-file
           write output-line from title-line after advancing 0 lines
           write output-line from under-line after advancing 1 lines
           write output-line from col-heads after advancing 1 lines
           write output-line from under-line after advancing 1 lines

           move zero to sx
           move 'N' to endOfFile
           move 1 to n

           perform until endOfFile = 'Y' or n > 1000
               read input-file into input-value
                   at end move 'Y' to endOfFile
                   not at end 
                   move in-x to x(n), out-x
                   write output-line from data-line after advancing 1 line
                   add x(n) to sx
                   compute n = n + 1
           end-perform.

           subtract 1 from n
           divide n into sx giving m rounded.
           
           move 1 to i

           perform until i > n 
               subtract m from x(i) giving temp
               multiply temp by temp giving temp
               add temp to sx
               compute i = i + 1
           end-perform.

           compute std rounded = (sx / n) ** 0.5
           write output-line from under-line after advancing 1 line
           move m to out-mn
           move std to out-st 
           write output-line from print-line-1 after advancing 1 line 
           write output-line from print-line-2 after advancing 1 line  

           close input-file, output-file

           stop run.

