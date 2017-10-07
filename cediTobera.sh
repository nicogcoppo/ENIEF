#!/bin/bash
#
# 
# 

############## DECLARACIONES ###########################

# / / / Variables

declare -rx REP="REPOSITORIO/"

declare -r LIM_SUP="25"

declare -r LIM_INF="-25"

declare -r PASO="1"

declare -rx GLOBAL="${PWD}"

# / / / Directorios

############### FUNCIONES ##############################


############## SCRIPT ##################################

ANG=${LIM_INF}

while (("${ANG}" <= "${LIM_SUP}")); do
   
    ACTUAL="Alfa"${ANG}"Grados"

    cp -R "${REP}" ${ACTUAL}

    cd ${ACTUAL} && bash Allrun.sh "${ANG}"

    echo "Proceso Global Finalizado"

    cd ${GLOBAL} && let ANG+=1

done

################### MANTENIMIENTO ##################

exit 0
