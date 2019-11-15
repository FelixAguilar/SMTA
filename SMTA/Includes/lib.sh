#Felix Aguilar Ferrer
#Libreria del instalador.

function string(){
    #Felix Aguilar Ferrer.
    #Recoje el string del archivo de lenguaje indicado y lo guarda en la variable str.
    #Inputs $1 = String a buscar.
    read str < <(grep $1 ${pathinst}/SMTA/Includes/$leng.txt | cut -d ':' -f 2)
}

function divider(){
    #Felix Aguilar Ferrer.
    #Crea una división en el menu.
    #Inputs $1 = caracter para dividir.
    #       $2 = numero de caracteres para la linea.
    
    if [ -z $1 ]
    then 
        char="-"
    else
        char=$1
    fi
    
    if [ -z $2 ]
    then 
        length=49
    else
        length=$2
    fi
    
    txt=""
    while [ $length -gt 0 ]
    do
        txt=$txt$char
        let length=length-1
    done
    echo $txt
    
    #Se eliminan las variables usadas.
    unset txt
    unset length
    unset char
}

function title (){
    #Felix Aguilar Ferrer.
    #Crea el titulo del menu, este incorpora un divider.
    #Inputs $1 = valor identificativo del string, ej: s30.
    
    #La función string obtiene el valor del fichero de strings adecuado.
    string $1
    echo - $str
    
    #Se eliminan las variables que ya no se necesitan.
    unset str
    
    #Se crea una división.
    divider "="
}

function text(){
    #Felix Aguilar Ferrer.
    #Crea una linea de texto.
    #Inputs $1 = string.
    
    #La función string obtiene el valor del fichero de strings adecuado.
    string $1
    echo $str
    
    #Se eliminan las variables que ya no se necesitan.
    unset str
}

function options (){
    #Felix Aguilar Ferrer.
    #Crea el abanico de opciones, este incorpora un divider.
    #Inputs $1 $2 $3 ... = valor identificativo del string, ej: s30.
    
    #Se crea un indice y se obtiene la cantidad de inputs de la orden.
    n=1
    i=$#
    
    #Mientras n sea menor que i, se irá imprimiendo las opciones.
    while [ $n -le $i ]
    do
    
        #La función string obtiene el valor del fichero de strings adecuado.
        string $1
        echo -$n $str
        shift
        
        #Se le añade 1 a la variable n
        let n=n+1
    done
    
    #Se eliminan las variables que ya no se necesitan.
    unset n
    unset str
    unset i
    
    #Se crea una división.
    divider
}

function input(){
    #Felix Aguilar Ferrer.
    #Crea una pregunta para que el usuario introduzca un valor
    #Inputs $1 = valor identificativo del string, ej: s30.
    #Output $ans = valor introducido por el usuario.
    
    #La función string obtiene el valor del fichero de strings adecuado.
    string $1
    echo -n "$str "
    
    #Se eliminan las variables que ya no se necesitan.
    unset str
    
    #Se incorpora el valor introducido en la variable.
    read ans
}

function correct(){
    #Felix Aguilar Ferrer.
    #Crea una linea de texto de color verde.
    #Inputs $1 = valor a imprimir o string.
    #       $2 = para saber si es un string o un valor ej: 0 o 1.
    
    #Se comprara el valor del input $2 para saber que se ha introducido en el $1.
    if [ $2 -eq 1 ]
    then
        str=$1
    else
    
        #La función string obtiene el valor del fichero de strings adecuado.
        string $1
    fi
    echo -e "\e[42m$str\e[49m"
    
    #Se eliminan las variables que ya no se necesitan.
    unset str
}

function error(){
    #Felix Aguilar Ferrer.
    #Crea una linea de texto de color rojo.
    #Inputs $1 = valor a imprimir o string.
    #       $2 = para saber si es un string o un valor ej: 0 o 1.
    
    #Se comprara el valor del input $2 para saber que se ha introducido en el $1.
    if [ $2 -eq 1 ]
    then
        str=$1
    else
    
        #La función string obtiene el valor del fichero de strings adecuado.
        string $1
    fi
    echo -e "\e[41m$str\e[49m"
    
    #Se eliminan las variables que ya no se necesitan.
    unset str
}

function output(){
    #Felix Aguilar Ferrer.
    #Crea una linea de texto de color azul.
    #Inputs $1 = valor identificativo del string, ej: s30.
    #       esta mal ! $2 = para saber si es un string o un valor ej: 0 o 1.
    
    #Se comprara el valor del input $2 para saber que se ha introducido en el $1.
    if [ ! -z $2 ]
    then
    
        #La función string obtiene el valor del fichero de strings adecuado.
        string $2
        echo -e "\e[44m$str = $1\e[49m"
        else
        echo -e "\e[44m$1\e[49m"
    fi
    
    #Se eliminan las variables que ya no se necesitan.
    unset str  
}

function addfile(){
    #Felix Aguilar Ferrer
    #Permite crear un fichero de texto que se usara para guardar información.
    #Inputs $1 = Ruta absoluta del fichero.
    #       $2 ... $n = Campos de texto por linea
    
    #Obtenemos el path y movemos el puntero.
    pathfile=$1
    shift
    
    #Si no existe se crea el fichero
    if [ ! -e $pathfile ]
    then
        touch $pathfile
    fi
    
    if [ ! -z $1 ]
    then
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
    
        unset i
        unset n
        unset txt
    
    fi
    
    unset pathfile
}

function checkinput(){
    #Felix Aguilar Ferrer.
    #Permite poner una condicion para verificar la input del usuario.
    #Inputs $1 = variable a verificar.
    #       $2 = texto que acompaña la variable.
    #       $3 = Texto input.
    #       $4 = step actual.
    
    #Se suma 1 al step actual.
    let a=$4+1
    
    #Si el step es igual al futuro step entonces.
    if [ $step -eq $a ]
        then
            output $1 $2
            input $3
            
            clear
            
            case $ans in
            y)
                correct s28 0
                ;;
            n)
                step=$4
                ;;
            *)
                error s7 0
                step=$4
                ;;
            esac
        fi
    unset a
}