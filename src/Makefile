EXT := cu 

OBJS := rpud.o rpudist.o

#compiler/preprocessor options
INCS := -I/usr/local/cuda/include
PARAMS := -Xcompiler "-I/usr/share/R/include -fpic"

#linker options
LD_PARAMS := -Xlinker "--export-dynamic -fopenmp  -L/usr/lib/R/lib -lR -lpcre -llzma -lbz2 -lz -lrt -ldl -lm" -Xlinker "-rpath /usr/local/cuda/lib64"
LIBS :=  -L/usr/local/cuda/lib64 -lcublas -lcuda

TARGETS := rpud.so

CC := /usr/local/cuda/bin/nvcc

all: $(TARGETS) 

$(TARGETS): $(OBJS)
	$(CC) -shared $(LD_PARAMS) $(LIBS) $(OBJS) -o $@

$(OBJS): %.o: %.$(EXT)
	$(CC) -c $(INCS) $(PARAMS) $^ -o $@

clean:
	rm -rf *o

.PHONY: all clean
