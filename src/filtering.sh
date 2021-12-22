#Filtrage des régions mappées

# enlever le génome non chromosomiique
# reads qui ont pas mapper
# reads de mauvaise qualité
# régions blacklistées
# reads dupliqués


for mapfile in ~/mydatalocal/NGS_epigenomics/processed_data/mapping/*.bam

# marquer es reads dupliqués
do
  java -jar $PICARD MarkDuplicates \
        I=${mapfile} \
        O=${mapfile/".bam"/"marked_duplicate.bam"} \
        M=${mapfile/".bam"/"marked_dup_metrics.txt"}
done


# enlever les régions correspondant au génome mitochondriaux ou chloroplastique
grep -v -E "Mt|Pt" ~/mydatalocal/NGS_epigenomics/data/TAIR10_selectedRegions.bed > \
~/mydatalocal/NGS_epigenomics/data/TAIR10_selectedRegions_plus.bed


#samtool view -b -F 4 SRR4000472_sorted.bam > SRR4000472_sorted_mapped.bam

dir_selected=~/mydatalocal/NGS_epigenomics/processed_data/mapping #on crée des variables chemins d'accès
workdir=~/mydatalocal/NGS_epigenomics/processed_data/duplicate
TAIR=~/mydatalocal/NGS_epigenomics/data


#enlevez les reads qu'on ne veut pas
for f in $dir_selected/*duplicate.bam
do
  file_name="$(basename -- $f)" #basename permet de récupérer le nom du fichier seulement
  samtools view -b $f -L ${TAIR}/TAIR10_selectedRegions_plus.bed -F 1024 -f 3 -q 30 -o ${workdir}/${file_name/".bam"/"_filtered.bam"}
done
#-F on enlève les dupliqués
#-f 3 on enlève les unpaired (on garde les paired)
#-q 30 limite de qualité
#-b ==> sorite fichier bam
#-L afficher seulement les reads des régions qu'on a mappé
# - o vers le fichier de sauvegarder avec les noms de sauvegarde


