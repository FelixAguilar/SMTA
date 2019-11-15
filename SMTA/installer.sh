#Felix Aguilar Ferrer.
#Instalador de la utilidad.

#Obtenenos la ruta de este archivo para ubicar todos los requeridos para la instalación.
read pathinst < <( echo $(dirname $(readlink -f $0)) | rev | cut -d'/' -f2- | rev)

#El idioma por defecto.
leng=esp

#Generamos el menu para las opciones se utiliza la libreria menuinstall.sh.
. ${pathinst}/SMTA/Includes/lib.sh

#Se elimina el prompt de pantalla.
clear

#Menu para la selección de lenguaje de la instalación
menu=0
while [ $menu -eq 0 ]
do
    #Menu para la selección del idioma para el instalador.
    divider =
    title s0
    title s2
    text s24
    text s25
    text s26
    divider
    options s3 s4 s5
    input s6
    
    clear
    
    #Segun el dato introducido por el usuario se selecciona el lenguaje del instalador.
    case $ans in
        1)
            leng=eng
            menu=1
            ;;
        2)
            leng=esp
            menu=1
            ;;
        3)
            clear
            error s23 0 
            exit
            ;;
        *)
            error s7 0
            ;;
        esac
done

clear

#Menu para la seleccion de la accion a realizar desinstalar o bien instalar.
menu=0
while [ $menu -eq 0 ]
do
    divider =
    title s0
    text s34
    text s35
    text s36
    text s37
    divider =
    title s38
    text s39
    text s40
    text s41
    divider
    options s44 s45 s5
    input s43
    
    clear
    
    case $ans in 
        1)
            . ${pathinst}/SMTA/Includes/install.sh
            ;;
        2)
            . ${pathinst}/SMTA/Includes/unistall.sh
            ;;
        3)
            menu=1
            ;;
        *)
            error s7 0
            ;;
    esac
done

#Se eliminan las variables usadas.
unset menu
unset leng
unset lenguage
unset pathinst
unset inspath
unset order
unset inpath
unset outpath
unset trashpath
unset step