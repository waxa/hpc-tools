#!/bin/bash
#Opción -A: Login del usuario con el que ha de ejecutarse el script en los nodos.
##SBATCH -A victor

##SBATCH -n 1

#Opción -N: Número de nodos (máquinas) en los que se ejecutará el script.
#SBATCH -N 1

#Opción -e: Nombre del fichero al que se escribirá la salida de errores.
#SBATCH -e results/$1.err

#Opción -o: Nombre del fichero al que se escribirá la salida estándar.
#SBATCH -o results/$1.out

#Opción -J: Nombre que tendrá el trabajo en la cola.
#SBATCH --job-name=$1

#Opción -w: Nombres de los nodos que ejecutarán el trabajo, separados por comas y sin espacios.
##SBATCH --nodelist=chimera

#Opción -p: Nombre de la partición a la que debe enviársele este trabajo.
#SBATCH --partition=cola-corta

##SBATCH --ntasks-per-node=2

#Opción -t: Límite de tiempo que tiene el script para ejecutarse. Si excede este tiempo, se le manda SIGKILL.
#SBATCH --time=07:00:00

#Opción --exclusive: Obliga a que en cada máquina en la que se ejecute el script, no haya otros trabajos en posibles cores libres
#SBATCH --exclusive

#SBATCH -c 1

# Primero los valores por defecto

module purge

module load intel/2018
module load impi/2018
module load mkl

echo "---- Small test ----"
./$1 2048
./$1 2048
./$1 2048
echo "---- Medium test ----"
./$1 4096
./$1 4096
./$1 4096
echo "---- Large test ----"
./$1 8192
./$1 8192
./$1 8192

