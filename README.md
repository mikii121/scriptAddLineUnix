# scriptAddLineUnix
Script para añadir lineas a ficheros o para borrarlas


El archivo el obligatorio (-f file).

Programa que permite añadir/sobreescribir lineas de un fichero de una forma sencilla.
```
Usage:
        ./add_line.sh -f Ruta_Archivo -t texto_nuevo -l numero_linea

Options:
        [-h|--help]              Muestra el siguiente mensaje de ayuda.
        [-e|--end]               Añade las nuevas líneas en la última posición.
        -f|--file file           Archivo dónde se debe incluir la nueva línea.
        [-l|--line num_linea]    Línea donde se va a añadir el nuevo texto. (default = 0)
                                 La primera línea del fichero es la que ocuparía la posición '0' y así sucesivamente.
                                 Si el número de línea es mayor que el tamaño de fichero:
                                         Si añades:     Se añade al final.
                                         Si remplazas:  Se añade al final una linea nueva.
                                         Si borras:     No hace nada.
        -t|--text text           Texto que se quiere insertar.
        [-o|--output file]       Fichero donde se guardará el resultado. (default = file origen)
                                 Cuidado, con este argumento se sobreescribe el fichero en caso de existir.
        [-r|--replace]           No añade una linea nueva, reemplaza una que existe.
        [-d|--delete]            Elimina la linea seleccionada. (default line = 0)

En caso de querer añadir más de una línea, debes separarlas por '\n'
        Ejemplo:        "linea\nLinea otra"
        Resultado:      ...
                        linea
                        Linea otra
                        ...
```
