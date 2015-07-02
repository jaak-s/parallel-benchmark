#
BHOME	=$(PWD)
#
CC	= g++-5
#
#
COMP	= -fcilkplus -lcilkrts -lm
COPTS	= -O3 -fstrict-aliasing
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

