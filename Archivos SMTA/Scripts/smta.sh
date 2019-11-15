#Felix Aguilar Ferrer.
#Menu de principal de la herramienta, primera hoja de ejecución.

#Al ser una herramienta no queremos que aparezca el prompt.
clear

#Obtenemos la ruta de este archvio y recortamos el nombre y el primer directorio "Scripts" y guardamos la ruta en la variable pathsmta.
read pathsmta < <( echo $(dirname $(readlink -f $0)) | rev | cut -d'/' -f2- | rev)

#Obtenemos la libreria del menu.
. ${pathsmta}/Includes/Lib/menu.sh
    
#El bucle se monta para estar en el menu hasta que se decida salir.
menu=0
while [ $menu -eq 0 ]
do

    #Se monta el menu, para ver más accede a /Includes/Lib/menu.sh.
    title s3
    title s4
    options s12 s13 s2 s15
    input s16
    clear
    
    #Se trata la entrada del usuario.
    case $ans in
        1)
        
            #Se envia al usuario al menu de ordenacion.
            . ${pathsmta}/Scripts/sort.sh
            ;;
        2)
            #Working...
            . ${pathsmta}/Scripts/trash.sh
            ;;
        3)
            #Se envia al usuario al menu de configuración.
            . ${pathsmta}/Scripts/config.sh
            ;;
        4)
            #Para salir del script.
            menu=1
            ;;
        *)
            error s19 0
            ;;
    esac
done
unset menu