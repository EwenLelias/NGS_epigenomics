
cd ~/mydatalocal/NGS-epigenomics/data/

fastqc SRR400047* # regarde la qualité des séquences d'articles

fastqc 20* #regarde la qualité des séquences non publiées

mv *fastqc.* ~/mydatalocal/NGS_epigenomics/processed_data/fastqc

cd ~/mydatalocal/NGS_epigenomics/processed_data/fastqc

multiqc . #analyse toutes les données

mv multiqc* ~/mydatalocal/NGS_epigenomics/rocessed_data/multiqc



