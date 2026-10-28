#! /bin/bash
if [ "$BASH_VERSION" = '' ]; then
  . ./_math             # Allows simple arithmatic in bash/dash
else
  source ./_math        # Allows simple arithmatic in bash/dash
fi

LOOP_START=0
#LOOP_END=500
TMP=`grep 'LOOP_END=' runsim.sh | awk -F '[=  ]' -v pat="$pattern" '{print $2}' | awk -F ' ' -v pat="$pattern" '{print $1}'`
LOOP_END=$(float_eval "$TMP + 1")

mg_timestep=`grep 'mg_timestep=' runsim.sh | awk -F '[=  ]' -v pat="$pattern" '{print $2}' | awk -F ' ' -v pat="$pattern" '{print $1}'`
Pshock=1.0E23	# Pressure to locate shock
echo $mg_timestep

# compile line data into shock position history (along x=0)
time=0.0
rm shockhist.txt
touch shockhist.txt
rm shockspeed.txt
touch shockspeed.txt
for i in $(seq -f %04g $LOOP_START $LOOP_END) ; do
  time=$(float_eval "$i * $mg_timestep")
  python3 <<-PY
	from numpy import *
	# load data recorded along a line
	a = loadtxt('./xq/pg$i.xq',skiprows = 3)
	# find the location and amplitude of the lead shock
	shocki=where(transpose(a)[1,:]>$Pshock)[0][-6]
	xshock=a[shocki+3][0]
	pshock=a[shocki][1]
	time=$time
	f = open('./shockhist.txt','a')
	f.write("%s %s %s\n" % (xshock, pshock, time))
	f.close
	PY
done

# now get the velocity
python3 <<-PY
	from numpy import *
	data = loadtxt('./shockhist.txt')
	# get number of lines in list
	count = sum(1 for line in data)
	# now create file with speed vs time
	f = open('./shockspeed.txt','a')
	D=0.0
	dx=0.0
	dt=0.0
	for i in range(1, count-1):
	  xp = data[i-1][0]
	  x = data[i][0]
	  xn = data[i+1][0]
	  tp = data[i-1][2]
	  t = data[i][2]
	  tn = data[i+1][2]
	  dx = xn-xp
	  dt = tn-tp
	  D = dx/dt
	  f.write("%s" %D)
	  f.write(" ")
	  f.write("%s" %x)
	  f.write(" ")
	  f.write("%s" %t)
	  f.write("\n")
	f.close()
	PY

# make the plot
gnuplot Dspeed.plt


