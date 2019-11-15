#Felix Aguilar Ferrer.
#Menu para el gestor de archivos.

#Obtenemos la libreria del menu.
. ${pathsmta}/Includes/Lib/menu.sh
#Obtenemos la libreria del control.
. ${pathsmta}/Includes/Lib/control.sh
#Obtenemos la libreria de la ordenación de archivos.
. ${pathsmta}/Includes/Lib/order.sh

#El bucle se monta para estar en el menu hasta que se decida salir.
menu=0
while [ $menu -eq 0 ]
do
    
    #Se monta el menu, para ver más accede a /Includes/Lib/menu.sh.
    title s12

    #Se obtiene el directorio donde se hace la ordenacion.
    configs directory direc
    output  $direc s21
    
    #Se obtiene el directorio donde se introducen los ficheros para la ordenacion.
    configs new input
    output  $input s21
    
    #Se obtiene el metodo de la ordenación.
    configs orderby order
    output $order s22
    divider
    options s20 s23 s15
    input s16
    
    clear
    case $ans in
        1)
            #Ordenar archivos por la opcion por defecto
            ordfiles $order $input $direc
            ;;
        2)
            
            #Se redirige al menu para revisar los archivos en el sistema.
            . ${pathsmta}/Scripts/check.sh
            ;;
        3)
            #Para salir del menu, inponemos 1 a la variable menu.
            menu=1
            ;;
        *)
            error s19 0
            ;;
    esac
    
    #Se eliminan las variables que ya no se necesitan.
    unset direc
    unset input
    unset order
    
done
menu=0