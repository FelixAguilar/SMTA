#Felix Aguilar Ferrer
#Desinstalador de la herramienta SMTA.

menu=0
step=1
while [ $menu  -eq 0 ]
do

#Menu para la introducción del path de instalacion.
title s1
title s56
options s9
input s57

clear

case $ans in
    1)
        menu=1 
        ;;
    *)
    
        #Si no esta en blanco se utiliza como path.
        if [ ! $ans = '' ]
            then
            
                #Se comprueba que exista el directorio.
                if [ -d $ans ]
                then 
                    
                    #Se comprueba que exista los fichero principal de la herramienta.
                    if [ -e ${ans}/Scripts/smta.sh ]
                    then
                        
                        #Si existe entonces se eliminan los ficheros.
                        rm -r ${ans}/* 
                        
                        #Se comprueba que se ha podido realizar.
                        if [ $? = 0 ]
                        then
                            correct s58 0
                        else
                            error s59 0
                        fi
                    else
                        error s60 0
                    fi
                else
                    error s11 0
                fi
        else
            error s11 0
        fi
        ;;
esac
done
menu=0