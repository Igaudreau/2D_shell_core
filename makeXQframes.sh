#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32000M
#SBATCH --time=0-01:00
if [ "$BASH_VERSION" = '' ]; then
  . ./_math		# Allows simple arithmatic in bash/dash
else
  source ./_math	# Allows simple arithmatic in bash/dash
fi


DT=$2
D_CJ=$3
NAME=$4

#mg_sn1a <<- EOF
mg_torch <<- EOF
	paper 10.0 4.0
	read $NAME.$1
	plot pg export ./xq/pg$1 p
	q
	EOF


