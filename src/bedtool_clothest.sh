DIR=~/mydatalocal/NGS_epigenomics/data/
outDIR=~/mydatalocal/NGS_epigenomics/processed_data/Peak

gtf=${DIR}/Arabidopsis_thaliana.TAIR10.51.gtf

gtf_filtered=${gtf/.gtf/.filtered.gtf}

grep -v "^[MtPt]" ${gtf} | awk '{ if ($3=="gene") print $0 }' |\
awk ' BEGIN { FS=OFS="\t" } { split($9,a,";") ; match(a[1], /AT[0-9]G[0-9]+/) ; id=substr(a[1],RSTART,RLENGTH) ; print $1,$4,$5,id,$7 }' |\
sort -k1,1 -k2,2n > ${gtf_filtered}
#get filtered est le fichier du génomes dont on ne garde que les gènes nucléaires (1er ligne nucléaire puis gène uniquemetn)
#dernière ligne on trie pour plus de rapidité




#BEDTOOLS

for f in ${outDIR}/*broadPeak
do
  #echo ${f/_peaks.broadPeak/}.nearest.genes.txt
  bedtools closest -a $f -b ${gtf_filtered} -D ref > ${f/_peaks.broadPeak/}.nearest.genes.txt
done
#D-ref pour savoir si overlap ou si plus loin
# find the closest, non-overlapping gene for each interval where
# both experiments had a peak
# -io ignores overlapping intervals and returns only the closest,
# non-overlapping interval (in this case, genes)

#permet de savoir quels gène sont possiblement exprimés car accessible

#cd $outDIR
#do
  #echo ${f/_peaks.broadPeak/}.nearest.genes.txt
 # bedtools intersect -a ${outDIR}/2019_006_S6_R_peaks -b ${outDIR}/NOM AUTRE FICHIER QUON COMPARE -D ref > ${f/_peaks.broadPeak/}intersect.genes.txt
#done

###comparer avec bedtools intersect chaque fichier WOX5 donc quiescentes souches avec 374 de la racine
mkdir -p $outDIR

#pour 006 quiescent/racine 374
WOX5=2019_006_S6_R_peaks.broadPeak
racine=2020_374_S4.corrected_peaks.broadPeak

#head $racine

bedtools intersect -v -a ${outDIR}/$WOX5 -b ${outDIR}/$racine -wa > ${outDIR}/${WOX5}_${racine}_difference.txt


#pour 006 quiescent/racine 374
WOX5_genes=2019_006_S6_R.nearest.genes.txt
racine_genes=2020_374_S4.corrected_.nearest.genes.txt

#head $racine

bedtools intersect -v -a ${outDIR}/${WOX5_genes} -b ${outDIR}/${racine_genes} -wa > ${outDIR}/${WOX5_genes}_${racine_genes}_difference.txt
#v on regarde les gènes communs à a.

#################################

Unique_SC=${outDir}/2019_006_S6_R_peaks.broadPeak_2020_374_S4.corrected_peaks.broadPeak_difference.txt

Genes=${Unique_SC}[, c(1)]




