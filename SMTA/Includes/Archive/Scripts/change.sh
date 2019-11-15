#Felix Aguilar Ferrer.
#Cambio de idioma dels script.

function chlenguage(){ 
    #Felix Aguilar Ferrer.
    #Para cambiar el idioma en la base de datos.
    #Inputs $1 = idioma nuevo. 
    
    #Se obtiene el lenguage actual.
    configs lenguage chlen
    
    #Si es el mismo error, sino cambia el idioma de la base de datos config.txt.
    if [ "$chlen" = "$1" ]
    then
        error s18 0
    else
        sed -i "s/:$chlen:/:$1:/g" ${pathsmta}/Includes/Data/config.txt
        correct s17 0
    fi 
    unset chlen
}

#El bucle se monta para estar en el menu hasta que se decida salir.
menu=0
while [ $menu -eq 0 ]
do
    #Obtenemos la libreria del menu.
    . ${pathsmta}/Includes/Lib/menu.sh

    #Se monta el menu, para ver más accede a /Includes/Lib/menu.sh.
    title s1
    options s5 s6 s7
    input s16
    
    #Comprobamos que acción ha pedido el usuario.
    clear
    case $ans in
        1)
            chlenguage esp
            ;;
        2)
            chlenguage eng
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