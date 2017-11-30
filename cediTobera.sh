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

declare -rx PROCS=2

declare -rx LIMITE_ITER="700"

declare -rx LIMITE_ERRORES_PERMITIDOS="3"

declare -rx fijos="${PWD}/partesFijas"

declare -r delta_inferior="0.01" ## Magnitud a separar de la geometria al boundingBox creada con blockMesh

declare DELTA

declare ANG

declare CONTADOR

# / / / Directorios

############### FUNCIONES ##############################


function partesFijas {

    
    mkdir ${fijos} || exit 1

    cp -R ${REP}/FcSTL/ ${fijos}/ && freecadcmd < ${fijos}/FcSTL/freecadFijos.py && echo "Superficies fijas creadas correctamente" || echo "Ocurrio un error en el creado de las superficies fijas"
    
    
}


function configuracionDirectorio {

    	  DELTA="$(maxima --very-quiet --batch-string "fpprintprec:7$"${ANG}"+"${PASO}";" | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g)" 
	  
	  cd ${GLOBAL} 

	  let CONTADOR+=1
  
	  ANG="${DELTA}"

	  delta_inferior_salida="${delta_inferior}"

	  FLAG_ERROR=""

	  CUENTA_ERRORES=0

}


############## SCRIPT ##################################

# Pre-procesado de corrida global

cat LEEME && sleep 1

if [ -d "partesFijas" ]; then

    echo -e "\nATENCION: Existe informacion previa, continuar y sobreescribir Y/N ?"

    read RESPUESTA

    RespuestaY="Y"
    
    if [[ "$RESPUESTA" == "$RespuestaY" ]]; then

	rm -rf partesFijas Alfa*

    else
	exit 1
    fi
    

    
fi


TOTAL="$(maxima --very-quiet --batch-string 'fpprintprec:7$('${LIM_SUP}'-'${LIM_INF}')/'${PASO}';' | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g | sed 's/\.0//')"
## Cantidad Pasos 

echo "Comienzo corrida global entre "${LIM_SUP}" grados y "${LIM_INF}" grados . . ." >${LOG}

echo -e "\nFecha y hora : "$(date)"" >>${LOG}

# Comienzo proceso de calculo

ANG=${LIM_INF}

CONTADOR="0"

delta_inferior_salida="${delta_inferior}" ## Comienzo con el bounding standart

partesFijas ###### Creacion de los stl fijos

FLAG_ERROR=""

CUENTA_ERRORES=0

while (("${CONTADOR}" <= "${TOTAL}")); do

    echo -e "\n-------------------------------------------------" >>${LOG}

    SECONDS=0
    
    echo -e "\nProceso local para "${ANG}" grados iniciado . . ." >>${LOG}

    echo -e "\nFecha y hora : "$(date)"\n" >>${LOG}
    
    ACTUAL="Alfa"${ANG}"Grados"

    cp -R "${REP}" ${ACTUAL} && cp ${fijos}/FcSTL/ascii/* ${ACTUAL}/FcSTL/ascii/ 
     
    cd ${ACTUAL}

    bash -o xtrace Allrun.sh "${ANG}" "${delta_inferior_salida}" "$FLAG_ERROR"

    case $? in

	255) cd ${GLOBAL}

	     if [ "$CUENTA_ERRORES" -gt "$LIMITE_ERRORES_PERMITIDOS" ]; then

		 echo -e "\nEl proceso para el angulo ${ANG} supero la cantidad de intentos tolerable . . ." >>${LOG}

		 mv ${ACTUAL} CUARENTENA_${ANG}

		 configuracionDirectorio

	     else
		 

	     rm -rf temporal/ ; mv ${ACTUAL} temporal/ 
       		 
	     echo -e "\nProceso local fallo para "${ANG}" grados . . ." >>${LOG}

	     var="${delta_inferior_salida}"

	     delta_inferior_salida="$(maxima --very-quiet --batch-string "fpprintprec:7$"${var}"*1.005;" | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g)" # + 5% 

	     echo -e "\n#################### FALLA ################" >>${LOG}
	     
	     echo -e "\nTIEMPO DESPERDICIADO --> $(($SECONDS / 60)):$(($SECONDS - ($SECONDS / 60) * 60)) MM:SS" >>${LOG}
	     
	     echo -e "\nreintentando con delta =  ${delta_inferior_salida} . . ." >>${LOG}

	     FLAG_ERROR="1"

	     let CUENTA_ERRORES+=1

	     fi
	     
	     ;;
	*)

	  configuracionDirectorio
	    
	  echo "Proceso local para "${ANG}" grados Finalizado" >>${LOG}

	  echo -e "\nTIEMPO INVERTIDO --> $(($SECONDS / 60)):$(($SECONDS - ($SECONDS / 60) * 60)) MM:SS" >>${LOG}

	  echo -e "\nTIEMPO ESTIMADO RESTANTE $((($SECONDS / 60) * $CONTADOR)) Minutos" >>${LOG}
	    
	  ;;
	  
    esac
    
	  
done


echo -e "\n\n\nFinalizacion corrida global entre "${LIM_SUP}" grados y "${LIM_INF}" grados . . ." >>${LOG}

echo -e "\nFecha y hora : "$(date)"" >>${LOG}



################### MANTENIMIENTO ##################

exit 0
