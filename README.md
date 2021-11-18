# Contexte biologique

Etudier comment est programmer la différenciation des cellules dans la racine et s'il y a un épigénome spécifique dans les cellules souches (centre quiescent) et regarder comment cet état il change au cour de la différenciation dans le temps et dans l'espace.

Grosse difficulté d'étudier le centre quiescent (cellule très rare, "-' cellules"). Les premières papier de single cell sur les végétaux sont très récents. L'alternative était d'extraire le populations de cellules qui exprimaient un marqueur, par exemple avec du FACS.
Utilisation de la technique IMPACT ==> on fait exprimer à la plante une GFP sous contrôle d'un promoteur tissu spécifique du gène WOX5, seul promoteur qu'on connaît pour le ccentre quiescent. la GFP est enchassé dans l'enveloppe nucléaire. peptide biotine retient tous les GFP positifs, élution, on récupère les noyaux GFP+ puiis on séquence ici taqSeq.

Paek Calling = recherche de pique

Technique de plus en plus utilisées mais pas super simple à analyser.
outil utilisé MACS2 davantage pour le chipSeq (chromatideImmunoprécipitation Sequencing ==> anticorps anti histone par exemple)
et HMMRATAC spécialisé pour la taqSeq.

vendredi présentation sur la TaqSeq BIBLIO
présenter le projet, ce qu'on à fait et ce qu'on va faire et tout ça de manière compréhensible

taqseq single cell ==> casiment pas de signal par cellule ==> obligé de faire des groupes de cellules qui ont à peu près la même identité.

taq ==> transposase qui vient couper des morcaux de minimum de 38pb à cause de l'encombrement stérique.
tac-seq ==> avantage par rapport au RNA seq pour connaître quels gènes sont actifs.

remarque : si 2 pique sur le GC mean ==> possibilité de contamination

Le séquençage est en paire d'ends pour séquencer les deux bruns de l'ADN et être plus précis dans le séquençage.

FastQ exlication du code
Chaque caractère donne la qualité du nucléotide. Plus un nucléotide est de bonne qualité, plus on est certain de sa nature.

 @NB500892:406:H5F2WBGXG:1:11101:14655:1050 2:N:0:CGAGGCTG #ligne identifiant
 NTTCGGAACTGNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN #ligne séquence N= nucléotide
 +
 #AAAAEEEEEE############################## #ligne qualité


nucleosome 148 pb autour

les facteurs de transcriptions peuvent aussi géner l'atac-seq ==> footprint qu'il faut recouper avec du chipseq contre le facteur de transcriptnio ou avec du RNAseq pour savoir quels zones sont constemment active et les différencier des zones inactives.

fichier gtf
AT = Arabidopsis Thaliana

CDS = Coding Regions

wc = nombre de caractère
wc -l fichier = nombre de ligne du fichier
wc --help pour les autres astuces


dossier TAIR = format bed = définit les régions du génome (numéro chromosome, start région, stop région)

fastqc lancer

Remarque:
006 et 007 = stem cell
372, 378 & 380 = racine antière
Article = réplicats de racine antière


duplicate read nombre = pas ouf si trop nombreux

sequece quality tout au vert

transposon =>  biai sur les 15 premières bases par rapport à la séquence reconnu pour couper

%GC = 44 à 45
ici on est autour de 48

N content faible ==> toute la séquence est determinée

si adapter content rouge il faut les supprimer avec un logiciel particulier, ici tout est au vert.

haute complexité c'est bien car les reads ont des starting point différent et donc s'overlap et permet une meilleur roncstruction du génome




trimming ==> enlève les séquences de mauvaises qualités, avec haut N content et avec du A tailing ou cen genre de chose

les duplicats sont enlevés avec autre chose

pour l'atac-seq ==> adaptater sont nextera



80% de mapping == bon allignement
=> si inférieur comprendre pourquoi, rapport avec la teechnique ou contamination



# Traitement des données

## Importation des données

Utilisation de l'outil wget pour importer les données fastq non publiées à partir du serveur.

Utilisation de fastq-dump pour importer les données à partir des SRA (Sequence Read Archive) données dans l'article *Combining ATAC-seq with nuclei sorting for discovery of cis-regulatory regions in plant genomes*.

Les SRA sont données dans les liens suivants:
- https://www.ncbi.nlm.nih.gov/sra?term=SRX2000803
- https://www.ncbi.nlm.nih.gov/sra?term=SRX2000804


# Analyse des données


# Conclusion biologique