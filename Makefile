
FLAGS = -Wall

DEBUG = -Oo -pg

all: dgesv_icc dgesv_gcc

dgesv_icc: dgesv.c
	icc -lmkl -lmkl_core -lmkl_intel_lp64 -lmkl_sequential -o dgesv_icc dgesv.c

dgesv_gcc: dgesv.c
	gcc dgesv.c -o dgesv_gcc  -lm

cesga:
	make all
	sbatch runslurm3.sh

clean:
	rm dgesv_icc dgesv_gcc

run-icc: 
	echo "---- Small test ----"
	./dgesv_icc 2048
	./dgesv_icc 2048
	./dgesv_icc 2048
	echo "---- Medium test ----"
	./dgesv_icc 4096
	./dgesv_icc 4096
	./dgesv_icc 4096
	echo "---- Large test ----"
	./dgesv_icc 8192
	./dgesv_icc 8192
	./dgesv_icc 8192

run-gcc: 
	echo "---- Small test ----"
	./dgesv_gcc 2048
	./dgesv_gcc 2048
	./dgesv_gcc 2048
	echo "---- Medium test ----"
	./dgesv_gcc 4096
	./dgesv_gcc 4096
	./dgesv_gcc 4096
	echo "---- Large test ----"
	./dgesv_gcc 8192
	./dgesv_gcc 8192
	./dgesv_gcc 8192
