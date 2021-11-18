ls /softwares/Trimmomatic-0.39/
#vérifie que trimmomatic-0.39.jar est dans son dossier

trimmomatic=/softwares/Trimmomatic-0.39/trimmomatic-0.39.jar
#pour simplifier le code on créer une variable qui va direcement
#chercher la fonction trimmomatic dans son répertoir attention
#à ne pas mettre d'espace lors de l'affectation d'une variable

java -jar $trimmomatic
#obliger de passer par java pour faire tourner la fonction

Nextera=/softwares/Trimmomatic-0.39/adapters/NexteraPE-PE.fa
#adaptater illumina


for f in ~/mydatalocal/NGS_epigenomics/data/non_publi/*1.fastq.gz
#on parcours les échantillons quand on se place dans Data
# on ne doit pas mettre *.fastq parce que sinon ça parcours
#deux fois les rads lors du trimming qui fait les deux bruns
#complémentaires en même temps.

do
	n=${f%%1.fastq.gz}
	#pour le nouveau nom on garde tout ce qu'il y a avant le 1.
	#echo $n
	prefixe=${n/"data/non_publi"/"processed_data/Trim/trimmed"}
	#change le préfixe qui servira à mettre dans le nouveau dossier
	#echo $prefixe
	java -jar $trimmomatic PE -threads 6 ${n}1.fastq.gz ${n}2.fastq.gz \
	${prefixe}1_paired.fastq.gz ${prefixe}1_unpaired.fastq.gz \
	${prefixe}2_paired.fastq.gz ${prefixe}2_unpaired.fastq.gz \
	ILLUMINACLIP:${Nextera}:2:30:10 SLIDINGWINDOW:4:15 MINLEN:25
done


for f in ~/mydatalocal/NGS_epigenomics/data/data_article/*1.fastq #on parcours les échantillons quand on se place dans Data
# on ne doit pas mettre *.fastq parce que sinon ça parcours deux fois les rads lors du trimming qui fait les deux bruns complémentaires en même temps.

do
	n=${f%%1.fastq} #pour le nouveau nom on garde tout ce qu'il y a avant le 1.
	#echo $n
	prefixe=${n/"data/data_article"/"processed_data/Trim/trimmed"} #change le préfixe qui servira à mettre dans le nouveau dossier
	#echo $prefixe
	java -jar $trimmomatic PE -threads 6 ${n}1.fastq ${n}2.fastq \
	${prefixe}1_paired.fastq ${prefixe}1_unpaired.fastq \
	${prefixe}2_paired.fastq ${prefixe}2_unpaired.fastq \
	ILLUMINACLIP:${Nextera}:2:30:10 SLIDINGWINDOW:4:15 MINLEN:25
done

cd ~/mydatalocal/NGS_epigenomics/processed_data/Trim/trimmed

fastqc *.fast*

mv *fastqc.* ~/mydatalocal/NGS_epigenomics/processed_data/Trim/fastqc/

cd ~/mydatalocal/NGS_epigenomics/processed_data/Trim/fastqc/

multiqc .

mv multiqc* ~/mydatalocal/NGS_epigenomics/processed_data/Trim/multiqc/


