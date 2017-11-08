#!/bin/bash
#
# 
# 

############## DECLARACIONES ###########################

# / / / Variables

declare -rx REP="REPOSITORIO/"

declare -r LIM_SUP="23"

declare -r LIM_INF="-21.5"

declare -r PASO=".5"

declare -rx GLOBAL="${PWD}"

declare -rx LOG="./log.cediTobera"

declare -r delta_inferior="0.01" ## Magnitud a separar de la geometria al boundingBox creada con blockMesh

declare DELTA

declare ANG

declare CONTADOR

# / / / Directorios

############### FUNCIONES ##############################


############## SCRIPT ##################################

# Pre-procesado de corrida global

TOTAL="$(maxima --very-quiet --batch-string 'fpprintprec:7$('${LIM_SUP}'-'${LIM_INF}')/'${PASO}';' | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g | sed 's/\.0//')"
## Cantidad Pasos 

echo "Comienzo corrida global entre "${LIM_SUP}" grados y "${LIM_INF}" grados . . ." >${LOG}

echo -e "\nFecha y hora : "$(date)"" >>${LOG}

# Comienzo proceso de calculo

ANG=${LIM_INF}

CONTADOR="0"

delta_inferior_salida="${delta_inferior}" ## Comienzo con el bounding standart


while (("${CONTADOR}" <= "${TOTAL}")); do

    echo -e "\n-------------------------------------------------" >>${LOG}
    
    echo -e "\nProceso local para "${ANG}" grados iniciado . . ." >>${LOG}

    echo -e "\nFecha y hora : "$(date)"\n" >>${LOG}
    
    ACTUAL="Alfa"${ANG}"Grados"

    cp -R "${REP}" ${ACTUAL}

    cd ${ACTUAL}

    bash -o xtrace Allrun.sh "${ANG}" "${delta_inferior_salida}"

    case $? in

	255) cd ${GLOBAL}

	     rm -rf "${ACTUAL}"

	     echo -e "\nProceso local fallo para "${ANG}" grados . . ." >>${LOG}

	     var="${delta_inferior_salida}"

	     delta_inferior_salida="$(maxima --very-quiet --batch-string "fpprintprec:7$"${var}"*1.005;" | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g)" # + 5% 

	     echo -e "\n#################### FALLA ################" >>${LOG}
	     
	     echo -e "\nreintentando con delta =  ${delta_inferior_salida} . . ." >>${LOG}

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


echo -e "\n\n\nFinalizacion corrida global entre "${LIM_SUP}" grados y "${LIM_INF}" grados . . ." >>${LOG}

echo -e "\nFecha y hora : "$(date)"" >>${LOG}



################### MANTENIMIENTO ##################

exit 0
