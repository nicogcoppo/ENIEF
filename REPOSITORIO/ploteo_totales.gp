#!/usr/bin/gnuplot -persistent

############# OPCIONES DE VISUALIZACION ############

set term pdfcairo color size 10cm,15cm linewidth 1

set output "./RESULTADOS/fuerzas_totales.pdf"

############# OPCIONES DE TIPO DE PLOTEO ###########

set xtics 500

set lmargin 12

set grid

set multiplot layout 3,1

############# VARIABLES ##########################

ALFA=GPALFA


############  PLOTEOS  ############################

set ylabel "Fuerza Presion/Viscosas 'X' [N]"

set xlabel "Iteracion"

#set xrange [2:3]

set yrange [-200:-150]

plot "./postProcessing/forces/0/pre_vis_x.dat" using 1:($2+$3) ti "Fuerza X, Alfa=".ALFA w l

## ///////////

set ylabel "Fuerza Presion/Viscosas 'Y' [N]"

set xlabel "Iteracion"

#set xrange [2:3]

set yrange [-500:-200]

plot "./postProcessing/forces/0/pre_vis_y.dat" using 1:($2+$3) ti "Fuerza Y, Alfa=".ALFA w l

## ///////////

set ylabel "Fuerza Presion/Viscosas 'Z' [N]"

set xlabel "Iteracion"

#set xrange [2:3]

set yrange [-100:100]

plot "./postProcessing/forces/0/pre_vis_z.dat" using 1:($2+$3) ti "Fuerza Z, Alfa=".ALFA w l


##################### MANTENIMIENTO ###################

unset multiplot


