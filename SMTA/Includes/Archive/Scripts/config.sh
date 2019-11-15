#Felix Aguilar Ferrer.
#Menu para la configuración del script.

#Obtenemos la libreria del menu.
. ${pathsmta}/Includes/Lib/menu.sh

function inputch(){
    #Felix Aguilar Ferrer.
    #Menu para cambiar el directorio donde se ordenan los archivos.
    #Inputs $1 = Para realizar el mover todos los archivos al nuevo directorio. [0 / 1]
    #       $2 = Cambiar path de los archvios dentro de la papelera? [1 / 0]
    
    #Se pide el nuevo path del directorio y nombre.
    divider
    unset ans
    input s39
                
    #Se ejecuta la función para cambiar directorio dependiendo de la entrada.
    changedir $ans $olddir $1 $2
}

function chdir(){
    #Felix Aguilar Ferrer.
    #Menu para cambiar el directorio donde se ordenan los archivos.
    #Inputs $1 = Que directorio se cambia de nombre, este tiene que estar en el archivo config.txt.
    #       $2 = Frase para el Titulo.
    #       $3 = Cambiar path de los archvios dentro de la papelera? 1 o 0
    
    menu=0
    while [ $menu -eq 0 ]
    do
    
        #Obtenemos la libreria del menu.
        . ${pathsmta}/Includes/Lib/menu.sh

        #Obtenemos la libreria de control.
        . ${pathsmta}/Includes/Lib/control.sh
    
        #Se obtiene el valor del directorio a cambiar.
        configs $1 olddir
        
        #Se monta el menu, para ver más accede a /Includes/Lib/menu.sh.
        title $2
        output $olddir s28
        divider
        options s29 s30 s7
        input s16
        clear
        
        #Se trata la entrada del usuario.
        case $ans in
            1)
                inputch 0 0
                ;;
            2)
                inputch 1 $3
                ;;
            3)
                menu=1
                ;;
            *)
                error s19 0
                ;;
        esac
    
    done
    menu=0
}

#El bucle se monta para estar en el menu hasta que se decida salir.
menu=0
while [ $menu -eq 0 ]
do
    
    #Se monta el menu, para ver más accede a /Includes/Lib/menu.sh.
    title s2
    options s8 s9 s10 s38 s11 s7
    input s16
    clear
    
    #Se trata la entrada del usuario.
    case $ans in
        1)
            
            #Accedemos al menu de cambio de idioma.
            . ${pathsmta}/Scripts/change.sh
            ;;
        2)
            #Accedemos al menu de cambio de diretorio.
            chdir directory s9 1
            ;;
        3)
            #Accedemos al menu de cambio de diretorio.
            chdir trash s10 0
            ;;
        4)
            #Accedemos al menu de cambio de diretorio.
            chdir new s38 0
            ;;
        5)
            #Accedemos al menu de ordenación.
            . ${pathsmta}/Scripts/mor.sh
            ;;
        6)
            #Para salir del menu, inponemos 1 a la variable menu.
            menu=1
            ;;
        *)
            error s19 0
            ;;
    esac
done
menu=0