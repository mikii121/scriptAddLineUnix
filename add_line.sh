#!/bin/bash
#*********************************************************************************
# Nombre del shell script: PBMC_Mantaspt_M.sh
# Descripcion: Añade una linea a un archivo
# Parametros: Ruta_Archivo y texto_nuevo
# Autor: Miguel Andrés (mac_121@hotmail.com)

#*********************************************************************************

#funciones
function ayuda {
	echo ""
	echo "Programa que permite añadir/sobreescribir lineas de un fichero de una forma sencilla."
	echo ""
	echo "Usage:"
	echo $'\t'"./add_line.sh -f Ruta_Archivo -t texto_nuevo -l numero_linea"
	echo ""
	echo "Options:"
	echo $'\t'"[-h|--help] "$'\t'""$'\t'" Muestra el siguiente mensaje de ayuda."
	echo $'\t'"[-e|--end] "$'\t'""$'\t'" Añade las nuevas líneas en la última posición."
	echo $'\t'"-f|--file file "$'\t'""$'\t'" Archivo dónde se debe incluir la nueva línea."
	echo $'\t'"[-l|--line num_linea] "$'\t'" Línea donde se va a añadir el nuevo texto. (default = 0)"
	echo $'\t'""$'\t'""$'\t'""$'\t'" La primera línea del fichero es la que ocuparía la posición '0' y así sucesivamente."
	echo $'\t'""$'\t'""$'\t'""$'\t'" Si el número de línea es mayor que el tamaño de fichero:"
	echo $'\t'""$'\t'""$'\t'""$'\t'""$'\t'" Si añades:"$'\t'"Se añade al final."
	echo $'\t'""$'\t'""$'\t'""$'\t'""$'\t'" Si remplazas:"$'\t'"Se añade al final una linea nueva."
	echo $'\t'""$'\t'""$'\t'""$'\t'""$'\t'" Si borras:"$'\t'"No hace nada."
	echo $'\t'"-t|--text text "$'\t'""$'\t'" Texto que se quiere insertar."
	echo $'\t'"[-o|--output file] "$'\t'" Fichero donde se guardará el resultado. (default = file origen) "
	echo $'\t'""$'\t'""$'\t'""$'\t'" Cuidado, con este argumento se sobreescribe el fichero en caso de existir."
	echo $'\t'"[-r|--replace] "$'\t'""$'\t'" No añade una linea nueva, reemplaza una que existe."
	echo $'\t'"[-d|--delete] "$'\t'""$'\t'" Elimina la linea seleccionada. (default line = 0)"
	echo ""
	echo "En caso de querer añadir más de una línea, debes separarlas por '\n'"
	echo $'\t'"Ejemplo:   "$'\t'"\"linea\nLinea otra\""
	echo $'\t'"Resultado:"$'\t'"..."
	echo $'\t'"          "$'\t'"linea"
	echo $'\t'"          "$'\t'"Linea otra"
	echo $'\t'"          "$'\t'"..."	
	echo ""
}

# Mientras el número de argumentos NO SEA 0
while [ $# -ne 0 ]
do
    case "$1" in
    -h|--help)
        ayuda	
		exit 2
        ;;
    -f|--file)
        ARCHIVO=$2
        shift
        ;;
    -l|--line)
        LINEA=$2
        shift
        ;;
    -t|--text)
        TEXTO=$2
		shift
        ;;
	-e|--end)
		FINAL=1
		;;
	-o|--output)
		OUTPUT=$2
		shift
		;;
	-r|--replace)
		if [ ! -z $DELETE ] #En caso de que se quiera borrar la linea no se puede reemplazar
		then
			echo "No se puede borrar y reemplazar una linea."
			exit 2
		else
			REPLACE=1
		fi
		;;
	-d|--delete)
		if [ ! -z $REPLACE ] #En caso de que se quiera remplazar la linea no se puede borrar
		then
			echo "No se puede borrar y reemplazar una linea."
			exit 2
		else
			DELETE=1
		fi
		;;
    *)
        echo "add_line: illegal option -- $1."
		ayuda
        exit 2
        ;;
    esac
    shift
done

if [ -z "$ARCHIVO" ]
then
    echo "El archivo el obligatorio (-f file)."
	ayuda
	exit 2
fi
if [ -d $ARCHIVO ]; #si el archivo no existe
then
	echo "El archivo debe existir (-f file)."
	ayuda
	exit 2
fi	
if [ -z "$LINEA" ]
then
	if [ -z "$FINAL" ]
	then
		#echo "El numero de linea por defecto es la primera linea."
		#echo ""
		LINEA=0
	fi
fi
if [ -z "$TEXTO" ]
then
	if [ -z $DELETE ] #En caso de que no se quiera borrar la linea
	then
		echo "El texto de la nueva linea es obligatorio (-t text)."
		ayuda
		exit 2
	fi
fi
if [ ! -z $DELETE ] #En caso de que se quiera borrar la linea
then
	if [ -z "$LINEA" ] #no entraria nunca porque por defecto la linea se pone a 0
	then
		echo "Debes elegir una linea para borrar (-l line)."
		ayuda
		exit 2
	fi
	
	LONGITUD_FICHERO=$( cat $ARCHIVO | wc -l )
	ULTIMA_POSICION_FICHERO=$( expr $LONGITUD_FICHERO - 1 )
	if [ $LINEA -gt $ULTIMA_POSICION_FICHERO ];
	then
		echo "Ninguna linea se ha borrado."
		echo "El número de linea elegido es mayor que el tamaño del fichero."
		exit 2
	fi
fi

 
#ejecucion correcta del programa
if [ -z "$OUTPUT" ] #si has elegido un archivo donde guardar el nuevo, si no por defecto es el mismo que el origen
then
	ARCHIVO_SALIDA=$ARCHIVO
else
	ARCHIVO_SALIDA=$OUTPUT
fi

if [ -z "$FINAL" ] # si no quieres añadirlo al final
then
	RUTA_AUX="$ARCHIVO.aux"
	cp $ARCHIVO $RUTA_AUX
	
	if [ -d $ARCHIVO_SALIDA ]; #si el archivo no existe no lo tiene que eliminar
	then
		rm "$ARCHIVO_SALIDA"
	fi	
	
	head -$LINEA $RUTA_AUX > $ARCHIVO_SALIDA 
	
	if [ ! -z $DELETE ] #En caso de que se quiera borrar la linea
	then
		LINEA=$( expr $LINEA + 1 )
	else	
		printf "$TEXTO\n" >> $ARCHIVO_SALIDA
	fi
	
	if [ ! -z $REPLACE ] #En caso de que se quiera remplazar la linea
	then
		LINEA=$( expr $LINEA + 1 )
	fi
	
	sed '1,'${LINEA}'d' $RUTA_AUX >> $ARCHIVO_SALIDA
	rm "$RUTA_AUX"
else
	printf "$TEXTO\n" >> $ARCHIVO_SALIDA #en caso de querer añadirlo al final
fi

cat $ARCHIVO_SALIDA #muestra el resultado
exit 0
