#!/usr/bin/gnuplot -persistent

############# VARIABLES ##########################



############# OPCIONES DE VISUALIZACION ############

set term pdfcairo color size 10cm,15cm linewidth 1

set output "./GRAFICAS_FINALES/fuerzas_alfa.pdf"

############# OPCIONES DE TIPO DE PLOTEO ###########

set lmargin 12

set grid

set multiplot layout 3,1


############  PLOTEOS  ############################

set title "Composicion de la Fuerza Resultante"

set xlabel "Angulo Alfa [grados]"

set ylabel "Fuerza [N]"

set xrange [15:24]

#set yrange [-200:-150]

plot "./GRAFICAS_FINALES/data_fuerzas.dat" using 1:($2+$3-$8+$11) ti "Fx" w l,"./GRAFICAS_FINALES/data_fuerzas.dat" using 1:($4+$5-$9+$12) ti "Fy" w l,"./GRAFICAS_FINALES/data_fuerzas.dat" using 1:($6+$7-$13) ti "Fz" w l 

## /////////////////////////////////////////////////////////////

set title "Fuerza Resultante en Funcion del Angulo de Tobera"

set angles degrees

set xlabel "Angulo Alfa [grados]"

set ylabel "Fuerza [N]"

set xrange [15:24]

#set yrange [-200:-150]

#plot "./GRAFICAS_FINALES/data_fuerzas.dat" using (atan(($4+$5-$9+$12)/($2+$3-$8+$11))):sqrt(($4+$5-$9+$12)**2+($2+$3-$8+$11)**2) ti "Fx" w l

plot "./GRAFICAS_FINALES/data_fuerzas.dat" using 1:(sqrt(($4+$5-$9+$12)**2+($2+$3-$8+$11)**2)) ti "Resultante" w l,

### /////////////////////////////////////////////////////////////


set title "Composicion del Momento Resultante"

set xlabel "Angulo Alfa [grados]"

set ylabel "Momento [Nm]"

set xrange [15:24]

#set yrange [-200:-150]

plot "./GRAFICAS_FINALES/data_momentos.dat" using 1:($2+$3-$8+$11) ti "Mx" w l,"./GRAFICAS_FINALES/data_momentos.dat" using 1:($4+$5-$9+$12) ti "My" w l,"./GRAFICAS_FINALES/data_momentos.dat" using 1:($6+$7-$13) ti "Mz" w l 


##################### MANTENIMIENTO ###################

unset multiplot


