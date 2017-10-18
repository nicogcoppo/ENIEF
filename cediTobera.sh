#!/bin/bash
#
# 
# 

############## DECLARACIONES ###########################

# / / / Variables

declare -rx REP="REPOSITORIO/"

declare -r LIM_SUP="22"

declare -r LIM_INF="-25"

declare -r PASO=".5"

declare -rx GLOBAL="${PWD}"

declare -rx LOG="./log.cediTobera"

declare -r delta_inferior="0.1" ## Magnitud a separar de la geometria al boundingBox creada con blockMesh

declare DELTA

declare ANG

declare CONTADOR

# / / / Directorios

############### FUNCIONES ##############################


############## SCRIPT ##################################

# Pre-procesado de corrida global

TOTAL="$(maxima --very-quiet --batch-string 'fpprintprec:7$('${LIM_SUP}'-'${LIM_INF}')/'${PASO}';' | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g | sed 's/\.0//')" ## Cantidad Pasos 

echo "Comienzo corrida global entre "${LIM_SUP}" grados y "${LIM_INF}" grados . . ." >${LOG}

echo -e "\nFecha y hora : "$(date)"" >>${LOG}

# Comienzo proceso de calculo

ANG=${LIM_INF}

CONTADOR="0"

delta_inferior_salida="${delta_inferior}" ## Comienzo con el bounding standart


while (("${CONTADOR}" <= "${TOTAL}")); do

    echo -e "\nProceso local para "${ANG}" grados iniciado . . ." >>${LOG}
    
    ACTUAL="Alfa"${ANG}"Grados"

    cp -R "${REP}" ${ACTUAL}

    cd ${ACTUAL}

    bash Allrun.sh "${ANG}" "${delta_inferior_salida}"

    case $? in

	255) cd ${GLOBAL}

	     rm -rf "${ACTUAL}"

	     echo "Proceso local fallo para "${ANG}" grados . . ." >>${LOG}

	     var="${delta_inferior_salida}"

	     delta_inferior_salida="$(maxima --very-quiet --batch-string "fpprintprec:7$"${var}"*1.05;" | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g)" # + 5% 
	     
	     echo "reintentando con delta =  ${delta_inferior_salida} . . ." >>${LOG}

	     ;;
	*)

	  DELTA="$(maxima --very-quiet --batch-string "fpprintprec:7$"${ANG}"+"${PASO}";" | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g)" 
	  
	  cd ${GLOBAL} 

	  let CONTADOR+=1

	  echo "Proceso local para "${ANG}" grados Finalizado" >>${LOG}

	  ANG="${DELTA}"

	  delta_inferior_salida="${delta_inferior}"
	  
	  ;;
	  
    esac
    
	  
done


echo -e "\nFinalizacion corrida global entre "${LIM_SUP}" grados y "${LIM_INF}" grados . . ." >>${LOG}

echo -e "\nFecha y hora : "$(date)"" >>${LOG}



################### MANTENIMIENTO ##################

exit 0
