all: hello.adb activity_c.c escape.adb
	/Users/dustin/opt/GNAT/2020/bin/gnatmake hello.adb
	/Users/dustin/opt/GNAT/2020/bin/gnatmake activity_ada.adb
	/Users/dustin/opt/GNAT/2020/bin/gnatmake escape.adb
	gcc -Wall -std=c99 activity_c.c
clean:
	rm *.o
	rm *.ali
	rm a.out
	rm hello
	rm activity_ada