#!/usr/bin/gnuplot -persistent

############# OPCIONES DE VISUALIZACION ############

set term pdfcairo color size 10cm,15cm linewidth 1

set output "./RESULTADOS/fuerzas_presion.pdf"

############# OPCIONES DE TIPO DE PLOTEO ###########

set xtics 500

set lmargin 12

set grid

set multiplot layout 3,1


############# VARIABLES ##########################

ALFA=GPALFA

############  PLOTEOS  ############################

set ylabel "Fuerza Presion 'X' [N]"

set xlabel "Iteracion"

#set xrange [2:3]

set yrange [-200:-150]

plot "./postProcessing/forces/0/pressure_x.dat" using 1:($2) ti "Presion X, Alfa=".ALFA w l

## ///////////

set ylabel "Fuerza Presion 'Y' [N]"

set xlabel "Iteracion"

#set xrange [2:3]

set yrange [-500:-200]

plot "./postProcessing/forces/0/pressure_y.dat" using 1:($2) ti "Presion Y, Alfa=".ALFA w l

## ///////////

set ylabel "Fuerza Presion 'Z' [N]"

set xlabel "Iteracion"

#set xrange [2:3]

set yrange [-100:100]

plot "./postProcessing/forces/0/pressure_z.dat" using 1:($2) ti "Presion Z, Alfa=".ALFA w l



##################### MANTENIMIENTO ###################

unset multiplot


