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

ID=2019_006_S6 # sample ID
bam_suffix=.1mis.noDup.f3F1024.blacklisted.sorted.bam

mkdir -p ${TAIR}

bam=${TAIR}/Mapping/${ID}${bam_suffix}
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
echo `cat ${tair}/tss_${width}.bed | wc -l` "roi defined from" ${gtf}

