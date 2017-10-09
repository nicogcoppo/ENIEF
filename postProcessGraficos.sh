#!/bin/bash
#
# 
# 

############## DECLARACIONES ###########################

# / / / Variables

declare -r REPO="./REPOSITORIO/"

declare -r AREA_SALIDA=".000254469" #m2

declare -r densidad="1000"

declare -r DIR="${PWD}"

declare -r LIM_INF="$1"

declare -r LIM_SUP="$2"

declare -r FINAL=""${PWD}"/GRAFICAS_FINALES/" && mkdir ${FINAL} || exit 1

declare -r dirF="./postProcessing/forces/0/forces.dat"

declare -r dirU="./postProcessing/patchAverage(name=salida,U)/0/surfaceFieldValue.dat"

declare -r dirY="./postProcessing/yPlus/0/yPlus.dat"

# / / / Directorios

############### FUNCIONES ##############################

function copiado_fuerzas {

    ###### Fuerzas de inercia a la entrada @@@@@@@@@@@@@
    
    sed -i "s/ALFA/${ANG}/" ./postProcessing/forces/0/inerciaEntrada.wxm && maxima -q -b ./postProcessing/forces/0/inerciaEntrada.wxm | awk '{$1=""}1' | grep -v ":" | grep -v "=" | grep "[0-9]" | head -4 | tail -n +2 | tr '\n' '\t' | sed 's/- /-/g' >"temp_f_inercia"

    #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
    x=$(cat ${dirU} | tail -n -1 | awk '{print $2}' | sed 's/(//' | sed 's/)//')

    y=$(cat ${dirU} | tail -n -1 | awk '{print $3}' | sed 's/(//' | sed 's/)//')

    z=$(cat ${dirU} | tail -n -1 | awk '{print $4}' | sed 's/(//' | sed 's/)//')

    Fx="$(maxima --very-quiet --batch-string 'fpprintprec:7$float(('${x}')*sqrt((('${x}')^2)+(('${y}')^2)+(('${z}')^2))*'${densidad}'*'${AREA_SALIDA}');' | tail -n -1 | sed s/[[:blank:]]//g)"

    Fy="$(maxima --very-quiet --batch-string 'fpprintprec:7$float(('${y}')*sqrt((('${x}')^2)+(('${y}')^2)+(('${z}')^2))*'${densidad}'*'${AREA_SALIDA}');' | tail -n -1 | sed s/[[:blank:]]//g)"

    Fz="$(maxima --very-quiet --batch-string 'fpprintprec:7$float(('${z}')*sqrt((('${x}')^2)+(('${y}')^2)+(('${z}')^2))*'${densidad}'*'${AREA_SALIDA}');' | tail -n -1 | sed s/[[:blank:]]//g)"

    echo -e "${Fx}\t${Fy}\t${Fz}" >temp_f
    
    cat ${dirF} | tail -n -1 | awk '{print '${ANG}' "\t" $2 "\t" $3 "\t" $5 "\t" $6 "\t" $8 "\t" $9}' >"data_fuerzas.dat"  

    paste -d '\t' "data_fuerzas.dat" "temp_f" "temp_f_inercia" >> ${FINAL}"data_fuerzas.dat"    
}


function copiado_momentos {

    sed -i "s/ALFA_DAT/${ANG}/" ./postProcessing/forces/0/momentoVectorial.wxm && sed -i "s/FX/${Fx}/" ./postProcessing/forces/0/momentoVectorial.wxm && sed -i "s/FY/${Fy}/" ./postProcessing/forces/0/momentoVectorial.wxm && sed -i "s/FZ/${Fz}/" ./postProcessing/forces/0/momentoVectorial.wxm && maxima -q -b ./postProcessing/forces/0/momentoVectorial.wxm | tail -n -2 | head -1 | awk '{$1=""}1' | tr '[' ' ' | tr ',' '\t' | tr ']' ' ' >"temp_m"

    ############# MOMENTOS INERCIA A LA ENTRADA ###############################

    Fx="$(cat "temp_f_inercia" | awk '{print $1}')"

    Fy="$(cat "temp_f_inercia" | awk '{print $2}')"

    Fz="$(cat "temp_f_inercia" | awk '{print $3}')"

    sed -i "s/-lt//" ./postProcessing/forces/0/momentoVectorialInerciaEntrada.wxm && sed -i "s/ALFA_DAT/${ANG}/" ./postProcessing/forces/0/momentoVectorialInerciaEntrada.wxm && sed -i "s/FX/${Fx}/" ./postProcessing/forces/0/momentoVectorialInerciaEntrada.wxm && sed -i "s/FY/${Fy}/" ./postProcessing/forces/0/momentoVectorialInerciaEntrada.wxm && sed -i "s/FZ/${Fz}/" ./postProcessing/forces/0/momentoVectorialInerciaEntrada.wxm && maxima -q -b ./postProcessing/forces/0/momentoVectorialInerciaEntrada.wxm | tail -n -2 | head -1 | awk '{$1=""}1' | tr '[' ' ' | tr ',' '\t' | tr ']' ' ' >"temp_m_inercia"
    
    ###########################################################################
    
        
    cat ${dirF} | tail -n -1 | awk '{print '${ANG}' "\t" $11 "\t" $12 "\t" $14 "\t" $15 "\t" $17 "\t" $18}' > "data_momentos.dat"  

    paste -d '\t' "data_momentos.dat"  "temp_m" "temp_m_inercia" | sed 's/- /-/g' >>${FINAL}"/data_momentos.dat"
    
}


function copiado_yPlus {

    echo "${ANG}" >"temp_plus"
        
    cat ${dirY} | tail -n -4 | awk '{$1=""}1' | awk '{$1=""}1' | tr ' ' '\n' | grep "^[0-9]" >tmp_yplus
    
    sed -n 1,3p tmp_yplus | tr '\n' '\t' >"flexible_yPlus.dat"
      
    paste -d '\t' "temp_plus" "flexible_yPlus.dat" >>${FINAL}"/flexible_yPlus.dat"
    
    sed -n 4,6p tmp_yplus | tr '\n' '\t' >"pre_tubo_yPlus.dat"
      
    paste -d '\t' "temp_plus" "pre_tubo_yPlus.dat" >>${FINAL}"/pre_tubo_yPlus.dat"
    
    sed -n 7,9p tmp_yplus | tr '\n' '\t' >"tobera_yPlus.dat"
      
    paste -d '\t' "temp_plus" "tobera_yPlus.dat" >>${FINAL}"/tobera_yPlus.dat"
    
    sed -n 10,12p tmp_yplus | tr '\n' '\t' >"tubo_yPlus.dat"
      
    paste -d '\t' "temp_plus" "tubo_yPlus.dat" >>${FINAL}"/tubo_yPlus.dat"
}


############## SCRIPT ##################################

ANG=${LIM_INF}

while (("${ANG}" <= "${LIM_SUP}")); do
   
    ACTUAL="Alfa"${ANG}"Grados"

    cp ${REPO}momentoVectorial.wxm ""${ACTUAL}"/postProcessing/forces/0/momentoVectorialInerciaEntrada.wxm"
    
    cp ${REPO}momentoVectorial.wxm ""${ACTUAL}"/postProcessing/forces/0/"

    cp ${REPO}inerciaEntrada.wxm ""${ACTUAL}"/postProcessing/forces/0/"
    
    cd ${ACTUAL} 
      
    copiado_fuerzas
  
    copiado_momentos

    copiado_yPlus

    cd ${DIR} && let ANG+=1

done

################### MANTENIMIENTO ##################

exit 0
