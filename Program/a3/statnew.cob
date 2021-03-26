identification division.
program-id. stateNew.

environment division.

input-output section.
file-control.
select input-file assign to dynamic dataFile
    organization is line sequential.
select output-file assign to dynamic reportFile
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

77 m    pic S9(19)V9(19) usage is COMPUTATIONAL-3.
77 i    pic S9999 usage is COMPUTATIONAL.
77 std  pic S9(19)V9(19) usage is COMPUTATIONAL-3.
77 variance  pic S9(19)V9(19) usage is COMPUTATIONAL-3.
77 geoMean pic S9(19)V9(19) usage is COMPUTATIONAL-3.
77 harMean pic S9(19)V9(19) usage is COMPUTATIONAL-3.
77 median pic S9(19)V9(19) usage is COMPUTATIONAL-3.
77 temp pic S9(19)V9(19) usage is COMPUTATIONAL-3.

77 dataFile pic X(30).
77 reportFile pic X(30).

01 residue pic 9(19).
01 result  pic 9(19).

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
    02 filler pic X(11) value ' MEAN=   '.
    02 out-mn pic -(14)9.9(4).
01 print-line-2.
    02 filler pic X(11) value ' VAR= '.
    02 out-vr pic -(14)9.9(4).
01 print-line-3.
    02 filler pic X(11) value ' STDDEV= '.
    02 out-st pic -(14)9.9(4).
01 print-line-4.
    02 filler pic X(11) value ' GEOMEAN= '.
    02 out-gm pic -(14)9.9(4).
01 print-line-5.
    02 filler pic X(11) value ' HARMEAN= '.
    02 out-hm pic -(14)9.9(4).
01 print-line-6.
    02 filler pic X(11) value ' MEDIAN= '.
    02 out-md pic -(14)9.9(4).

01 endOfFile pic A(1).

procedure division.
       display "Enter the filename needs be read(with file extention): " with no advancing.
       accept dataFile.
       display "Enter the filename of the report(with file extention): " with no advancing.
       accept reportFile.
       
       open input input-file, output output-file.
       write output-line from title-line after advancing 0 lines.
       write output-line from under-line after advancing 1 lines.
       write output-line from col-heads after advancing 1 lines.
       write output-line from under-line after advancing 1 lines.
       
       move zero to sx.
       move 'N' to endOfFile.
       move 1 to n.
       
       perform until endOfFile = 'Y' or n > 1000
           read input-file into input-value
               at end move 'Y' to endOfFile
               not at end 
               move in-x to x(n), out-x
               write output-line from data-line after advancing 1 line
               add x(n) to sx
               compute n = n + 1
       end-perform.
       
       subtract 1 from n.
       divide n into sx giving m rounded.
       
       perform calStd.
       perform calGeoMean.
       perform CalHarmonicMean.
       perform CalMedian.
       perform CalVariance.
      
       move m to out-mn.
       move std to out-st.
       move geoMean to out-gm.
       move harMean to out-hm.
       move median to out-md.
       move variance to out-vr.
       
       write output-line from under-line after advancing 1 line.
       write output-line from print-line-1 after advancing 1 line.
       write output-line from print-line-2 after advancing 1 line. 
       write output-line from print-line-3 after advancing 1 line.
       write output-line from print-line-4 after advancing 1 line.
       write output-line from print-line-5 after advancing 1 line.
       close input-file, output-file.
       stop run.

       calGeoMean.
           move 1 to temp.
           move 1 to i.
           perform until i > n
               multiply temp by x(i) giving temp
               compute i = i + 1
           end-perform.
           compute geoMean = temp ** (1 / n).
       
       CalHarmonicMean.
           move 0 to temp.
           move 1 to i.
           perform until i > n
               compute temp = temp + (1 / x(i))
               compute i = i + 1
           end-perform.
           compute harMean = (temp / n) ** -1.

       CalMedian.
           SORT x descending.
           divide n by 2 giving result remainder residue.
           if residue = 0 then 
               compute median = (x(result) +  x(result + 1)) / 2
           else 
               move x(result + residue) to median
           end-if.
       
       CalVariance.
           compute variance = std ** 2.
       
       calStd.
           move 1 to i.
           perform until i > n 
               subtract m from x(i) giving temp
               multiply temp by temp giving temp
               add temp to sx
               compute i = i + 1
           end-perform.
           compute std rounded = (sx / n) ** 0.5.
           
           

           
           
  

