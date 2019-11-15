#Felix Aguilar Ferrer.
#Libreria para la obtención de parametros en ficheros.

function configs(){
    #Felix Aguilar Ferrer.
    #Recoje un campo del archivo config.txt y lo guarda en la variable deseada.
    #Inputs $1 = Campo del archivo.
    #       $2 = Variable donde se guarda.
    
    read $2 < <(grep $1 ${pathsmta}/Includes/Data/config.txt | cut -d ':' -f 2)
}

function string(){
    #Felix Aguilar Ferrer.
    #Recoje el string del archivo de lenguaje indicado y lo guarda en la variable str.
    #Inputs $1 = String a buscar.
    
    read str < <(grep $1 $leng | cut -d ':' -f 2)
}

function changedir(){
    #Felix Aguilar Ferrer.
    #Cambia el directorio especifiado que este dentro de config.txt.
    #Inputs $1 = Nuevo directorio.
    #       $2 = Directorio viejo.
    #       $3 = Se mueven los archivos? 0 o 1.
    #       $4 = Se mueve papelera? 0 o 1.
    
    #Se realizan comprobaciones para evitar errores por parte del usuario.
    if [ ! "$1" = "" ]
    then 
        if [ ! $1 = $2 ]
        then
            if [ ! -d $1 ]
            then
                
                #Si se puede crear el directorio, entonces se cambia en el archivo config.txt.
                mkdir $1
                if [ $? = 0 ]
                then
                    sed -i "s|:$2:|:$1:|g" ${pathsmta}/Includes/Data/config.txt
                    correct s37 0
                    
                    #Si se han de mover los archivos, se realiza un cp de todos los archivos y 
                    #directorios que contiene el directorio anterior.
                    if [ $3 -eq 1 ]
                    then
                        cp -r $2* $1
                        
                        #Si ha sido un exito, se pasa a procesar la base de datos de archivos.
                        if [ $? = 0 ]
                        then
                        
                            #Se elimina la carpeta anterior.
                            rm -r $2
                            
                            #Se genera un array con todos los valores de files.txt.
                            readarray a < ${pathsmta}/Includes/Data/files.txt
                            
                            #Se crea un index y la longitud de los arrays.
                            i=0
                            int=${#a[@]}

                            #Se van a procesar todas las entradas del array.
                            while [ $i -lt $int ]
                            do
                                #Se lee el nombre del archivo y se busca por el sistema sabiendo aproximadamente 
                                #la ruta donde se encuentra ($1) y recortando el nombre.
                                read name < <(echo ${a[$i]} | cut  -d':' -f 1)
                                read where < <(find $1 -name "$name" 2> /dev/null | rev | cut -d'/' -f2- | rev)

                                #Si ha sido exitosa la busqueda, se realiza lo siguiente.
                                if [ $? = 0 ]
                                then

                                    #Se recupera su antiguo path.
                                    read old < <(echo ${a[$i]} | cut  -d':' -f 2)

                                    #Se sustituye el path antiguo con el nuevo.
                                    sed -i "s|:$old:|:$where/:|g" ${pathsmta}/Includes/Data/files.txt
                                fi

                                #Se suma uno al indice y se eliminan las variables.
                                let i=$i+1
                                unset where
                                unset old
                                unset name
                            done

                            #Se eliminan las variables que no se utilizan.
                            unset a
                            unset int
                            unset i
                            
                            #Tratamiento de la papelera.
                            if [ $4 = 1 ]
                            then
                            
                                #Se genera un array con todos los valores de files.txt.
                                readarray a < ${pathsmta}/Includes/Data/trash.txt

                                #Se crea un index y la longitud de los arrays.
                                i=0
                                int=${#a[@]}

                                while [ $i -lt $int ]
                                do
                                    #Se van a procesar todas las entradas del array.
                                    read old < <(echo $a[$i] | cut  -d':' -f 2 )
                                    read dir < <(echo $a[$i] | cut  -d':' -f 2 | cut -d'/' -f5- )

                                    #Se sustituye el path antiguo con el nuevo.
                                    sed -i "s|:$old:|:$1$dir:|g" ${pathsmta}/Includes/Data/trash.txt

                                    #Se suma uno al indice y se eliminan las variables.
                                    let i=$i+1
                                    unset dir
                                    unset old
                                done

                                #Se eliminan las variables que no se utilizan.
                                unset a
                                unset int
                                unset i
                            fi
                            
                            correct s36 0
                        else
                            error s35 0
                        fi
                    fi
                else
                    error s34 0
                fi
            else
                error s33 0
            fi
        else
            error s32 0
        fi
    else
        error s31 0
    fi
}

function addline(){
    #Felix Aguilar Ferrer.
    #Permite la inserción de lineas con el caracter divisor :.
    #Inputs $1 = Fichero destino.
    #       $2 $3 $4 ... = Campos a insertar.
    
    #Obtenemos el path y movemos el puntero.
    pathfile=$1
    shift
    
    #Se crea el indice y el numero de parametros introducidos se obtiene
    #ademas de crear el inicio del string.
    i=$#
    n=1
    txt=""
    
    #El bucle para añadir campos.
    while [ $n -le $i ]
    do
    txt="$txt$1:"
    shift
    let n=$n+1
    done
    
    #Se introduce la linea al archivo.
    echo -e $txt 1>> $pathfile
}

function delline(){
    #Felix Aguilar Ferrer.
    #Permite eliminar una linea con un parametro.
    #Inputs $1 = patron a buscar.
    #       $2 = fichero donde buscar y eliminar.
    
    #Se elimina la linea donde ha encontrado el patron.
    awk -v req=$1 '$0 !~ req' $2 > temp && mv temp $2
}

function resetfiles(){
    #Felix Aguilar Ferrer
    #Mueve todos los ficheros al directorio input y 
    #elimina la entradas de estos en el fichero files.txt.
    
    #Se obtiene los path del directorio de entrada y salida.
    . ${pathsmta}/Includes/Lib/control.sh
    configs new input
    configs directory out
    
    #Se recojen todas las entradas del fichero files.txt
    readarray files < <(cat ${pathsmta}/Includes/Data/files.txt)
    
    #Se recoje la longitud del array ademas de crear un indice para procesarlos.
    int=${#files[@]}
    i=0
    
    #Si no esta vacio, longitud = 0, no se realizará nada mas.
    if [ ! $int -eq 0 ]
    then
        
        #Se procesa cada entrada en el fichero.
        while [ $i -lt $int ]
        do   
        
            #Se obtienen el nombre y la ruta del archivo.
            read name < <(echo  ${files[$i]} | cut -d ':' -f 1)
            read path < <(echo ${files[$i]} | cut -d ':' -f 2)
            
            #Se mueve el archivo al fichero de entrada y se elimina la entrada del fichero files.txt
            mv $path$name $input
            delline $name ${pathsmta}/Includes/Data/files.txt
            
            #Se augmenta el indice en 1 y se eliminan las variables.
            let i=i+1
            unset name
            unset path
        done
        
        #Finalmente se eliminan los directorios restantes en el directorio de salida.
        rm -r $out/*
        
        #Se eliminan las variables utilizadas.
        unset out
        unset files
        unset input
    fi
}

function check(){    
    #Felix Aguilar Ferrer
    #Para buscar y mostrar los archivos por pantalla. 
    #Inputs $1 = Fichero txt donde busca los nombres.
    #       $2 = Valor a buscar dentro de este.
    #       $3 = Campo donde busca el nombre.
    
    #Se guardan en un array todos los valores que coincidan con el dato introducido.
    readarray files < <(cut -d ':' -f $3 $1 | grep "$2")
    
    #Comprobamos que el array no esta vacio.
    if [ ! -z $files ]
    then
        #Si no lo esta, se obtiene la longitud y se genera un indice.
        int=${#files[@]}
        i=0
        
        #Entramos en un bucle el cual guardará los datos en forma de lista en una variable.
        while [ $i -lt $int ]
        do    
        inside="$inside ${files[$i]}"
        let i=$i+1
        done
        
        #Se generá una lista de los datos inpuestos.
        options $inside
        
        #Se elimina la variable inside.
        unset inside
    else
    
        #Se genera este error cuando no se encuentran coincidencias.
        error s53 0
        divider
    fi
}