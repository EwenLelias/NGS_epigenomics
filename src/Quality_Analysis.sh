
cd ~/mydatalocal/NGS-epigenomics/data/ #on se place dans le folder data

fastqc SRR400047* # regarde la qualité des séquences d'articles

fastqc 20* #regarde la qualité des séquences non publiées

mv *fastqc.* ~/mydatalocal/NGS_epigenomics/processed_data/fastqc
#change de folder les données issues de fastqc

cd ~/mydatalocal/NGS_epigenomics/processed_data/fastqc
#on se place dans le folder fastqc

multiqc . #analyse toutes les données

mv multiqc* ~/mydatalocal/NGS_epigenomics/processed_data/multiqc
#change de folder les données issues de multiqc



