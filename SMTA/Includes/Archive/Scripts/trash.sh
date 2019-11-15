#Felix Aguilar Ferrer
#Script para eliminar archivos dentro de la herramienta.

#Obtenemos las librerias del menu y control.
. ${pathsmta}/Includes/Lib/menu.sh
. ${pathsmta}/Includes/Lib/control.sh

#Obtenemos el path de la papelera.
configs trash trash

function delete (){
    #Felix Aguilar Ferrer
    #Muestra el menu para mover los archvivos a la papelera:
    
    #Se genera el menu para eliminar el archivo deseado.
    menu=0
    while [ $menu = 0 ]
    do
    
        #Primera entrada.
        title s49
        title s50
        options s7
        input s48
     
        clear
     
        case $ans in
            1)
                menu=1
                ;;
            *)
                
                #Si ans no esta vacio, entramos a la ejecución.
                if [ ! $ans = '' ]
                then
                
                    #Segunda entrada.
                    title s49
                    title s50
                    
                    #Funcion para obtener los ficheros que coincidan con el patron dado.
                    check ${pathsmta}/Includes/Data/files.txt $ans 1
                    text s54
                    divider
                    input s48
                    clear
                    
                    #Si el usuario introduce un identificador.
                    if [ ! $ans = "" ]
                    then
                        
                        #Se obtiene el valor del identificador del array y se obtiene el valor al cual apunta.
                        let ans=ans-1
                        file=${files[$ans]}
                        
                        #Menu de confirmacion del borrado.
                        title s49
                        title s50
                        output $file
                        divider
                        input s55
                        clear
                        case $ans in
                        y)   
                            
                            #Se obtiene la ruta del fichero a borrar.
                            read paths < <(grep $file ${pathsmta}/Includes/Data/files.txt | cut  -d':' -f 2)
                            
                            #Si existe el archivo se procede a moverse.
                            if [ -e $paths$file ]
                            then
                                #Se mueve elfichero al directorio especificado.
                                mv $paths$file $trash

                                #Se funciona, se modificaran las bases de datos.
                                if [ $? = 0 ]
                                then

                                    #Se elimina la entrada que pertoca.
                                    delline $file ${pathsmta}/Includes/Data/files.txt

                                    #Se genera la linea nueva.
                                    addline ${pathsmta}/Includes/Data/trash.txt $file $paths
                                    correct s57 0
                                fi
                            else
                                error s62 0
                            fi
                            
                            #Se eliminan las variables utilizadas.
                            unset paths
                            unset file
                            unset files
                            ;;
                        n)
                            error s56 0
                            ;;
                        *)
                            ;;
                    esac
                    fi
                    unset files
                fi
                ;;
        esac
    done
    menu=0
}

function recover (){
    #Felix Aguilar Ferrer
    #Muestra el menu para recuperar los archvivos de la papelera:
    
    #Se genera el menu para recuperar el archivo deseado.
    menu=0
    while [ $menu = 0 ]
    do
        
        #Primera interaccion con el usuario.
        title s49
        title s51
        options s7
        input s52
     
        clear
     
        case $ans in
            1)
                menu=1
                ;;
            *)
            
                #Si el usuario introduce un patrón se buscará por este.
                if [ ! $ans = '' ]
                then
                
                    #Segundo menu de interaccion con el usuario.
                    title s49
                    title s51
                    
                    #Funcion para obtener los ficheros que coincidan con el patron dado.
                    check ${pathsmta}/Includes/Data/trash.txt $ans 1
                    text s54
                    divider
                    input s61
                    clear
                    
                    #Si el usuario introduce un identificador.
                    if [ ! $ans = "" ]
                    then
                    
                        #Se obtiene el valor del identificador del array y se obtiene el valor al cual apunta.
                        let ans=ans-1
                        file=${files[$ans]}
                        
                        #Menu de confirmacion del borrado.
                        title s49
                        title s51
                        output $file
                        divider
                        input s58
                        clear
                        case $ans in
                        y)
                            
                            #Se obtiene la ruta del fichero a borrar.
                            read paths < <(grep $file ${pathsmta}/Includes/Data/trash.txt | cut  -d':' -f 2)
                            
                            #Si existe el archivo se procede a moverse.
                            if [ -e $trash$file ]
                            then
                            
                                #Se mueve el fichero al directorio especificado.
                                mv $trash$file $paths 2> /dev/null

                                #Se funciona, se modificaran las bases de datos.
                                if [ $? = 0 ]
                                then

                                    #Se elimina la entrada que pertoca.
                                    delline $file ${pathsmta}/Includes/Data/trash.txt

                                    #Se genera la linea nueva.
                                    addline ${pathsmta}/Includes/Data/files.txt $file $paths
                                    correct s60 0
                                else
                                
                                    #Si no se puede mover el archivo al directorio original, este puede ser movido a la entrada.
                                    menu=0
                                    while [ $menu = 0 ]
                                    do
                                    
                                        #Muestra el mensaje de error y pide la confirmacion para moverlo 
                                        #a la entrada si no es así no se realiza ninguna accion.
                                        error s66 0
                                        input s67
                                        case $ans in
                                            y)
                                                #Se obtiene la ruta a la entrada.
                                                configs new input

                                                #Se mueve elfichero al directorio especificado.
                                                mv $trash$file $input

                                                #Se elimina la entrada que pertoca.
                                                delline $file ${pathsmta}/Includes/Data/trash.txt

                                                correct s60 0
                                                menu=1
                                                ;;
                                            n)
                                                error s59 0
                                                menu=1
                                                ;;
                                            *)
                                                error s19 0
                                                ;;
                                        esac
                                    done
                                    menu=0
                                fi
                            else
                                error s62 0
                            fi
                            
                            #Se eliminan las variables utilizadas.
                            unset paths
                            unset file
                            unset files
                            ;;
                        n)
                            error s59 0
                            ;;
                        *)
                            ;;
                    esac
                    fi
                    unset files
                fi
                ;;
        esac
    done
    menu=0
    menu=0
}

menu=0
while [ $menu = 0 ]
do

    #Menu para seleccionar la accion a realizar.
    title s49
    options s50 s51 s7
    input s16
    
    clear
    
    case $ans in
        1)
            delete
            ;;
        2)
            recover
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