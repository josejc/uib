#

CC= g++

CFLAGS= -Wno-deprecated

LDFLAGS= -lpthread

OBJ= ruleta.o

LIBS= 

all: practica

clean:
	rm -f *.o *~ ruleta

practica: $(OBJ)
	$(CC) -o ruleta $(OBJ) $(LDFLAGS) $(LIBS) 

.cpp.o:
	$(CC) -c $(CFLAGS) $< 
