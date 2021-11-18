# construction d'un index à partir d'un génome de référence

workdir=~/mydatalocal/NGS_epigenomics/data/

indexdir=~/mydatalocal/NGS_epigenomics/processed_data/index

mkdir -p $indexdir #creation dossier index

bowtie2-build -f ~/mydatalocal/NGS-epigenomics/data/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz TAIR10


