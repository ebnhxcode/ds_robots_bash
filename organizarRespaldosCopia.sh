#!/bin/bash

cd /mnt/disks/backups-distantis/from_auto_backup
limiteRespaldos=6

function revisarLimiteRespaldos(){
	#cantidadEnArrayMismoBackup=$(ls -l|awk '{print $9}'|grep "$1"|wc -l)
	#cantidadMismoBackup=${#arrayMismoBackup[@]}

	archivoRecibido=$1	
	arrayMismoBackup=$(ls -l|awk '{print $9}'|grep $archivoRecibido|egrep "(.sql.gz.)")
	cantidadMismoBackup=$(ls -l|awk '{print $9}'|grep $archivoRecibido|egrep "(.sql.gz.)"|wc -l)
	#echo $cantidadMismoBackup

	#$cantidadMismoBackup=$((cantidadMismoBackup))*$((-1))
	#if [[ $cantidadMismoBackup -gt 0 ]];
	#then
		#$index=$((0))

		# Recorro nuevamente pero filtro solo los archivos nuevos a ser copiados
		for i in `ls -l|awk '{print $9}'|grep $archivoRecibido|egrep "(.sql.gz$)"`;
		do
			cantidadMismoBackup=$((cantidadMismoBackup+1))
			for (( x=0; x<=$cantidadMismoBackup; x++ ))
			do
				#echo $x
				#if [[ $(($cantidadMismoBackup-1-$x)) -eq 0 ]];
				if [[ $(($cantidadMismoBackup-1-$x)) -ge 0 ]];
				then
					echo "$archivoRecibido.$(($cantidadMismoBackup-1-$x)) -> $archivoRecibido.$(($cantidadMismoBackup-$x))" >> organizarRespaldos.log
					mv "$archivoRecibido.$(($cantidadMismoBackup-1-$x))" "$archivoRecibido.$(($cantidadMismoBackup-$x))"
				else
					echo "$archivoRecibido -> $archivoRecibido.$(($cantidadMismoBackup-$x))" >> organizarRespaldos.log
					mv "$archivoRecibido" "$archivoRecibido.$(($cantidadMismoBackup-$x))"
				fi
			done


			#echo $index
			#if [[ $index -eq 0 ]];
			#then
				#echo "estamos en 0"
			#fi
			#mv $i "$archivoRecibido.$(($cantidadMismoBackup+1))"
			#echo $archivoRecibido
			#cantidadMismoBackup=$((cantidadMismoBackup+1))
			#echo $cantidadMismoBackup
			#echo $(($cantidadMismoBackup-1))
			#echo $i
			#echo ""
		done
		#mv $i "$i.0"
		#(($index++))
	#fi

}

echo "############################################################" >> organizarRespaldos.log
echo $(date) >> organizarRespaldos.log
echo "" >> organizarRespaldos.log

# Recorre todos los archivos del directorio de backups de bd
for i in `ls -l|awk '{print $9}'`;
do
	
	# Envia el archivo a f(x) para ordenar
	revisarLimiteRespaldos "$i"	
done

if [[ `ls -l|awk '{print $9}'|egrep "(\.sql.gz$)"|wc -l` -eq 0 ]];
then
	echo ""
	echo "No hay más respaldos para organizar" >> organizarRespaldos.log
fi

echo "" >> organizarRespaldos.log
echo $(date) >> organizarRespaldos.log
echo "############################################################" >> organizarRespaldos.log
