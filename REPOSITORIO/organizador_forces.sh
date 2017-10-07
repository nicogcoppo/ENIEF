#!/usr/bin/bash


######################## VARIABLES #########################

declare -r POST="./postProcessing/forces/0/"

declare -r DIR_CASE="${PWD}"

########################## SCRIPT ###########################

echo "Leyendo archivo de fuerzas . . ."

cd ${POST}

sed -i 's/(/ /g' forces.dat

sed -i 's/)/ /g' forces.dat

sed -i 's/,/ /g' forces.dat


#cat ./forces.dat | awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' > pressure.dat

#cat ./forces.dat | awk '{print $1 "\t" $5 "\t" $6 "\t" $7}' > viscous.dat

cat ./forces.dat | awk '{print $1 "\t" $2 }' > pressure_x.dat

cat ./forces.dat | awk '{print $5 }' > viscous_x.dat

paste -d '\t' pressure_x.dat viscous_x.dat > pre_vis_x.dat


cat ./forces.dat | awk '{print $1 "\t" $3 }' > pressure_y.dat

cat ./forces.dat | awk '{print $6 }' > viscous_y.dat

paste -d '\t' pressure_y.dat viscous_y.dat > pre_vis_y.dat


cat ./forces.dat | awk '{print $1 "\t" $4 }' > pressure_z.dat

cat ./forces.dat | awk '{print $7 }' > viscous_z.dat

paste -d '\t' pressure_z.dat viscous_z.dat > pre_vis_z.dat

cd ${DIR_CASE}

echo -e "\n\n Ploteando . . ."

gnuplot < ploteo_totales.gp

gnuplot < ploteo_presion.gp

gnuplot < ploteo_viscosas.gp

#cat ./forces.dat | awk '{print $1 $8 $9 $10}' > porous.dat


echo -e "\n\nlisto ..."

exit 0
