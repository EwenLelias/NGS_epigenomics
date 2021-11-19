# enlever le génome non chromosomiique
# reads qui ont pas mapper
# reads de mauvaise qualité
# régions blacklistées
# reads dupliqués


for mapfile in ~/mydatalocal/NGS_epigenomics/processed_data/mapping/*.bam

do
  java -jar $PICARD MarkDuplicates \
        I=${mapfile} \
        O=${mapfile/".bam"/"marked_duplicate.bam"} \
        M=${mapfile/".bam"/"marked_dup_metrics.txt"}
done

