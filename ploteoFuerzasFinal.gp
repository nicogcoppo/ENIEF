#!/usr/bin/gnuplot -persistent

############# VARIABLES ##########################



############# OPCIONES DE VISUALIZACION ############

set term pdfcairo color size 10cm,15cm linewidth 1

set output "./GRAFICASALES/fuerzas_alfa.pdf"

############# OPCIONES DE TIPO DE PLOTEO ###########

set lmargin 12

set grid

set multiplot layout 3,1


############  PLOTEOS  ############################

set title "Composicion de la Fuerza Resultante"

set xlabel "Angulo Alfa [grados]"

set ylabel "Fuerza [N]"

#set xrange [15:24]

set yrange [-400:700]

set angles degrees

a = 102.1414058371882 * pi

plot "./GRAFICASALES//data_fuerzas.dat" using 1:($2+$5) ti "Fx" w l,"" using 1:($3+$6) ti "Fy" w l,"" using 1:(a * sin($1)) ti "Fx Teorica" w l,"" using 1:(-a * cos($1)) ti "Fy Teorica" w l 

## /////////////////////////////////////////////////////////////

set title "Fuerza Resultante en Funcion del Angulo de Tobera"

set angles degrees

set xlabel "Angulo Alfa [grados]"

set ylabel "Fuerza [N]"

#set xrange [15:24]

set yrange [250:400]


plot "./GRAFICASALES/data_fuerzas.dat" using 1:(sqrt(($2+$5)**2+($3+$6)**2+($4+$7)**2)) ti "Resultante" w l,

### /////////////////////////////////////////////////////////////


set title "Composicion del Momento Resultante"

set xlabel "Angulo Alfa [grados]"

set ylabel "Momento [Nm]"

#set xrange [15:24]

set yrange [-20:20]

#plot "./GRAFICASALES/data_momentos.dat" using 1:($2+$3-$8+$11) ti "Mx" w l,"./GRAFICASALES/data_momentos.dat" using 1:($4+$5-$9+$12) ti "My" w l,"./GRAFICASALES/data_momentos.dat" using 1:($6+$7-$13) ti "Mz" w l 

#plot "./GRAFICASALES//data_momentos.dat" using 1:($2+$5) ti "Mx" w l,"" using 1:($3+$6) ti "My" w l,"" using 1:($4+$7) ti "Mz" w l

plot "./GRAFICASALES//data_momentos.dat" using 1:($4+$7) ti "Mz" w l


##################### MANTENIMIENTO ###################

unset multiplot


