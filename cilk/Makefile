#
BHOME	=$(PWD)
#
CC	= icc
#
#
COMP	= -I/usr/include/x86_64-linux-gnu/c++/4.8
copts	= -o3 -fno-alias -xHost # -fno-inline
#
#
NOLINK= -c
#

all: sum dot normsq

sum: sum.o
	$(CC) $(COMP) -o sum sum.o

normsq: normsq.o
	$(CC) $(COMP) -o normsq normsq.o

dot: dot.o
	$(CC) $(COMP) -o dot dot.o

%.o: %.cpp
	$(CC) $(COPTS) $(COMP) $(NOLINK) $<

clean:
	rm -f *.o sum dot normsq

