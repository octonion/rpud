# rpud

Patched version of rpud to correctly compile under newer versions of CUDA Toolkit.

The problem stems from the command "R CMD config --ldflags":

-Wl,--export-dynamic -fopenmp  -L/usr/lib/R/lib -lR -lpcre -llzma -lbz2 -lz -lrt -ldl -lm

nvcc doesn't understand "-Wl", it needs multiple -Xlinker statements.

Currently has an ugly hack not guaranteed to always work.

Original project:

http://cran.r-project.org/web/packages/rpud/index.html

To install:

git clone https://github.com/octonion/rpud
R CMD build rpud
R CMD INSTALL rpud_0.0.2.tar.gz (or "sudo R CMD INSTALL rpud_0.0.2.tar.gz")

