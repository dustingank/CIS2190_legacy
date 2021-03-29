identification division.
program-id. stateNew.

environment division.

input-output section.
file-control.
select inputFile assign to dynamic dataFile
    organization is line sequential.
select outputFile assign to dynamic reportFile
    organization is line sequential.

data division.
file section.
fd inputFile.
01 sampleInput     pic X(80).
fd outputFile.
01 outputLine     pic X(80).

working-storage section.
77 totalSum   pic S9(14)V9(4) usage is COMPUTATIONAL-3.
77 n    pic S9999 usage is COMPUTATIONAL.

77 medianValue    pic S9(19)V9(19) usage is COMPUTATIONAL-3.
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

01 arrayArea.
    02 x pic S9(14)V9(4) usage is COMPUTATIONAL-3
        occurs 1000 times.
01 inputValue.
    02 in-x pic S9(14)V9(4).
    02 filler pic X(62).
01 titleLine.
    02 filler pic X(55) value 
        '           Data Statistics'.
01 breakLine.
    02 filler pic X(55) value
        '----------------------------------------------'.
01 colHeads.
    02 filler pic X(55) value 
        '            Data Values'.
01 dataLine.
    02 filler pic X(5) value space.
    02 outX pic -(14)9.9(4).
01 printLine1.
    02 filler pic X(22) value ' Mean =   '.
    02 outMn pic -(14)9.9(4).
01 printLine2.
    02 filler pic X(22) value ' Variance = '.
    02 outVr pic -(14)9.9(4).
01 printLine3.
    02 filler pic X(22) value ' Standard Deviation = '.
    02 outSt pic -(14)9.9(4).
01 printLine4.
    02 filler pic X(22) value ' Geometric Mean= '.
    02 outGm pic -(14)9.9(4).
01 printLine5.
    02 filler pic X(22) value ' Harmonic Mean = '.
    02 outHm pic -(14)9.9(4).
01 printLine6.
    02 filler pic X(22) value ' Median = '.
    02 outMd pic -(14)9.9(4).

01 endOfFile pic A(1).

procedure division.
       *> ask user to input the file name
       display "Enter the filename needs be read(with file extention): " with no advancing.
       accept dataFile.
       display "Enter the filename of the report(with file extention): " with no advancing.
       accept reportFile.
       
       open input inputFile, output outputFile.
       write outputLine from titleLine after advancing 0 lines.
       write outputLine from breakLine after advancing 1 lines.
       write outputLine from colHeads after advancing 1 lines.
       write outputLine from breakLine after advancing 1 lines.
       
       *> initialze the variable name
       move zero to totalSum.
       move 'N' to endOfFile.
       move 1 to n.
       
       *> loop through the file, either end at end of the file or reach 1000 line
       perform until endOfFile = 'Y' or n > 1000
           read inputFile into inputValue
               at end move 'Y' to endOfFile
               not at end 
               *> save the file data into array
               move in-x to x(n), outX
               *> save the file data into the ouput file
               write outputLine from dataLine after advancing 1 line
               add x(n) to totalSum
               compute n = n + 1
       end-perform.
       
       subtract 1 from n.
       divide n into totalSum giving medianValue rounded.
       
       *> Calculate the standard deviation
       perform calStd.

       *> Calculate the geometric mean
       perform calGeoMean.
       
       *> Calculate the harmonic mean
       perform CalHarmonicMean.

       *> Calculate the median
       perform CalMedian.

       *> Calculate the variance
       perform CalVariance.
      
       *> convert the result into editing from
       move medianValue to outMn.
       move std to outSt.
       move geoMean to outGm.
       move harMean to outHm.
       move median to outMd.
       move variance to outVr.
       
       *> write the results into the file
       write outputLine from breakLine after advancing 1 line.
       write outputLine from printLine1 after advancing 1 line.
       write outputLine from printLine2 after advancing 1 line. 
       write outputLine from printLine3 after advancing 1 line.
       write outputLine from printLine4 after advancing 1 line.
       write outputLine from printLine5 after advancing 1 line.
       write outputLine from printLine6 after advancing 1 line.
       close inputFile, outputFile.
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
               subtract medianValue from x(i) giving temp
               multiply temp by temp giving temp
               add temp to totalSum
               compute i = i + 1
           end-perform.
           compute std rounded = (totalSum / n) ** 0.5.
           
           

           
           
  

