set terminal postscript eps enhanced monochrome
set datafile separator " "
set output "Dspeed.eps"
set title "Detonation Speed"
set size 0.6,0.6
set yrange [0:2e9]
set xrange [0:*]
set xtics 5e4
set xlabel "x (cm)"
set ylabel "D (cm/s)"
#set xtics 50
#set logscale y
set key bottom
set style line 1 lt 1 lw 5 ps 0.1 linecolor -1
set style line 2 lt 3 lw 1 pt 6 ps 0.8 linecolor rgb '#555555'
set style line 3 lt 4 lw 2 linecolor -1
set style line 4 lt 5 lw 2 linecolor 1
S(x) = 1.396e9
h(x) = mean_y
fit [1e5:*] h(x) "shockspeed.txt" using 2:1 via mean_y
k(x) = ( 1e5 < x ) ? h(x) : 1/0 
plot "shockspeed.txt" using 2:1 with linespoints ls 2 title 'D',\
S(x) with lines ls 1 title 'D_{CJ} = 1.396e+09',\
k(x) with lines ls 4 title sprintf("Mean: y=%.2e", mean_y)
#g(x) with lines ls 3 title 'running mean'

