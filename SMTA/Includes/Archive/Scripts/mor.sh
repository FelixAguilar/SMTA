#Creado por Andreu Llabres Bañuls.
#Librerias a utilizar.
. ${pathsmta}/Includes/Lib/menu.sh
. ${pathsmta}/Includes/Lib/order.sh
. ${pathsmta}/Includes/Lib/control.sh
# funcion para obtener el directorio de entrada, de salida y el tipo agrupacion por defecto.
configs directory direc
configs new new
configs orderby orderby
#El bucle se monta para estar en el menu hasta que se decida salir.
menu=0

while [ $menu -eq 0 ]
do
    #Se monta el menu, para ver más accede a /Includes/Lib/menu.sh.
    title s3 
    title s11
    configs orderby orderby
    output $orderby s22
    divider
    options s44 s45 s46 s15
    input s16
    clear

    #Es la entrada que el usuario utilizara.
    case $ans in

        1)
            # Ordenar por extensión.
            if [ $orderby != ext ]; then
                resetfiles
                sed -i "s/:$orderby:/:ext:/g" ${pathsmta}/Includes/Data/config.txt                
                ordfiles ext $new $direc
            else
                # Error ya esta en uso este tipo de agrupacion.
                error s65 0 
            fi
            ;;

        2)
            #Ordenar por primer caracter.
            if [ $orderby != fchar ]; then
                resetfiles
                sed -i "s/:$orderby:/:fchar:/g" ${pathsmta}/Includes/Data/config.txt  
                ordfiles fchar $new $direc
            else
                error s65 0 
            fi
            ;;

        3)
            #Ordenar por el ultimo caracter.
            if [ $orderby != lchar ]; then
                resetfiles
                sed -i "s/:$orderby:/:lchar:/g" ${pathsmta}/Includes/Data/config.txt  
                ordfiles lchar $new $direc
            else
                error s65 0 
            fi
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
menu=0
