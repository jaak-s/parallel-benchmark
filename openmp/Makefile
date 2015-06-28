#
BHOME	=$(PWD)
#
F90	= ifort
CC	= icc
#
#
COMP	= -openmp
FOMP	= -openmp
COPTS	=  -O3 -xHost -fno-inline -fno-alias
FOPTS	=  -O3 -xHost -fno-inline
FLONG	= 
#
#
NOLINK= -c
#

all: sum normsq dot

sum: sum.o
	$(CC) $(COMP) -o sum sum.o

normsq: normsq.o
	$(CC) $(COMP) -o normsq normsq.o

dot: dot.o
	$(CC) $(COMP) -o dot dot.o

%.o: %.c
	$(CC) $(COPTS) $(COMP) $(NOLINK) $<

clean:
	rm -f *.o sum dot normsq

