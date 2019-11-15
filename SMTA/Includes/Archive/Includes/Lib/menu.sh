#Felix Aguilar Ferrer.
#Libreria para la creación de menus.

#Llamamos a la libreria de control y buscamos que lenguage actual se esta utilizando
#y creamos una variable para acceder a los ficheros de strings del idioma adecuado.
. ${pathsmta}/Includes/Lib/control.sh
configs lenguage leng
leng=${pathsmta}/Lenguages/$leng.txt

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

function options (){
    #Felix Aguilar Ferrer.
    #Crea el abanico de opciones, este incorpora un divider.
    #Inputs $1 $2 $3 ... = valor identificativo del string, ej: s30 o bien una variable.
    
    #Se crea un indice y se obtiene la cantidad de inputs de la orden.
    n=1
    i=$#
    
    #Mientras n sea menor que i, se irá imprimiendo las opciones.
    while [ $n -le $i ]
    do
    
        #La función string obtiene el valor del fichero de strings adecuado.
        string $1
        
        #Si no se ha encontrado ningun string posible con el valor introducido,
        #Se ecribirá el valor de la variable introducida.
        if [ $? = '0' ]
        then
            echo -$n $str
        else
            echo -$n $1
        fi
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

function output(){
    #Felix Aguilar Ferrer.
    #Crea una linea de texto de color azul.
    #Inputs $1 = variable a imprimir por pantalla.
    #       $2 = valor identificativo del string, ej: s30.
    
    #Se observa si se ha introducido el valor de string.
    if [ ! -z $2 ]
    then
    
        #La función string obtiene el valor del fichero de strings adecuado.
        string $2
        echo -e "\e[44m$str = $1\e[49m"
        else
        
        #Si no se ha introducido, se escribe por pantalla la variable sola.
        echo -e "\e[44m$1\e[49m"
    fi
    
    #Se eliminan las variables que ya no se necesitan.
    unset str  
}