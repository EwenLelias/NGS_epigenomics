#!/bin/bash
#
# Compute basic quality metrics for ATAC-seq data
# 


# >>> change the value of the following variables

# General variables
workingDir=/home/rstudio/mydatalocal/Arabidocontratac
scriptDir=/home/rstudio/mydatalocal/Arabidocontratac/ATAC_QC
outputDir=${workingDir}/ATAC_QC_2

ID=2019_006_S6 # sample ID
bam_suffix=.1mis.noDup.f3F1024.blacklisted.sorted.bam


gtf=${workingDir}/TAIR10/Arabidopsis_thaliana.TAIR10.51.gtf
selected_regions=${workingDir}/TAIR10/TAIR10_selectedRegions.bed
genome=${workingDir}/TAIR10/TAIR10_ChrLen.txt

# Variables for TSS enrichment
width=1000
flanks=100

# Variables for insert size distribution
chrArabido=${workingDir}/TAIR10/TAIR10_ChrLen.bed
grep -v -E "Mt|Pt" ${chrArabido} > ${workingDir}/TAIR10/TAIR10_ChrLen_1-5.bed
chrArabido=${workingDir}/TAIR10/TAIR10_ChrLen_1-5.bed



#////////////////////// Start of the script

mkdir -p ${outputDir}

bam=${workingDir}/Mapping/${ID}${bam_suffix}
samtools view ${bam} | head 



# ------------------------------------------------------------------------------------------------------------ #
# --------------------------- Compute TSS enrichment score based on TSS annotation --------------------------- #
# ------------------------------------------------------------------------------------------------------------ #

#1. Define genomic regions of interest
echo "-------------------------- Define genomic regions of interest"
grep -v "^[MtPt]" ${gtf} | awk '{ if ($3=="gene") print $0 }'  |\
grep "protein_coding" |\
awk ' BEGIN { FS=OFS="\t" } { split($9,a,";") ; match(a[1], /AT[0-9]G[0-9]+/) ; id=substr(a[1],RSTART,RLENGTH) ; if ($7=="+") print $1,$4,$4,id,$7 ; else print $1,$5,$5,id,$7 } ' |\
uniq | bedtools slop -i stdin -g ${genome} -b ${width} > ${outputDir}/tss_${width}.bed

bedtools intersect -u -a ${outputDir}/tss_${width}.bed -b ${selected_regions} > ${outputDir}/tmp.tss && mv ${outputDir}/tmp.tss ${outputDir}/tss_${width}.bed
echo `cat ${outputDir}/tss_${width}.bed | wc -l` "roi defined from" ${gtf}

tssFile=${outputDir}/tss_${width}.bed
head ${tssFile}


#2. Compute TSS enrichment
echo "-------- Compute per-base coverage around TSS"

bedtools coverage -a ${tssFile} -b ${bam} -d > ${outputDir}/${ID}_tss_depth.txt
awk -v w=${width} ' BEGIN { FS=OFS="\t" } { if ($5=="-") $6=(2*w)-$6+1 ; print $0 } ' ${outputDir}/${ID}_tss_depth.txt > ${outputDir}/${ID}_tss_depth.reoriented.txt

sort -n -k 6 ${outputDir}/${ID}_tss_depth.reoriented.txt > ${outputDir}/${ID}_tss_depth.sorted.txt

bedtools groupby -i ${outputDir}/${ID}_tss_depth.sorted.txt -g 6 -c 7 -o sum > ${outputDir}/${ID}_tss_depth_per_position.sorted.txt

norm_factor=`awk -v w=${width} -v f=${flanks} '{ if ($6<f || $6>(2*w-f)) sum+=$7 } END { print sum/(2*f) } ' ${outputDir}/${ID}_tss_depth.sorted.txt`
echo "Nf: " ${norm_factor}
awk -v w=${width} -v f=${flanks} '{ if ($1>f && $1<(2*w-f)) print $0 }' ${outputDir}/${ID}_tss_depth_per_position.sorted.txt | awk -v nf=${norm_factor} -v w=${width} 'BEGIN { OFS="\t" } { $1=$1-w ; $2=$2/nf ; print $0 }' > ${outputDir}/${ID}_tss_depth_per_position.normalized.txt
Rscript ${scriptDir}/plot_tss_enrich.R -f ${outputDir}/${ID}_tss_depth_per_position.normalized.txt -w ${width} -o ${outputDir}  




# ---------------------------------------------------------------------------------------- #
# ------------------------------- Insert size distribution ------------------------------- #
# ---------------------------------------------------------------------------------------- #

echo "-------- Compute insert size distribution"
samtools view -f 3 -F 16 -L ${chrArabido} -s 0.25 ${bam} | awk ' function abs(v){ return v < 0 ? -v : v } { print abs($9) } ' | sort -g | uniq -c | sort -k2 -g > ${outputDir}/${ID}_TLEN_1-5.txt
Rscript ${scriptDir}/plot_tlen.R -f ${outputDir}/${ID}_TLEN_1-5.txt -o ${outputDir}



# End of the script \\\\\\\\\\\\\\\\\\\\\\\\\\\\