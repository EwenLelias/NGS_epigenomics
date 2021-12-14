cd ~/mydatalocal/NGS_epigenomics/data

wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/arabidocontratac/Scripts/plot_tlen.R

wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/arabidocontratac/Scripts/plot_tss_enrich.R

%wget http://ftp.ebi.ac.uk/ensemblgenomes/pub/release-52/plants/gtf/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.52.gtf.gz

%gunzip $cd/Arabidopsis_thaliana.TAIR10.52.gtf.gz


TAIR=~/mydatalocal/NGS_epigenomics/data

gtf=${TAIR}/Arabidopsis_thaliana.TAIR10.51.gtf
# chromosome, gene/transcript/transposon, coordonées, gene_id, role_du_gene

wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/arabidocontratac/Supporting_files/TAIR10_ChrLen.txt

selected_regions=${TAIR}/TAIR10_selectedRegions.bed

genome=${TAIR}/TAIR10_ChrLen.txt #info sur la longueur des chromosomes

# Variables for TSS enrichment
width=1000 #FENETRE AUTOUR DU tss
flanks=100 #côté de la fenêtre ==> CACLUL COUVERTURE moyenne dans le génome

# Variables for insert size distribution
chrArabido=${TAIR}/TAIR10_ChrLen.bed
grep -v -E "Mt|Pt" ${chrArabido} > ${TAIR}/TAIR10_ChrLen_1-5.bed
# on enlève les chromosomes mitochondiraux et vhloroplastique
#grep enlève toutes les ligens qui commence par Mt ou Pt
#-v chercher Mt et Pt
#-E exclure Mt et Pt
chrArabido=${TAIR}/TAIR10_ChrLen_1-5.bed

#////////////////////// Start of the script

ID=2019_006_S6        # sample ID POUR L'INSTANT ON EN FAIT QU'UN ET ENSUITE ON FERA LES AUTRES
bam_suffix=_Rsortedmarked_duplicate_filtered.bam #POUR L'INSTANT ON EN FAIT QU'UN ET ENSUITE ON FERA LES AUTRES

mkdir -p ${TAIR}

bam=~/mydatalocal/NGS_epigenomics/processed_data/duplicate/${ID}${bam_suffix}
echo $bam
samtools view ${bam} | head 

# ------------------------------------------------------------------------------------------------------------ #
# --------------------------- Compute TSS enrichment score based on TSS annotation --------------------------- #
# ------------------------------------------------------------------------------------------------------------ #

#1. Define genomic regions of interest


#bedtools = manipulation de bam et bed

echo "-------------------------- Define genomic regions of interest"
grep -v "^[MtPt]" ${gtf} | awk '{ if ($3=="gene") print $0 }'  |\
grep "protein_coding" |\
awk ' BEGIN { FS=OFS="\t" } { split($9,a,";") ; match(a[1], /AT[0-9]G[0-9]+/) ; id=substr(a[1],RSTART,RLENGTH) ; if ($7=="+") print $1,$4,$4,id,$7 ; else print $1,$5,$5,id,$7 } ' |\
uniq | bedtools slop -i stdin -g ${genome} -b ${width} > ${TAIR}/tss_${width}.bed

#fichier tss: chromosmoe, start stop non du gène orientation

bedtools intersect -u -a ${TAIR}/tss_${width}.bed -b ${selected_regions} > ${TAIR}/tmp.tss && mv ${TAIR}/tmp.tss ${TAIR}/tss_${width}.bed
echo `cat ${TAIR}/tss_${width}.bed | wc -l` "roi defined from" ${gtf}

tssFile=${TAIR}/tss_${width}.bed
head ${tssFile}

#2. Compute TSS enrichment
echo "-------- Compute per-base coverage around TSS"


sort -k1,1 -k2,2n ${tssFile} > ${tssFile/".bed"/".sorted.bed"}

bedtools coverage -a ${tssFile/".bed"/".sorted.bed"} -b ${bam} -d -sorted > ${TAIR}/${ID}_tss_depth.txt
awk -v w=${width} ' BEGIN { FS=OFS="\t" } { if ($5=="-") $6=(2*w)-$6+1 ; print $0 } ' ${TAIR}/${ID}_tss_depth.txt > ${TAIR}/${ID}_tss_depth.reoriented.txt

sort -n -k 6 ${TAIR}/${ID}_tss_depth.reoriented.txt > ${TAIR}/${ID}_tss_depth.sorted.txt

bedtools groupby -i ${TAIR}/${ID}_tss_depth.sorted.txt -g 6 -c 7 -o sum > ${TAIR}/${ID}_tss_depth_per_position.sorted.txt

norm_factor=`awk -v w=${width} -v f=${flanks} '{ if ($6<f || $6>(2*w-f)) sum+=$7 } END { print sum/(2*f) } ' ${TAIR}/${ID}_tss_depth.sorted.txt`
echo "Nf: " ${norm_factor}
awk -v w=${width} -v f=${flanks} '{ if ($1>f && $1<(2*w-f)) print $0 }' ${TAIR}/${ID}_tss_depth_per_position.sorted.txt | awk -v nf=${norm_factor} -v w=${width} 'BEGIN { OFS="\t" } { $1=$1-w ; $2=$2/nf ; print $0 }' > ${TAIR}/${ID}_tss_depth_per_position.normalized.txt
Rscript ${TAIR}/plot_tss_enrich.R -f ${TAIR}/${ID}_tss_depth_per_position.normalized.txt -w ${width} -o ${TAIR}  


# ---------------------------------------------------------------------------------------- #
# ------------------------------- Insert size distribution ------------------------------- #
# ---------------------------------------------------------------------------------------- #

echo "-------- Compute insert size distribution"
samtools view -f 3 -F 16 -L ${chrArabido} -s 0.25 ${bam} | awk ' function abs(v){ return v < 0 ? -v : v } { print abs($9) } ' | sort -g | uniq -c | sort -k2 -g > ${TAIR}/${ID}_TLEN_1-5.txt
Rscript ${TAIR}/plot_tlen.R -f ${TAIR}/${ID}_TLEN_1-5.txt -o ${TAIR}



# End of the script \\\\\\\\\\\\\\\\\\\\\\\\\\\\







