# Contexte biologique

La racine possède un pôle de quatre cellules quiescentes, le centre quiescent. Ces cellules souches ne se différencient pas et devraient posséder un épigénome différent du reste des cellules de la racine qui ont un programme de différenciation.

L'étude s'intéresse à découvrir si les cellules souches possèdent un épigénome spécfique et à savoir si cet épigénome varie au cours de la différentiaiton dans le temps et dans l'espace racinaire.

Il est très difficile d'étudier le centre quiescent puisqu'il n'est composé que de 3-4 cellules. Les premiers papiers de single-cell sur des végétaux sont très récents.

L'extraction des noyaux cellulaires d'intérêts est réalisée grâce à la méthode [INTACT](https://pubmed.ncbi.nlm.nih.gov/21212783/). En particulier, concernant les cellules souches, une protéine de fusion GFP-biotine, sous contrôle du promoteur WOX5, est enchassée dans l'enveloppe du noyau. Les noyaux GFP+ sont récupérés grâce à l'adsoprtion des noyaux par des billes streptavidin. Les noyaux sont ensuites séquencés.

Le séquençage utilisé, avant nos analyses, est l'[ATAC-seq](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4374986/). ATAC signifie Assay for Transposase Accessible Chromatin. Comme le nom l'indique, des transposases vont venir couper le génome dans les régions qui leurs sont accessibles. Les transposases couent des fragments de minimum 38pb.

Idéalement, cette méthode permet de connaître l'ensemble des régions accessible de la chromatine et de mapper les régions bloquer par des nucléosomes (qui encombrent 148 pb) ou des facteurs de transcriptions. Sur du single-cell l'ATAC-seq est très compliqué en raison de l'absence de signal suffisant. Des pools de cellules de même identités, récupérés par INTACT, sont séquencées en même temps.

A l'issue du mapping avec l'ATAC-seq, on obtient un footprint du génome. Cette méthode est complémentaire du ChIp-seq et du RNA-seq qui permettent de faire le lien entre zone accessible et zone super active.

**Remarque:** Le séquençage est en paire d'ends pour séquencer les deux bruns de l'ADN et être plus précis dans le séquençage.




# Traitement des données de séquençage



## Récupération des données - Get_Data.sh

Utilisation de l'outil wget pour importer les données fastq de séquençage, racines entières et centres quiescents, non publiées à partir du serveur.

Utilisation de fastq-dump pour importer les données de séquençages racines entières à partir des SRA (Sequence Read Archive) données dans l'article *Combining ATAC-seq with nuclei sorting for discovery of cis-regulatory regions in plant genomes*.

Les SRA sont données dans les liens suivants:
- [SRX2000803](https://www.ncbi.nlm.nih.gov/sra?term=SRX2000803)
- [SRX2000804](https://www.ncbi.nlm.nih.gov/sra?term=SRX2000804)

Le génome d'Arabidopsis Thaliana est aussi récupéré à partir d'une [base de donnée](http://ftp.ebi.ac.uk/ensemblgenomes). Le génome est sous format TAIR, un format bed qui définit les région du génome (numéro du chromosome, start région, stop région)

**Remarque sur les échantillons:**
*Echantillon non publiés:*
006 et 007 et 372 = stem cells
374, 378 & 380 = racines antières
*Echanitllon de l'article:* réplicats de racines antières



## Analyse de la qualité du séquençage - Quality_Analysis.sh

Les séquences se présentent sous un format FastQ:

@NB500892:406:H5F2WBGXG:1:11101:14655:1050 2:N:0:CGAGGCTG **ligne identifiant**
 NTTCGGAACTGNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN **#ligne séquence N= nucléotide**
 +
 #AAAAEEEEEE############################## **ligne qualité**

Chaque caractère donne la qualité du nucléotide. Plus un nucléotide est de bonne qualité, plus on est certain de sa nature. Un # signifie une piètre qualité. Ils sont associés au N, nucléotide dont on ne connaît pas la nature.

Ces séquences sont ensuite analysées à l'aide [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) puis [multiqc](https://multiqc.info/).

Multiqc renvoie un certain nombre de panel qui doivent être aux verts pour un read de bonne qualité.

Parmis ces panels, on a notamment:

- le GC-content. Deux pics dans le GC-content signle la possibilité d'une contamination.
- le nombre de reads dupliqués. Il faut éviter qu'il soit trop nombreux.
- le N-content qui doit être faible si toute la séquence est bien déterminée.

**Remarque:** on peut définir la complexité d'un séquençage en fonction du nombre de starting point des reads. Plus elle est élevée, plus les reads vont avoir des starting points différents et onc plus il y aura d'overlap, ce qui permettra une meilleur reconstruction du génome.

Reamrque:
%GC content global AT = 36%
%GC content gene AT = 44-45%
%GC content measured = 48%



## Ellagage des données de séquençage - Trimming.sh

Lors du trimming, les séquences de mauvaises qualités, e.g. avec un N-content élevé, avec du A-tailing, etc., ainsi que les duplicats et les séquences d'adaptateurs sont enlevées.
**Remarque:** pour l'ATAC-seq, les adaptateurs sont nextera.

La fonction utilisée pour le trimming est [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic).
On trimme tous les échantillons. Seul un membre des deux paires d'ends est lu car la fonction trimming parcourt les deux bruns complémentaires en même temps.

Les échantillons trimmés sont ensuite analysés avec fastqc et multiqc. Les échantillons trimmés sont de meilleurs qualités.



## Alignement des reads sur le génome - Mapping.sh

Le mapping consiste à placer les reads sur un génome de référence.

L'outil d'alignement de séquence utilisé est [bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml). Plus d'informations peuvent aussi être trouvé [ici](http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml#command-line-1).

D'abord, un index est construit à partir du génome de référence avec la fonction bowtie2-build.

Puis l'alignement à proprement parlé est réalisé avec la fonction bowtie2.

**Remarque:** un alignement est considéré bon à partir de plus de 80% de mapping. Si le mapping est inférieur, il s'agit de comprendre pourquoi, si c'est en rapport avec la technique de séquençage, ou avec une potentielle contamination.
**Remarque:** les alignements obtenus sont supérieurs à 90%.


## Sélection des reads du mapping - filtering.sh

Après le mapping, on souhaite enlever tous les reads qui ne font pas parties des 10% bien mappés.

Dans un premier temps, on utilise la fonction [grep](https://www.quennec.fr/trucs-astuces/syst%C3%A8mes/gnulinux/programmation-shell-sous-gnulinux/les-commandes-filtres/visualisation-de-donn%C3%A9es/filtrage-de-lignes-grep) qui va répertorier les régions correspondant aux génomes mitochondriaux ou chloroplastiques. Ces régions sont ensuite supprimées.

Puis, avec la fonction [samtools](http://samtools.sourceforge.net/), on enlève les reads dupliqués, les unpaired, les reads de mauvaise qualité, les reads non mappés et les régions blacklistés.



## Quality
















# Analyse des données

Peak Calling = recherche de pique

Technique de plus en plus utilisées mais pas super simple à analyser.
outil utilisé MACS2 davantage pour le chipSeq (chromatideImmunoprécipitation Sequencing ==> anticorps anti histone par exemple)
et HMMRATAC spécialisé pour la taqSeq.


# Conclusion Biologique


# Perspective























#brouillon


#Paek Calling = recherche de pique

#Technique de plus en plus utilisées mais pas super simple à analyser.
#outil utilisé MACS2 davantage pour le chipSeq (chromatideImmunoprécipitation Sequencing ==> anticorps anti histone par exemple)
#et HMMRATAC spécialisé pour la taqSeq.

#vendredi présentation sur la TaqSeq BIBLIO
#présenter le projet, ce qu'on à fait et ce qu'on va faire et tout ça de manière compréhensible

#atac seq single cell ==> casiment pas de signal par cellule ==> obligé de faire des groupes de cellules qui ont à peu près la même identité.

#atac ==> transposase qui vient couper des morcaux de minimum de 38pb à cause de l'encombrement stérique.
#tac-seq ==> avantage par rapport au RNA seq pour connaître quels gènes sont actifs.

#remarque : si 2 pique sur le GC mean ==> possibilité de contamination

#Le séquençage est en paire d'ends pour séquencer les deux bruns de l'ADN et être plus précis dans le séquençage.

#FastQ exlication du code
#Chaque caractère donne la qualité du nucléotide. Plus un nucléotide est de bonne qualité, plus on est certain de sa nature.

# @NB500892:406:H5F2WBGXG:1:11101:14655:1050 2:N:0:CGAGGCTG #ligne identifiant
# NTTCGGAACTGNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN #ligne séquence N= nucléotide
# +
# #AAAAEEEEEE############################## #ligne qualité


#nucleosome 148 pb autour

#les facteurs de transcriptions peuvent aussi géner l'atac-seq ==> footprint qu'il faut recouper avec du chipseq contre le facteur de transcriptnio ou avec du RNAseq pour savoir quels zones sont constemment active et les différencier des zones inactives.

fichier gtf
AT = Arabidopsis Thaliana

CDS = Coding Regions

wc = nombre de caractère
wc -l fichier = nombre de ligne du fichier
wc --help pour les autres astuces


#dossier TAIR = format bed = définit les régions du génome (numéro chromosome, start région, stop région)

#fastqc lancer

#Remarque:
#006 et 007 et 372 = stem cell
#374, 378 & 380 = racine antière
#Article = réplicats de racine antière


#duplicate read nombre = pas ouf si trop nombreux

#sequece quality tout au vert

#transposon =>  biai sur les 15 premières bases par rapport à la séquence reconnu pour couper

#%GC = 44 à 45
#ici on est autour de 48

#N content faible ==> toute la séquence est determinée

#si adapter content rouge il faut les supprimer avec un logiciel particulier, ici tout est au vert.

#haute complexité c'est bien car les reads ont des starting point différent et donc s'overlap et permet une meilleur roncstruction du génome




#trimming ==> enlève les séquences de mauvaises qualités, avec haut N content et avec du A tailing ou cen genre de chose

#les duplicats sont enlevés avec autre chose

#pour l'atac-seq ==> adaptater sont nextera



#80% de mapping == bon allignement
#=> si inférieur comprendre pourquoi, rapport avec la teechnique ou contamination