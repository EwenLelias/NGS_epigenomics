# Contexte biologique

Le séquençage est en paire d'ends pour séquencer les deux bruns de l'ADN et être plus précis dans le séquençage.

FastQ exlication du code
Chaque caractère donne la qualité du nucléotide. Plus un nucléotide est de bonne qualité, plus on est certain de sa nature.

 @NB500892:406:H5F2WBGXG:1:11101:14655:1050 2:N:0:CGAGGCTG #ligne identifiant
 NTTCGGAACTGNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN #ligne séquence N= nucléotide
 +
 #AAAAEEEEEE############################## #ligne qualité



fichier gtf
AT = Arabidopsis Thaliana

CDS = Coding Regions

wc = nombre de caractère
wc -l fichier = nombre de ligne du fichier
wv --help pour les autres astuces


dossier TAIR = format bed = définit les régions du génome (numéro chromosome, start région, stop région)

# Traitement des données

## Importation des données

Utilisation de l'outil wget pour importer les données fastq non publiées à partir du serveur.

Utilisation de fastq-dump pour importer les données à partir des SRA (Sequence Read Archive) données dans l'article *Combining ATAC-seq with nuclei sorting for discovery of cis-regulatory regions in plant genomes*.

Les SRA sont données dans les liens suivants:
- https://www.ncbi.nlm.nih.gov/sra?term=SRX2000803
- https://www.ncbi.nlm.nih.gov/sra?term=SRX2000804


# Analyse des données


# Conclusion biologique