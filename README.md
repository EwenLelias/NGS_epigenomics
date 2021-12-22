# Next-Generation Sequencing Practical Work - Chromatin State of the Organizing Center of *A. thaliana* Root Meristem

Ewen Lelias


## Contexte biologique

Lors du développement de la racine d'Arabidopsis Thaliana, il y a une différentiation spatiale et temporelle de l'expression génétique des cellules.

La racine possède un pôle de deux à cinq cellules quiescentes, le centre quiescent. Ces cellules souches ne se différencient pas et devraient posséder un épigénome différent du reste des cellules de la racine qui ont un programme de différenciation.

L'étude s'intéresse à découvrir si les cellules souches possèdent un épigénome spécfique et à savoir si cet épigénome varie au cours de la différentiation dans le temps et dans l'espace racinaire. Notamment, l'intérêt est porté sur l'accessibilité des régions régulatrices.

Il est très difficile d'étudier le centre quiescent puisqu'il n'est composé que de 3-4 cellules. Les premiers papiers de single-cell sur des végétaux sont très récents.

L'extraction des noyaux cellulaires d'intérêts est réalisée grâce à la méthode [INTACT](https://pubmed.ncbi.nlm.nih.gov/21212783/). En particulier, concernant les cellules souches, une protéine de fusion GFP-biotine, sous contrôle du promoteur WOX5, est enchassée dans l'enveloppe du noyau. Les noyaux GFP+ sont récupérés grâce à l'adsoprtion des noyaux par des billes streptavidin. Les noyaux sont ensuites séquencés.

Le séquençage utilisé, avant nos analyses, est l'[ATAC-seq](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4374986/). ATAC signifie Assay for Transposase Accessible Chromatin. Comme le nom l'indique, des transposases vont venir couper le génome dans les régions qui leurs sont accessibles. Les transposases couent des fragments de minimum 38pb.

Idéalement, cette méthode permet de connaître l'ensemble des régions accessible de la chromatine et de mapper les régions bloquer par des nucléosomes (qui encombrent 148 pb) ou des facteurs de transcriptions. Sur du single-cell l'ATAC-seq est très compliqué en raison de l'absence de signal suffisant. Des pools de cellules de même identités, récupérés par INTACT, sont séquencées en même temps.

A l'issue du mapping avec l'ATAC-seq, on obtient un footprint du génome. Cette méthode est complémentaire du ChIp-seq et du RNA-seq qui permettent de faire le lien entre zone accessible et zone super active.

**Remarque:** Le séquençage est en paire d'ends pour séquencer les deux bruns de l'ADN et être plus précis dans le séquençage.




## Traitement des données de séquençage



### Récupération des données - Get_Data.sh

Utilisation de l'outil wget pour importer les données fastq de séquençage, racines entières et centres quiescents, non publiées à partir du serveur.

Utilisation de fastq-dump pour importer les données de séquençages racines entières à partir des SRA (Sequence Read Archive) données dans l'article [Combining ATAC-seq with nuclei sorting for discovery of cis-regulatory regions in plant genomes](https://academic.oup.com/nar/article/45/6/e41/2605943).
Les SRA sont données dans les liens suivants:
- [SRX2000803](https://www.ncbi.nlm.nih.gov/sra?term=SRX2000803)
- [SRX2000804](https://www.ncbi.nlm.nih.gov/sra?term=SRX2000804)

Le génome d'Arabidopsis Thaliana est aussi récupéré à partir d'une [base de donnée](https://plants.ensembl.org/info/data/ftp/index.html). Le génome est sous format TAIR, un format bed qui définit les région du génome (numéro du chromosome, start région, stop région)

**Remarque sur les échantillons:**  
*Echantillon non publiés:*  
006 et 007 et 372 = stem cells  
374, 378 & 380 = racines antières  
*Echanitllon de l'article:* réplicats de racines antières



### Analyse de la qualité du séquençage - Quality_Analysis.sh

Les séquences se présentent sous un format FastQ:

@NB500892:406:H5F2WBGXG:1:11101:14655:1050 2:N:0:CGAGGCTG **#ligne identifiant**  
 NTTCGGAACTGNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN **#ligne séquence N= nucléotide**  
  +  
 #AAAAEEEEEE############################## **#ligne qualité**

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



### Ellagage des données de séquençage - Trimming.sh

Lors du trimming, les séquences de mauvaises qualités, e.g. avec un N-content élevé, avec du A-tailing, etc., ainsi que les duplicats et les séquences d'adaptateurs sont enlevées.  
**Remarque:** pour l'ATAC-seq, les adaptateurs sont nextera.

La fonction utilisée pour le trimming est [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic).
On trimme tous les échantillons. Seul un membre des deux paires d'ends est lu car la fonction trimming parcourt les deux bruns complémentaires en même temps.

Les échantillons trimmés sont ensuite analysés avec fastqc et multiqc. Les échantillons trimmés sont de meilleurs qualités.



### Alignement des reads sur le génome - Mapping.sh

Le mapping consiste à placer les reads sur un génome de référence.

L'outil d'alignement de séquence utilisé est [bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml). Plus d'informations peuvent aussi être trouvé [ici](http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml#command-line-1).

D'abord, un index est construit à partir du génome de référence avec la fonction bowtie2-build.

Puis l'alignement à proprement parlé est réalisé avec la fonction bowtie2.

**Remarque:** un alignement est considéré bon à partir de plus de 80% de mapping. Si le mapping est inférieur, il s'agit de comprendre pourquoi, si c'est en rapport avec la technique de séquençage, ou avec une potentielle contamination.  
**Remarque:** les alignements obtenus sont supérieurs à 90%.



### Sélection des reads du mapping - filtering.sh

Après le mapping, on souhaite enlever tous les reads qui ne font pas parties des 10% bien mappés.

Dans un premier temps, on utilise la fonction [grep](https://www.quennec.fr/trucs-astuces/syst%C3%A8mes/gnulinux/programmation-shell-sous-gnulinux/les-commandes-filtres/visualisation-de-donn%C3%A9es/filtrage-de-lignes-grep) qui va répertorier les régions correspondant aux génomes mitochondriaux ou chloroplastiques. Ces régions sont ensuite supprimées.

Puis, avec la fonction [samtools](http://samtools.sourceforge.net/), on enlève les reads dupliqués, les unpaired, les reads de mauvaise qualité, les reads non mappés et les régions blacklistés.



### Mesure de la qualité de l'ATAC-seq - quality.sh

A partir d'un génome d'Arabidopsis Thaliana complètement annoté (chromosome, gene/transcript/transposon, coordonées, gene_id, role_du_gene), l'étude est réalisé sur les fragments mappés et leurs tailles, distribution et position par rapport aux TSS (Transcription starting site).

On utilise les fonctions [bedtools](https://bedtools.readthedocs.io/en/latest/).

**Concernant les TSS:**
Dans un premier temps, à l'aide de bedtools intersect et de grep, on récupère les TSS sur le génome.
Puis, dans un second temps, à l'aide de bedtools coverage on regarde si les reads match les TSS.
Un enrichissement en TSS est attendu dans les régions sans nucléosome.

**Concernant taille, distribution et périodicité des fragments:**
On utilise samtools view our calculer la longueur des reads.
La taille, la distirbution et la la périodicité des fragments dépend directement des nucléosomes.




## Analyse des données

### Recherche des piques de reads sur le génome - Peak_Calling.sh

[Peak Calling](https://hbctraining.github.io/Intro-to-ChIPseq/lessons/05_peak_calling_macs.html) signifie recherche de pique. Cette étape correspond à l'identification des régions du génomes très enrichies en reads alignés.

Dans le cas général, l'outil [MACS2](https://github.com/macs3-project/MACS) est utilisé pour le peak calling. Il a été développé pour le ChIp-seq. L'algorithme MACS indique les régions du génome enrichies en read (du ChIp-seq). C'est l'outil utilisé pour notre peak calling.


Dans le cas du [peak calling pour l'ATAC-seq](https://github.com/macs3-project/MACS/discussions/435), un outil sécialement dévelopé est [HMMRATAC](https://github.com/LiuLabUB/HMMRATAC).


### Recherche des gènes les plus proches des piques - bedtools_closest.sh

Dans un premier temps, on reprend le fichier gtf (avec coordonnées, noms et orientations des gènes) que l'on filtre et trie pour ne garder que les **gènes** du **noyaux**.

Puis vient la recherche du positionnement des piques dans ce gènome épuré à l'aide de l'outil [bedtools closest](https://bedtools.readthedocs.io/en/latest/content/tools/closest.html).

bedtools closest permet de connaître le plus proche gène (TSS) qui n'est pas overlapant avec un pique de reads. Cela peut donner une idée des gènes et régions régulatrices qui sont accessibles aux facteurs de transcriptions et polymerases pour l'expression du gène. 

Puis l'utilisation de bedtools intersect permet de sélectionner les gènes uniquement exprimés par les cellules quiescentes et donc de s'intéresser aux gènes qui donnent potentiellement leur caractères quiescents et cellules souches à ce petit pool de 2-5 cellules.



## Conclusion Biologique

A l'issue de l'analyse informatique, on obtient une sélection de gènes. Ces gènes sont caractérisés pour être proche des régions qui ne sont accessibles que dans le génome des cellules du centre quiescent d'*A. thaliana*.

Cette sélection peut être analysé avec l'outil [Integrative Genomic Viewer (IGV)](https://software.broadinstitute.org/software/igv/). Cette outil permet de bien visualiser les régions accessibles et de regarder l'orientation des gènes et la position des TSS par rapport aux piques.

Un autre outil très utile est [The Gene Ontology Ressource](http://geneontology.org/) qui permet de connaître la fonction des gènes de la sélection. Notamment, on peut voir si certaines fonction particulières se dégagent de la sélection.  
**Remarque:** L'un des gènes de la selection est impliqué dans la répression de la différentiation cellulaire.




##  Perspective

L'ATAC-seq est une méthode exhaustive pour l'analyse de l'accessibilité du génome et donc de l'épigénome.  
Cependant, l'accessibilité et l'expression des gènes sont deux choses différentes. De plus, la nature des facteurs de transcriptions positionés sur le génome n'est pas connu grçace à cette méthode. L'utilisation de méthodes complémentaires comme le [RNA-seq](https://pubmed.ncbi.nlm.nih.gov/30952685/)(séquençage des ARNs) et le [ChIp-seq](https://pubmed.ncbi.nlm.nih.gov/32240773/)(chromatideImmunoprécipitation Sequencing qui utilise des anticorps anti-histone par exemple) respectivement permettrait une analyse plus détaillée de l'épigénome, de son expression et de ce qui rend les cellules quiescentes uniques.  
Une autre méthode intéressante et prometteuse est le [SNARE-seq](https://www.nature.com/articles/s41587-019-0290-0) qui allie les avantages du RNA-seq et de l'ATAC-seq au niveau single-cell.


