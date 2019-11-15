#Felix Aguilar Ferrer.
#Menu para revisar los ficheros dentro del sistema (utiliza files.txt).

#Obtenemos la libreria del menu.
. ${pathsmta}/Includes/Lib/menu.sh

#El bucle se monta para estar en el menu hasta que se decida salir.
menu=0
while [ $menu -eq 0 ]
do

#Se monta el menu, para ver más accede a /Includes/Lib/menu.sh.
title s23
title s40
correct s41 0
error s42 0
divider
#Ahora se buscará y mostrará los archivos en files.txt

    #Se genera un array con el contenido del archivo files.txt.
    readarray a < ${pathsmta}/Includes/Data/files.txt

    #Se obtiene el directorio de la papelera.
    configs trash bins

    #Se obtiene la longitud total del array  y se crea un indice.
    int=${#a[@]}
    i=0

    #En el bucle se tratará cada archivo.
    while [ $i -lt $int ]
    do
        #Se obtiene el path y el nombre del archivo correspondiente.
        read paths < <(echo ${a[$i]} | cut  -d':' -f 2)
        read names < <(echo ${a[$i]} | cut  -d':' -f 1)


        #Si existe en la ubicación de files.txt se mostrara de color verde, de
        #lo contrario se mostrara de color rojo.
        if [ -f $paths$names ]
        then
            correct $paths$names 1
        else
            error $paths$names 1
        fi

        #Se le añade 1 al indice.
        let i=$i+1
    done

    #Se eliminan las variables que nos son utilizadas.
    unset paths
    unset names
    unset i
    unset a
    unset int
    unset bin
    
divider
options s26 s24 s7
input s16
clear

#Se trata la entrada del usuario.
case $ans in
    1)
        #Para buscar los archivos en el directorio de entrada.
    
        #Se genera un array con el contenido del archivo files.txt.
        readarray a < ${pathsmta}/Includes/Data/files.txt

        #Se obtiene el valor de la carpeta por donde se introducen los archivos al sistema.
        configs new news

        #Se obtiene la longitud total del array  y se crea un indice.
        int=${#a[@]}
        i=0

        #Se genera una variable para comprobar la función.
        res=0

        #En el bucle se tratará cada archivo.
        while [ $i -lt $int ]
        do

            #Se obtiene el path y el nombre del archivo correspondiente.
            read paths < <(echo ${a[$i]} | cut  -d':' -f 2)
            read names < <(echo ${a[$i]} | cut  -d':' -f 1)

            #Si existe el archivo en la carpeta de input, se moverá.
            if [ -f $news/$names ]
            then
                mv $news/$names $paths
                res=1
            fi

            #Se incrementa el indice.
            let i=$i+1
        done

        #Se muestra el mensaje dependiendo del resultado de la operacion.
        if [ $res -eq 1 ]
        then
            correct s25 0
        else
            error s27 0
        fi

        #Se borran las variables que no se neesitan.
        unset news
        unset a
        unset i
        unset res
        unset paths
        unset names
        unset int
        ;;
    2)
        #Para eliminar las entradas del fichero files.txt que no se ubican en la ordenación.
        
        #Se genera un array con el contenido del archivo files.txt.
        readarray a < ${pathsmta}/Includes/Data/files.txt

        #Se obtiene la longitud total del array  y se crea un indice.
        int=${#a[@]}
        i=0

        #Se genera una variable para comprobar la función.
        res=0

        #En el bucle se tratará cada archivo.
        while [ $i -lt $int ]
        do

            #Se obtiene el path y el nombre del archivo correspondiente.
            read paths < <(echo ${a[$i]} | cut  -d':' -f 2)
            read names < <(echo ${a[$i]} | cut  -d':' -f 1)

            #Si no existe, se borra la entrada del archivo files.txt.
            if [ ! -f $paths$names ]
            then
                delline $names ${pathsmta}/Includes/Data/files.txt
                res=1
            fi

            #Se incrementa el indice.
            let i=$i+1
        done

        #Se muestra el mensaje dependiendo del resultado de la operacion.
        if [ $res -eq 1 ]
        then
            correct s25 0
        else
            error s27 0
        fi

        #Se borran las variables que no se neesitan.
        unset a
        unset paths
        unset names
        unset res
        unset i
        unset int
        ;;
    3)
    
        #Para salir del menu, inponemos 1 a la variable menu.
        menu=1
        ;;
    *)
        error s19 0
        ;;
esac
done
menu=0