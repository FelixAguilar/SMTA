#Felix Aguilar Ferrer
#Son los menus y acciones para la instalación de la herramienta SMTA.

menu=0
step=1
while [ $menu  -eq 0 ]
do  
    #Seleccion del lenguaje de la herramienta.
    if [ $step -eq 1 ]
    then  
        function incase(){
        step=2
        lenguage=$1
        title s1
        title s2
        checkinput $lenguage s2 s27 1
        }
        
        title s1
        title s2
        text s24
        text s25
        text s26
        divider
        options s3 s4 s5
        input s6
    
        clear
        
        case $ans in
            1)
                incase eng
                ;;
            2)
                incase esp
                ;;
            3)
                menu=1
                ;;
            *)
                error s7 0
                ;;
        esac
    fi
    
    #Seleccion del directorio de la herramienta.
    if [ $step -eq 2 ]
    then
        title s1
        title s8
        text s29
        text s30
        text s31
        divider
        options s9
        input s10
    
        clear
    
        case $ans in
            1)
                step=1
                ;;
            *)
                if [ ! $ans = '' ]
                then
                    if [ -d $ans ]
                    then 
                        inspath=$ans
                        step=3
                        title s1
                        title s8
                        checkinput $inspath s8 s27 2
                    else
                        error s11 0
                    fi
                else
                    error s11 0
                fi
                ;;
        esac
    fi
    
    #Seleccion del metodo de ordenacion. 
    if [ $step -eq 3 ]
    then
        function incase(){
        step=4
        order=$1
        title s1
        title s12
        checkinput $order s12 s27 3
        }
        title s1
        title s12
        text s32
        text s33
        divider
        options s14 s15 s16 s9
        input s13
    
        clear
    
        case $ans in
            1)
                incase "ext"
                ;;
            2)
                incase "fchar"
                ;;
            3)
                incase "lchar"
                ;;
            4)
                step=2
                ;;
            *)
                error s7 0
                ;;
        esac
    fi
    
    #Seleccion del directorio de entrada.
    if [ $step -eq 4 ]
    then
        title s1
        title s18
        text s47
        text s48
        divider
        options s9
        input s10
    
        clear
    
        case $ans in
            1)
                step=3
                ;;
            *)
                if [ -d $ans ]
                then 
                    inpath=$ans
                    step=5
                    title s1
                    title s18
                    checkinput $inpath s18 s27 4
                else
                    error s11 0
                fi
                ;;
        esac
    fi
    
    #Selección del directorio de ordenacion.
    if [ $step -eq 5 ]
    then
        title s1
        title s19
        text s51
        text s52
        divider
        options s9
        input s10
    
        clear
    
        case $ans in
            1)
                step=4
                ;;
            *)
                if [ -d $ans ]
                then 
                    outpath=$ans
                    step=6
                    title s1
                    title s19
                    checkinput $outpath s19 s27 5
                else
                    error s11 0
                fi
                ;;
        esac
    fi
    
    #Seleccion del directorio de la basura.
    if [ $step -eq 6 ]
    then
        title s1
        title s20
        text s49
        text s50
        divider
        options s9
        input s10
    
        clear
    
        case $ans in
            1)
                step=5
                ;;
            *)
                if [ -d $ans ]
                then 
                    trashpath=$ans
                    step=7
                    title s1
                    title s20
                    checkinput $trashpath s20 s27 6
                else
                    error s11 0
                fi
                ;;
        esac
    fi
    
    #Confirmación de los parametros introducidos.
    if [ $step -eq 7 ]
    then
        title s1
        title s21
        output $lenguage s2
        output $inspath s8 
        output $order s12
        output $inpath s18
        output $outpath s19
        
        output $trashpath s20
        divider
        input s22
    
        clear
    
        case $ans in
            y)
                step=8
                ;;
            n)
                menu=1
                error s23 0
                ;;
            *)
                error s7 0
                ;;
        esac
    fi
    
    #Se realiza la instalación.
    if [ $step -eq 8 ]
    then
        text s53
        unzip ${pathinst}/SMTA/Includes/Archive.zip -d $inspath
        
        #Se monta el archivo de  configuración y se crea la base de datos de archivos.
        addfile ${inspath}/Includes/Data/config.txt installdir $inspath
        addfile ${inspath}/Includes/Data/config.txt lenguage $lenguage
        addfile ${inspath}/Includes/Data/config.txt directory $outpath
        addfile ${inspath}/Includes/Data/config.txt new $inpath
        addfile ${inspath}/Includes/Data/config.txt trash $trashpath
        addfile ${inspath}/Includes/Data/config.txt orderby $order
        addfile ${inspath}/Includes/Data/files.txt
        addfile ${inspath}/Includes/Data/trash.txt
        
        menu=1
        correct s53 0
    fi
done
menu=0