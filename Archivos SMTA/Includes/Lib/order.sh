# Creado por Andreu Llabres Bañuls
. ${pathsmta}/Includes/Lib/control.sh
. ${pathsmta}/Includes/Lib/menu.sh
# $1 Metodo de ordenación ej: ext , fchar, lchar o datf
# $2 Directorio de entrada enter por defecto
# $3 Directorio de salida Test  por defecto

# Function para contar los puntos.
function countp(){
    # Recoge los archivos que contengan punto.
    ls -p ${1}*.* | rev | cut -d / -f 1 | rev | sort > ${1}sk/br.txt  
    countt=$(cat ${1}sk/br.txt | wc -l) #Contar las lineas del archivo.
    a=1
    # $x vale cada linea del archivo.
    for x in `cat ${1}sk/br.txt`
    do
        i=1
        num=0
        var=$(expr length $x) # Cuenta los caracteres de $x.
        while [ $i -le $var ]; do
        	# Mientras puedes comprobar que . existe
            if [ `expr substr $x $i 1` = "." ]; then 
               # Sumale .
               let num=num+1
             fi
             # Posicion.
             i=`expr $i + 1`
        done  
        if [ $a -le $countt ]; then # Se ejecuta mientras $a no llegue al total de lineas.
            let num=num+1
            # Lee linea por linea a partir del ultimo punto.
            cat ${1}sk/br.txt | head -$a | tail -1 | cut -d . -f $num  >> $1sk/ext0.txt
            let a=a+1
        fi   
    done
    # Ordena y quita las extensiones repetidas.
    cat ${1}sk/ext0.txt | sort  > ${1}sk/ext.txt
    # Borrar variables usadas.
    unset i
    unset a
    unset num
}
# Funcion para sacar el primer caracter de cada archivo.
function get_fc(){
    # Recoge el nombre de los archivos.
	ls -p ${1} | grep -v / | sort > ${1}sk/br.txt
	for x in `cat ${1}sk/br.txt`
	do
		# Recoge el primer caracter.
		var=$(expr substr $x 1 1)
        #Lo que vale $var lo mete en un archivo
		echo $var >> ${1}sk/fc1.txt
	done
	# Ordena y quita los caracteres repetido
    cat ${1}sk/fc1.txt | sort >> ${1}sk/fc.txt
}
# Funcion para sacar el último caracter de cada archivo.
function get_lc(){
	# Recoge el nombre de los archivos invertidos
	ls -p ${1} | grep -v / | rev > ${1}sk/br.txt
	for a in `cat ${1}sk/br.txt`
	do
        # Recoge el primer caracter.
		var=$(expr substr $a 1 1)
        #Lo que vale $var lo mete en un archivo
        echo $var  >>  ${1}sk/lc1.txt
	done
	# Ordena y quita los caracteres repetidos
    cat ${1}sk/lc1.txt | sort >> ${1}sk/lc.txt
}
# Funcion Principal
function ordfiles(){
pathb=$3
if [[ ! -d ${3}/sk/ ]]; then
    # Comprueba si existen archivos en el directorio de entrada.
    read lecint < <(ls -p ${2} | grep -v / | sort)
    # Si el archivo arcp.txt no esta vacio.
    if [[ ! "$lecint" = '' ]]; then
        # Directorio sk es donde se almacena toda las bases de datos que se maneja en la busqueda de archivos.
        mkdir ${3}sk
        # mueve el Contenido de directorio de entrada a el de salida
        mv ${2}* ${3}
        # Comprueba si existen archivos.
        ls -p ${3} | grep -v / | sort > ${3}sk/arcp.txt
        # Si el archivo arcp.txt no esta vacio.
        if [ -s ${3}sk/arcp.txt ]; then
            if [[ ${1} = ext ]]; then
                countp $pathb
                # Recoge los nombres de los archivos con su extensión.
                ls -p ${3}*.* | rev | cut -d / -f 1 | rev | sort > ${3}sk/arc.txt
                # For para mostrar las extensiones de los archivos.
                for i in `cat ${3}sk/ext.txt`
                do  
                    count=0
                    #Genera los directorios dependiendo de la extensión.        
                    if [[ ! -d ${3}$i/ ]]; then
                        mkdir ${3}$i
                    fi
                    #For para mostrar el nombre del archivo con su extensión
                    for x in `cat ${3}sk/arc.txt`
                    do  
                        #Si el archivo acaba en .extensión
                        if [[ "$x" = *.$i ]]; then
                            # Cambiar el nombre si es igual que el del directorio en el que se mueve.
                            if [[ "$x" = $i.* ]]; then
                                # Mueve el archivo al directorio creado para el.
                                mv ${3}$x ${3}$i/$count-xarchivex.$i
                                # Añade una linea nueva al archivo files.txt
                                addline ${pathsmta}/Includes/Data/files.txt $count-xarchivex.$i ${3}$i/
                                # Borra  la linea que es usada para el for, ya que sino hacemos esto siempre faldrá lo mismo.
                                delline $x ${3}sk/arc.txt
                                let count=count+1
                            else
                                # Mueve el archivo al directorio creado para el.
                                mv ${3}$x ${3}$i/$x
                                # Añade una linea nueva al archivo files.txt
                                addline ${pathsmta}/Includes/Data/files.txt $x ${3}$i/
                                # Borra  la linea que es usada para el for, ya que sino hacemos esto siempre faldrá lo mismo.
                                delline $x ${3}sk/arc.txt
                                let count=count-1
                            fi
                        fi
                    done
                done
                #Ver si quedan archivos existentes que no tengan extensión.
                read lec < <(ls -p ${3} | grep -v / | sort)
                #Si no esta vacio.
                if [ ! "$lec" = '' ]; then
                    ls -p ${3} | grep -v / | sort > ${3}sk/arcsext.txt
                    if [[ -d ${3}Unknown/ ]]; then
                        pathu=Unknown/
                        for a in `cat ${3}sk/arcsext.txt`
                        do
                            # Mueve el archivo al directorio creado para el.
                            mv ${3}$z ${3}$pathu$a
                            # Añade una linea nueva al archivo files.txt
                            addline ${pathsmta}/Includes/Data/files.txt $a ${3}$pathu/
                             # Borra  la linea que es usada para el for, ya que sino hacemos esto siempre faldrá lo mismo.
                            delline $x ${3}sk/arcsext.txt
                        done
                    else
                        pathu=Unknown/
                        mkdir ${3}$pathu
                        for z in `cat ${3}sk/arcsext.txt`
                        do
                            # Mueve el archivo al directorio creado para el.
                            mv ${3}$z ${3}$pathu$z
                            # Añade una linea nueva al archivo files.txt
                            addline ${pathsmta}/Includes/Data/files.txt $z ${3}$pathu/
                             # Borra  la linea que es usada para el for, ya que sino hacemos esto siempre faldrá lo mismo.
                            delline $x ${3}sk/arcsext.txt
                        done
                    fi
                fi
                # Borrar variables
                unset count
                unset lec
                unset pathu
                correct s47 0
            elif [[ ${1} = fchar ]]; then
                get_fc $pathb 
                # Recoge los nombres de los archivos con o sin extensión.
                ls -p ${3} | rev | cut -d / -f 1 | rev | sort > ${3}sk/arc.txt
                # For para mostrar las extensiones de los archivos.
                for i in `cat ${3}sk/fc.txt`
                do  
                    #Genera los directorios dependiendo de la extensión.        
                    if [[ ! -d ${3}$i/ ]]; then
                        mkdir ${3}$i
                    fi
                    #For para mostrar el nombre del archivo con su extensión
                    for x in `cat ${3}sk/arc.txt`
                    do  
                        #Si el archivo acaba en .extensión
                        if [[ "$x" = $i* ]]; then
                            # Mueve el archivo al directorio creado para el y si da un error no lo muestra.
                            mv ${3}$x ${3}$i/$x 2>/dev/null
                            # Añade una linea nueva al archivo files.txt
                            addline ${pathsmta}/Includes/Data/files.txt $x ${3}$i/
                             # Borra  la linea que es usada para el for, ya que sino hacemos esto siempre faldrá lo mismo.
                            delline $x ${3}sk/arc.txt
                        fi
                    done
                done
                correct s63 0
            elif [[ ${1} = lchar ]]; then
                get_lc $pathb
                # Recoge los nombres de los archivos con o sin extensión.
                ls -p ${3} | rev | cut -d / -f 1 | sort > ${3}sk/arc.txt
                # For para mostrar las extensiones de los archivos.
                for i in `cat ${3}sk/lc.txt`
                do  
                    #Genera los directorios.        
                    if [[ ! -d ${3}$i/ ]]; then
                        mkdir ${3}$i
                    fi
                    #For para mostrar el nombre del archivo.
                    for x in `cat ${3}sk/arc.txt`
                    do  
                        # 
                        read iol < <(echo $x)
                        #Si el archivo comienza por
                        if [[ "$iol" = $i* ]]; then
                            # Giras el nombre del archivo
                            read ool < <(echo ${iol} | rev)
                            # Cambiar el nombre si es igual que el  y si da un error no lo muestra.
                            mv ${3}${ool} ${3}$i/${ool} 2>/dev/null
                            # Añade una linea nueva al archivo files.txt
                            addline ${pathsmta}/Includes/Data/files.txt ${ool} ${3}${i}/
                            # Borra  la linea que es usada para el for, ya que sino hacemos esto siempre faldrá lo mismo.
                            delline $x ${3}sk/arc.txt
                        fi
                    done
                done
                correct s64 0
            fi
            # Borrar variables
            unset lecint
            unset pathb
            unset var
            unset ool
            unset iol    
        fi
        # Eliminar base de datos
        rm -r ${3}sk 
    else
        #Error en no has introducido nada en el input.
        error s14 0
    fi
fi
}