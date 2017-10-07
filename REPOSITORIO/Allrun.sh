#!/bin/bash
#
# Script para la confeccion de una transanccion mediante un protocolo
# Si es exitosa, se elimina el archivo, si no lo es se queda

############## DECLARACIONES ###########################

# / / / Variables

declare -r FOAM=""${HOME}"/OpenFOAM/OpenFOAM-5.0/etc/bashrc"

declare var

declare -r ALFA="$1"


# / / / Directorios


declare -r FC="./FcSTL/"

declare -r DIR="${PWD}"

declare -r TRI="./constant/triSurface/"

declare -r temp="./temporal/"

declare -r BLO="./constant/polyMesh/blockMeshDict"

declare -r REP="./_REPOSITORIO/"

declare -r SUR="./system/surfaces"

############### FUNCIONES ##############################

function orientacion { ### no util

    rm -rf ${temp} && mkdir "${temp}"
    echo -e "\n\nOrientando superficies . . ."
    for file in ${FC}/ascii/*.stl; do

	test -z $(surfaceOrient "${file}" ""${temp}"or_"$(basename "${file}")"" "("1e10" "1e10" "1e10")" | grep FATAL) && echo "Orientacion "${file}" ok . . ." || echo "Orientacion "${file}" FALLO"
    done

    
}


function copiado {

    cp "${REP}"constant/polyMesh/blockMeshDict ./constant/polyMesh/
}

############## SCRIPT ##################################


echo "Creando superficies . . ."

rm -rf "${FC}"ascii/* "${FC}"bin/* 

cd ${FC} && sed -i "s/alfa=.*/alfa=${ALFA}/g" freecadTobRot.py && freecadcmd < freecadTobRot.py && echo "Superficies creadas correctamente" || echo "Ocurrio un error en el creado de las superficies"

echo "Cargando variables . . ."
cd ${DIR} && source "${FOAM}" && clear || exit 1



echo "Checkeando superficies . . ."
for file in "${FC}"/ascii/*.stl; do
    test -z $(surfaceCheck "${file}" | grep FATAL) && echo "Checkeo "${file}" ok . . ." || echo "Checkeo "${file}" FALLO"
done

echo -e "\n\nComponiendo STL general"


for file in "${FC}"/ascii/*.stl; do
    case "${file}" in
	*salida*)
	    cat ${file} >> ${TRI}"out_io_orientada.stl" ;;
	
	*entrada*)
	    cat ${file} >> ${TRI}"out_io_orientada.stl" ;;

	*)
	    cat ${file} >> ${TRI}"out_geometria_orientada.stl" ;;
    esac
    
    
done


echo -e "\n\nDetectando limites . . ."

var="$(surfaceCheck "${TRI}"out_geometria_orientada.stl  |  grep "^Bo" | awk '{print $4}' | sed 's/(//')"

limiteXIzq="$(maxima --very-quiet --batch-string "fpprintprec:7$"${var}"*1.009;" | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g)" # + 5%

limiteXDer="$(maxima --very-quiet --batch-string "fpprintprec:7$"${limiteXIzq}"+2;" | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g)" 

var="$(surfaceCheck "${TRI}"out_geometria_orientada.stl  |  grep "^Bo" | awk '{print $5}')"

limiteYInf="$(maxima --very-quiet --batch-string "fpprintprec:7$"${var}"-0.1;" | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g)"

limiteYSup="$(maxima --very-quiet --batch-string "fpprintprec:7$"${limiteYInf}"+2;" | tail -n +4 | sed /^[0-9]/d | sed s/[[:blank:]]//g)" 


sed -i "s/XI/$limiteXIzq/" ${BLO} 

sed -i "s/XD/$limiteXDer/" ${BLO}

sed -i "s/YI/$limiteYInf/" ${BLO}

sed -i "s/YS/$limiteYSup/" ${BLO} 

echo -e "\n\nLimpiando polyMesh . . ." && foamCleanPolyMesh

rm -rf 0/

cp -R 0.org/ 0/

echo -e "\n\n Ejecutando blockMesh . . ."

echo "ver progreso en log.blockMesh . . ."

blockMesh > log.blockMesh


echo -e "\n\n Ejecutando snappyHexMesh . . ."

echo "ver progreso en log.snappyHexMesh . . ."

snappyHexMesh -overwrite > log.snappyHexMesh


echo -e "\n\n Ejecutando checkMesh . . ."

echo "ver progreso en log.checkMesh . . ."

checkMesh > log.checkMesh


echo -e "\n Configurando Diccionarios de postProcesado . . ."

sed -i "s/ALFA_DAT/${ALFA}/" "${FC}"surfaces.wxm && maxima -q -b "${FC}"surfaces.wxm | grep -v "Maxima" | grep "[0-9]$" | tail -n -4 | awk '{print $2 $3}' > "temp"

# Archivos del diccionario surface

PX="$(cat "temp" |  head -1)" && sed -i "s/PX/${PX}/" ${SUR}  
PY="$(cat "temp" |  head -2 | tail -n +2)" && sed -i "s/PY/${PY}/" ${SUR}
NX="$(cat "temp" |  head -3 | tail -n +3)" && sed -i "s/NX/${NX}/" ${SUR}
NY="$(cat "temp" |  tail -n -1)"  && sed -i "s/NY/${NY}/" ${SUR}   

sed -i "s/GPALFA/${ALFA}/" ./*.gp ## archivos de gnuplot

echo -e "\n\n Ejecutando simpleFoam . . ."

echo "ver progreso en log.simpleFoam . . ."

simpleFoam > log.simpleFoam

echo -e "\n\nPostprocesando . . ."

echo "ver progreso en log.postProcess . . ."

postProcess -func 'patchAverage(name=salida,p)' -latestTime > log.postProcess

postProcess -func 'patchAverage(name=salida,U)' -latestTime >> log.postProcess

simpleFoam -postProcess -func yPlus >> log.postProcess

simpleFoam -postProcess -func surfaces -latestTime >> log.postProcess

bash organizador_forces.sh >> log.postProcess

echo "Proceso Finalizado . " 

################### MANTENIMIENTO ##################

exit 0
