#! /bin/bash
if [ "$BASH_VERSION" = '' ]; then
  . ./_math		# Allows simple arithmatic in bash/dash
else
  source ./_math		# Allows simple arithmatic in bash/dash
fi
LOOP_START=0		# first file to read from
#LOOP_END=200		# last file to read from
TMP=`grep 'LOOP_END=' runsim.sh | awk -F '[=  ]' -v pat="$pattern" '{print $2}' | awk -F ' ' -v pat="$pattern" '{print $1}'`
LOOP_END=$(float_eval "$TMP + 1")
NPROCS=10		# number of processes at one time
mg_timestep=0.00000001
D_CJ=1396000000		# velocity
export NAME=det

# post-process simulation frames in a loop
#rm ./xq/*
rm slurm*.out
mkdir xq

njob=0
for i in $(seq -f %04g $LOOP_START $LOOP_END) ; do
  while float_cond $njob' > '$NPROC; do 
    sleep 1 
  done
  if [ ! -f ./xq/pg$i.xq ]; then
   if ! type sbatch > /dev/null; then
    nohup sh ./makeXQframes.sh $i $mg_timestep $D_CJ $NAME &		# call mg_post.sh
   else
    sbatch ./makeXQframes.sh $i $mg_timestep $D_CJ $NAME
   fi
  fi

  njob=$(float_eval "$njob + 1")
  j=$(float_eval "$NPROCS - 1")
  if float_cond $njob' > '$j ; then
    wait
    njob=0
  fi
done
wait



