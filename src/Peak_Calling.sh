DIR=~/mydatalocal/NGS_epigenomics/processed_data/duplicate
outDIR=~/mydatalocal/NGS_epigenomics/processed_data/Peak

#remarque faire le modèle pour l'atac sec c'est pas util, seulement pour chip seq
# il n'y a pas de distribution bimodale pour la taqseq

mkdir -p ${outDIR}

cd $outDIR

#exsize = taille du fragment
#shift permet de recentrer les sites de coupures en shiftant la valeur du centre
#du read vers les côtés ou s'est effectivement passé la coupure. Souvent, on prend
#exsize = 2 * shift

bamsuffix=sortedmarked_duplicate_filtered.bam

for f in ${DIR}/*_duplicate_filtered.bam

do
  idbase="$(basename -- $f)"
  ID="${idbase//$bamsuffix/}"
#  echo $ID
  #  macs2 callpeak -t $f --outDIR ${outDIR}/${idbase} --nomodel --broad
#  macs2 callpeak -t {$f} -n {$idbase} --outdir {$outDIR} -f {BAM}\
 # -g hs -q 0.01 --nomodel --shift -75 --extsize 150 --keep-dup all -B --SPMR
#  macs2 callpeak -t ${f} -n ${ID} --outdir ${outDIR} \
#  -g 10e7 -q 0.01 --nomodel --shift -25 --extsize 50 --keep-dup all -B --SPMR --broad
  macs2 callpeak -f "BAM" -t ${f} -n ${ID} --outdir ${outDIR}\
  -q 0.01 --nomodel --shift -25 --extsize 50 --keep-dup "all" -B --broad --broad-cutoff 0.01 -g 10E7
#Rscript ${outDIR}/NA_model.r
done

cd ${DIR}
for f in ${DIR}/*filtered.bam
do
  samtools index $f
done

#https://bedtools.readthedocs.io/en/latest/content/tools/closest.html



#BAM regarder les extrêmités 5' des 

#tille génome arabidopisis  10e7


