
FLAGS = -Wall -std=c99

FASE00_GCC = -O0
FASE00_ICC = -O0

FASE01_GCC = -O1
FASE01_ICC = -O1

FASE02_GCC = -O2 -march=native
FASE02_ICC = -O2 -march=native

FASE03_GCC = -O3 -march=native
FASE03_ICC = -O3 -march=native

FASE04_GCC = -Ofast -march=native
FASE04_ICC = -Ofast -march=native

FASE05_GCC = -Ofast -march=native -fipa-pta
FASE05_ICC = -Ofast -march=native -ipo

FASE061_GCC = -Ofast -march=native -fipa-pta -fprofile-generate -pg
FASE061_ICC = -Ofast -march=native -ipo -p -prof-gen

FASE062_GCC = -Ofast -march=native -fipa-pta -fprofile-use
FASE062_ICC = -Ofast -march=native -ipo -prof-use

FASE07_GCC = -Ofast -march=native -fipa-pta -fprofile-use -ftree-vectorize
FASE07_ICC = -Ofast -march=native -ipo -prof-use -xHost -parallel

name_gcc = dgesv_gcc_07
name_icc = dgesv_icc_062

all: dgesv_icc dgesv_gcc

dgesv_icc:
	icc -lmkl -lmkl_core -lmkl_intel_lp64 -lmkl_sequential -fopenmp $(FLAGS) $(FASE062_ICC) -o $(name_icc) dgesv.c 

dgesv_gcc:
	gcc -lmkl -lmkl_core -lmkl_intel_lp64 -lmkl_sequential -fopenmp $(FLAGS) $(FASE07_GCC) -o $(name_gcc) dgesv.c 

cesga:
	make all
	sbatch runslurm3.sh

clean:
	rm -f dgesv_icc dgesv_gcc

run-icc: dgesv_icc
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

slurn-gcc: 
	make dgesv_gcc
	sbatch --job-name=$(name_gcc) --output="results/$(name_gcc).out" --error="results/$(name_gcc).err" runslurm_gcc.sh $(name_gcc)

slurn-icc: 
	make dgesv_icc
	sbatch --job-name=$(name_icc) --output="results/$(name_icc).out" --error="results/$(name_icc).err" runslurm_gcc.sh $(name_icc)

run-gcc: dgesv_gcc
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
