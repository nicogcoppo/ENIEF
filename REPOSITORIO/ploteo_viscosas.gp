#!/usr/bin/gnuplot -persistent

############# OPCIONES DE VISUALIZACION ############

set term pdfcairo color size 10cm,15cm linewidth 3

set output "./RESULTADOS/fuerzas_viscosas.pdf"

############# OPCIONES DE TIPO DE PLOTEO ###########

set xtics 500

set lmargin 12

set grid

set multiplot layout 3,1

############# VARIABLES ##########################

ALFA=GPALFA

############  PLOTEOS  ############################


set ylabel "Fuerzas Viscosas 'X' [N]"

set xlabel "Iteracion"

#set xrange [2:3]

set yrange [-10:0]

plot "./postProcessing/forces/0/viscous_x.dat" using ($0+1):1 ti "Viscosa X, Alfa=".ALFA w l

## ///////////

set ylabel "Fuerzas Viscosas 'Y' [N]"

set xlabel "Iteracion"

#set xrange [2:3]

set yrange [-100:50]


plot "./postProcessing/forces/0/viscous_y.dat" using ($0+1):1 ti "Viscosa Y, Alfa=".ALFA w l


## ///////////

set ylabel "Fuerzas Viscosas 'Z' [N]"

set xlabel "Iteracion"

#set xrange [2:3]

set yrange [-1:1]


plot "./postProcessing/forces/0/viscous_z.dat" using ($0+1):1 ti "Viscosa Z, Alfa=".ALFA w l


##################### MANTENIMIENTO ###################

unset multiplot


