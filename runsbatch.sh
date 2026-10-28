#!/bin/bash
#SBATCH --account=def-bmaxwell
#SBATCH --mail-user=igaud058@uottawa.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --job-name=2d_shell
#SBATCH --ntasks=192
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4096M
#SBATCH --time=05-00:00
BIN=mg_torch

mpirun $BIN <<- EOF
	\$read run
	q
	EOF



