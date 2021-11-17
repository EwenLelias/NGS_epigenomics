# Contexte biologique

Etudier comment est programmer la différenciation des cellules dans la racine et s'il y a un épigénome spécifique dans les cellules souches (centre quiescent) et regarder comment cet état il change au cour de la différenciation dans le temps et dans l'espace.

Grosse difficulté d'étudier le centre quiescent (cellule très rare, "-' cellules"). Les premières papier de single cell sur les végétaux sont très récents. L'alternative était d'extraire le populations de cellules qui exprimaient un marqueur, par exemple avec du FACS.
Utilisation de la technique IMPACT ==> on fait exprimer à la plante une GFP sous contrôle d'un promoteur tissu spécifique du gène WOX5, seul promoteur qu'on connaît pour le ccentre quiescent. la GFP est enchassé dans l'enveloppe nucléaire. peptide biotine retient tous les GFP positifs, élution, on récupère les noyaux GFP+ puiis on séquence ici taqSeq.

Paek Calling = recherche de pique

Technique de plus en plus utilisées mais pas super simple à analyser.
outil utilisé MACS2 davantage pour le chipSeq (chromatideImmunoprécipitation Sequencing ==> anticorps anti histone par exemple)
et HMMRATAC spécialisé pour la taqSeq.

vendredi présentation sur la TaqSeq BIBLIO


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
wc --help pour les autres astuces


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