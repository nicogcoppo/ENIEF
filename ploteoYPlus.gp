#!/usr/bin/gnuplot -persistent

############# VARIABLES ##########################



############# OPCIONES DE VISUALIZACION ############

set term pdfcairo color size 10cm,15cm linewidth 1

set output "./GRAFICAS_FINALES/yPlus_alfa.pdf"

############# OPCIONES DE TIPO DE PLOTEO ###########

set lmargin 12

set grid

set multiplot layout 4,1


############  PLOTEOS  ############################

set title "Distancia Adimensional de Pared y+ [TUBERIA]"

set xlabel "Angulo Alfa [grados]"

set ylabel "y+ [Adimensional]"

set xrange [15:24]

#set yrange [-200:-150]

plot "./GRAFICAS_FINALES/tubo_yPlus.dat" using 1:($2) ti "Min" w l,"" using 1:($3) ti "Max" w l,"" using 1:($4) ti "Med" w l 

## /////////////////////////////////////////////////////////////

set title "Distancia Adimensional de Pared y+ [PRE_TOBERA]"

set xlabel "Angulo Alfa [grados]"

set ylabel "y+ [Adimensional]"

set xrange [15:24]

#set yrange [-200:-150]

plot "./GRAFICAS_FINALES/pre_tubo_yPlus.dat" using 1:($2) ti "Min" w l,"" using 1:($3) ti "Max" w l,"" using 1:($4) ti "Med" w l 

## /////////////////////////////////////////////////////////////

set title "Distancia Adimensional de Pared y+ [FLEXIBLE]"

set xlabel "Angulo Alfa [grados]"

set ylabel "y+ [Adimensional]"

set xrange [15:24]

#set yrange [-200:-150]

plot "./GRAFICAS_FINALES/flexible_yPlus.dat" using 1:($2) ti "Min" w l,"" using 1:($3) ti "Max" w l,"" using 1:($4) ti "Med" w l 


## /////////////////////////////////////////////////////////////

set title "Distancia Adimensional de Pared y+ [TOBERA]"

set xlabel "Angulo Alfa [grados]"

set ylabel "y+ [Adimensional]"

set xrange [15:24]

#set yrange [-200:-150]

plot "./GRAFICAS_FINALES/tobera_yPlus.dat" using 1:($2) ti "Min" w l,"" using 1:($3) ti "Max" w l,"" using 1:($4) ti "Med" w l 


##################### MANTENIMIENTO ###################

unset multiplot


