# Mapping des reads sur le génome

# construction d'un index à partir d'un génome de référence

workdir=~/mydatalocal/NGS_epigenomics/data/

indexdir=~/mydatalocal/NGS_epigenomics/processed_data/index/

mkdir -p $indexdir #creation fichier index

bowtie2-build -f ~/mydatalocal/NGS_epigenomics/data/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz ${indexdir}TAIR10
# bowtie 2 est un outil d'alignement de séquence.
# bowtie2-build construit un index pour l'alignement


gzip /home/rstudio/mydatalocal/NGS_epigenomics/processed_data/Trim/trimmed/SRR400047*


#for fq in ~/mydatalocal/NGS_epigenomics/processed_data/Trim/trimmed/*1_paired.*
# for each sample
  #do echo $fq
  #done
# check avec m'écho que l'on renvoie quelque chose de cohérent
for fq in ~/mydatalocal/NGS_epigenomics/processed_data/Trim/trimmed/*1_paired.*  
  do
  suffixe=${fq%%1_paired.fastq.gz} # enlever suffix
  prefixe2=${suffixe/"Trim/trimmed"/"mapping"} #remplace le suffixe
  #filed=processed_data/Trim/trimmed/${prefixe2}
  head ${suffixe}1_paired.fastq.gz
  echo bowtie2 -x ~/mydatalocal/NGS_epigenomics/processed_data/index/TAIR10 \
  -1 ${suffixe}1_paired.fastq.gz -2 ${suffixe}2_paired.fastq.gz\
  -U -1 ${suffixe}1_unpaired.fastq.gz -2 ${suffixe}2_unpaired.fastq.gz --threads 6\
  -X 2000  --very-sensitive "|" samtools sort -O BAM -o ${prefixe2}sorted.bam --threads 6 # le -x est le génome indexé
  #le -U est pour dire si il y a des données unpaired ici pas de -U
  # -X 2000
  done


# on réalise l'allignement des séquences
for fq in ~/mydatalocal/NGS_epigenomics/processed_data/Trim/trimmed/article/*1_paired.fastq  
  do
  #echo $fq
  suffixe=${fq%%1_paired.fastq} # enlever suffix
  prefixe2=${suffixe/"Trim/trimmed/article"/"mapping"} #remplace le suffixe
  #filed=processed_data/Trim/trimmed/${prefixe2}
  #zcat ${suffixe}1_paired.fastq.gz | head
  bowtie2 -x ~/mydatalocal/NGS_epigenomics/processed_data/index/TAIR10 \
  -1 ${suffixe}1_paired.fastq -2 ${suffixe}2_paired.fastq --threads 6\
  -X 2000  --very-sensitive | samtools sort -O BAM -o ${prefixe2}sorted.bam --threads 6 # le -x est le génome indexé
  #le -U est pour dire si il y a des données unpaired ici pas de -U
  # -X 2000
  done



#pour les données zipper
for fq in ~/mydatalocal/NGS_epigenomics/processed_data/Trim/trimmed/non_published/*1_paired.fastq.gz  
  do
  echo $fq
  suffixe=${fq%%1_paired.fastq.gz} # enlever suffix
  prefixe2=${suffixe/"Trim/trimmed/non_published"/"mapping"} #remplace le suffixe
  #filed=processed_data/Trim/trimmed/${prefixe2}
  #zcat ${suffixe}1_paired.fastq.gz | head
  bowtie2 -x ~/mydatalocal/NGS_epigenomics/processed_data/index/TAIR10 \
  -1 ${suffixe}1_paired.fastq.gz -2 ${suffixe}2_paired.fastq.gz --threads 6\
  -X 2000  --very-sensitive | samtools sort -O BAM -o ${prefixe2}sorted.bam --threads 6 # le -x est le génome indexé
  #le -U est pour dire si il y a des données unpaired ici pas de -U
  # -X 2000
  done
