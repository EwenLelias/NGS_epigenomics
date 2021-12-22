#Recherche de piques de reads sur le génome

DIR=~/mydatalocal/NGS_epigenomics/processed_data/duplicate
outDIR=~/mydatalocal/NGS_epigenomics/processed_data/Peak

#remarque faire le modèle pour l'atac sec c'est pas util, seulement pour chip seq
# il n'y a pas de distribution bimodale pour l'a taq'atac-seq

mkdir -p ${outDIR}

cd $outDIR



bamsuffix=sortedmarked_duplicate_filtered.bam

for f in ${DIR}/*_duplicate_filtered.bam

do
  idbase="$(basename -- $f)"
  ID="${idbase//$bamsuffix/}"
#  echo $ID
  macs2 callpeak -f "BAM" -t ${f} -n ${ID} --outdir ${outDIR}\
  -q 0.01 --nomodel --shift -25 --extsize 50 --keep-dup "all" -B --broad --broad-cutoff 0.01 -g 10E7
#Rscript ${outDIR}/NA_model.r
done

#BAM regarder les extrêmités 5' des 

#extsize = taille du fragment = 2 * shift
#shift permet de recentrer les sites de coupures en shiftant la valeur du centre
#du read vers les côtés ou s'est effectivement passé la coupure. Souvent, on prend

#g = taille génome arabidopisis  10e7



cd ${DIR}
for f in ${DIR}/*filtered.bam
do
  samtools index $f
done
#on indexe les régions ou se situe les piques
#https://bedtools.readthedocs.io/en/latest/content/tools/closest.html





