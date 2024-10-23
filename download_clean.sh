i!/bin/bash
# Este pipeline tiene como objetivo leer un fichero input de lista de acceso de secuencias
# para descargar todos los ficheros SRR de su interior y filtrarlos con fastqc. Funciona con secuencias paired-end
# El script se debe situar donde el fichero de secuencias a descargar
echo "Dime qué lista quieres descargar:"
read archivo
lista=$(cat $archivo)
echo "El archivo de lista a descargar es el siguiente: $archivo :"
echo "A continuación comenzará la descarga y análisis de calidad de las siguientes secuencias: $lista"
for i in $lista
do
	echo "SE VA A DESCARGAR LA SECUENCIA: $i"
	fastq-dump --split-3 $i
	echo "LA DESCARGA DE LA SECUENCIA $i SE HA COMPLETADO CON ÉXITO"
done

echo "la lista de secuencias ha sido descargada correctamente"
#Ahora se creará un directorio para organizar las secuencias descargadas
#En caso de que el directorio exista, saltará un aviso de que ya existe y no creará ninguno nuevo

echo "Creando directorio para almacenar las secuencias descargadas..."
for n in {1..10}
do
	if [ ! -d ./fastq_files_$n];then
		mkdir fastq_files_$n
		echo "El directorio fastq_files_$n se ha creado con éxito"
		break
	else 
		$n+=1
		echo "Los directorios anteriores YA EXISTEN, creando nuevos directorios..."
		mkdir fastq_files_$n
	fi
done

echo "moviendo las secuencias al nuevo directorio"
	
mv *.fastq fastq_files_$n

#Finalmente, sera necesario utilizar el comando fastqc para realizar el analisis de calidad de las secuencias
#y almacenarlas de nuevo en un nuevo directorio.

echo "Realizando analisis de calidad Fastqc con las secuencias descargadas en el fichero"
lista2=$(cat *.fastq_files_$n)
for x in $lista2:
do
	echo "Se va a analizar la calidad del archivo: $x"
	fastqc -o ./fastqc_results $x
done

"Descarga y filtrado realizado con exito"

