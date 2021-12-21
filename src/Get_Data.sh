cd ~/mydatalocal/NGS_epigenomics/data/
#on se place dans le fichier data à l'aide de cd

wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2019_006_S6_R1.fastq.gz
#récupérer le fichier 2019_006_S6_R1.fastq.gz et le mettre dans data

wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2020_378_S8_R1.fastq.gz
#récupérer le fichier 2020_378_S8_R1.fastq.gz et le mettre dans data

wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2019_006_S6_R2.fastq.gz
#récupérer le fichier 2019_006_S6_R2.fastq.gz et le mettre dans data

wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2020_378_S8_R2.fastq.gz
#récupérer le fichier 2020_378_S8_R2.fastq.gz et le mettre dans data

fastq-dump -F --split-files SRR4000472 #numéro SRA
# récupérer le fichier de l'article et le mettre dans data

fastq-dump -F --split-files SRR4000473 #numéro SRA
# récupérer le fichier de l'article et le mettre dans data

wget http://ftp.ebi.ac.uk/ensemblgenomes/pub/release-51/plants/gtf/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.51.gtf.gz
#infromation about Arabidopsis genome; récupérer le fichier et le mettre dans data

wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Supporting_files/TAIR10_selectedRegions.bed
#additional bed file which specify blacklisted genomic regions; récupérer le fichier et le mettre dans data

gunzip -d Arabidopsis_thaliana.TAIR10.51.gtf.gz # unzippe le dossier zippé (gz)

