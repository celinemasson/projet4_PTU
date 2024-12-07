# Journal de bord (projet4)

## 20/10 :
* **Mise en place du GitHub** : *(Céline)*  
    - Lien : [GitHub - projet4_PTU](https://github.com/celinemasson/projet4_PTU)

## 23/10 :
* **Création des environnements Conda** :  
  * **flye_env** : *(Céline)*  
    - Chemin : `/data/projet4/conda/masson/flye_env`
    - Packages :  
      - flye (version 2.8.1)  
      - filtlong  

  * **smartdenovo** : *(Adeline)*  
    - Chemin : `/data/projet4/conda/gagnon/smartdenovo`
    - Package : smartdenovo (version 1.0.0)

* **Organisation des dossiers** : *(Adeline)*  
  - Création des fichiers markdown :  
    - README  
    - Lab_journal  
  - Création de nouveaux dossiers :  
    - `code` : Contient les scripts  
    - `data` : Contient les données brutes et produites  
      - `raw` : Données brutes des Long/Shortreads  
      - `filtlong` : Données output de filtlong  
    - `conda` : Contient les environnements Conda  

* **Lancement d'un test Filtlong** : *(Adeline et Céline)*  
  - **Préparation des données test** :  
    - Extraction des 1000 premières séquences du fichier fasta de la levure 7890 (Tequila)  
    - Compression du fichier  
  - **Test de Filtlong sur les données test** : *(Céline)*  

**Commentaire** :  
Flye et Smartdenovo seront utilisés pour faire des assemblages de génome à partir des séquences  
LongReads. Filtlong sera utilisé pour filtrer les données (réduire la profondeur).

## 25/10 : *(Adeline)*  
* **Ajout du `.gitignore`** :  
  - Objectif : Empêcher le transfert des fichiers trop lourds sur GitHub. Les fichiers listés   
  dans le `.gitignore` ne seront pas pris en compte lors de la sauvegarde vers le GitHub.
  
* **Fusion des environnements Flye et Smartdenovo** :  
  - L'environnement Conda unique est désormais `/data/projet4/conda/masson/flye_env`

## 28/10 :  

* **Création d'un nouvel environnement pour Nanostat** : *(Adeline)*  
  - Lieu : `/data/projet4/conda/gagnon/nanostat_env`  
  - Packages :  
    - nanostat (version 1.4.0)  
    - R (version 4.4)  

* **Utilisation de Nanostat pour extraire les métriques des séquences** :  
  - Les métriques extraites incluent des données comme le N50 et les longueurs moyennes des   
  séquences pour les trois souches.  
  - **Fichiers Nanostat** :  
    - **Céline** : Fichiers au format `.txt`  
    - **Adeline** : Fichiers au format `.tsv`  
  - Les fichiers Nanostat se trouvent dans le répertoire `./data/resume_reads/`  

* **Calcul de la profondeur des séquences** : *(Céline)*  
  - Formule utilisée :  
    - Profondeur = Nombre total de bases / Taille du génome (13Mb)
  - Résultats :  
    - **Profondeur de la souche 7890 (Tequila)** = 214 278 043 / 13 000 000 = 16.4829  
    - **Profondeur de la souche 7895 (Beer)** = 332 449 493 / 13 000 000 = 25.5730  
    - **Profondeur de la souche 8039 (Wine)** = 386 573 797 / 13 000 000 = 29.7364  

**Commentaire** :  
L'idée selon laquelle "plus la profondeur est importante, mieux c'est" est incorrecte.   
Une profondeur intéressante se situe autour de 30X. Les profondeurs observées pour nos souches ne   
dépassent pas 30X, ce qui est acceptable. L'utilisation de Filtlong pour réduire la profondeur ne  
sera donc pas nécessaire.

* **Merge des fichiers Nanostat avec R pour créer un seul tableau pour les trois souches** : *(Adeline)*

## 29/10 :  

* **Ajout d'un package seqkit sur l'environnement flye_env** : *(Céline)*  
  - Version de seqkit : 2.8.2  

* **Filtrage des fichiers LongReads Corrected pour supprimer les séquences de moins de 1000 pb   
avec seqkit** : *(Céline)*  

**Commentaire** :  
L'idée de supprimer les fragments trop petits est de réduire le bruit dans les données. Les petites  
séquences peuvent être des répétitions ou contenir peu d'informations. Cela permettrait de réduire   
le nombre de séquences dans le fichier, et potentiellement d'obtenir un meilleur assemblage.   
Cependant, cette approche comporte un risque de perte d'informations importantes.

* **Assemblage de génome avec Flye pour la souche 7890** : *(Céline)*  
  - **Sans modification** : Assemblage sur les données brutes (raw data)  
  - **Avec fichier filtré** : Assemblage sur les données filtrées (séquences < 1000 pb exclues)  

* **Assemblage de génome avec Smartdenovo pour la souche 7890** : *(Adeline)*  
  - **Sans modification** : Assemblage sur les données brutes  
  - **Avec fichier filtré** : Assemblage sur les données filtrées (séquences < 1000 pb exclues)  

* **Création des fichiers Nanostat (resume_reads) pour les assemblages de Flye et Smartdenovo** : *(Céline)*  

**Commentaire** :  
Les assemblages réalisés avec Flye semblent avoir bien fonctionné, produisant des assemblages   
d'environ 11 Mb (proche des 13 Mb estimés, ce qui est cohérent). En revanche, pour les assemblages Smartdenovo,  
il y a un problème. L'assemblage produit ne fait que 3 Mb avec de nombreux contigs, ce qui laisse penser qu'il  
y a eu un problème lors de l'exécution des commandes. Ces assemblages devront être refaits.

## 03/11 :  

* **Comptage du nombre de séquences en dessous de 1000 pb pour chaque souche afin d'estimer l'impact du   
filtrage** : *(Céline)*  
  - **Souche 7890** : 9 séquences < 1000 pb  
  - **Souche 7895** : 578 séquences < 1000 pb  
  - **Souche 8039** : 1093 séquences < 1000 pb  

**Commentaire** :  
La souche 7890 ne perd que très peu de séquences en filtrant les fragments < 1000 pb. En revanche, les   
deux autres souches (7895 et 8039) perdent un nombre beaucoup plus important de séquences. Il est donc probable  
que l'assemblage entre les données brutes et filtrées soit plus différent pour ces souches.

* **Assemblage Flye des souches 7895 et 8039 (brutes et filtrées) et création des fichiers récapitulatifs  
Nanostat** : *(Céline)*  
  **Commentaire** :  
  Les données semblent cohérentes, et la taille du génome estimée est correcte. Pour une même souche, la   
  différence entre les assemblages bruts et filtrés est faible, généralement se traduisant par un seul  
  contig en plus ou en moins.

* **Création du script automatic_launch.py pour lancer plusieurs commandes en séquence** : *(Céline)*  
  Ce script a été créé pour automatiser l'exécution de multiples commandes, facilitant le processus  
  d'assemblage et d'analyse en série.

* **Assemblage Flye pour la souche 7890 brut** : *(Céline)*  
  - Test avec l'option `--min overlap` (valeurs 300 et 750)  
  - Test avec l'option `--scaffold`  
  Ces tests ont été lancés automatiquement via le script `automatic_launch.py` pendant la nuit, les   
  résultats sont en attente.  

**Commentaire** :  
Les tests avec l'option `--min overlap` visent à explorer l'impact de la longueur minimale du chevauchement   
entre deux séquences adjacentes, permettant une valeur plus flexible (300 et 750) que la valeur par défaut   
de 500. L'option `--scaffold` permet d'assembler les contigs en scaffolds, ce qui pourrait améliorer la   
qualité de l'assemblage.

* **Assemblage Smartdenovo sur les 3 souches (brutes) et fichiers Nanostat** : *(Adeline)*  
  Ces assemblages ont été réalisés automatiquement via le script `automatic_launch.py`, les résultats   
  sont en attente.

* **Diagramme de distribution des longueurs des contigs des assemblages Flye et Smartdenovo pour la souche   
7890 filtrée** : *(Adeline)*  
  Un diagramme a été généré en utilisant R pour vérifier qu'aucune séquence trop petite ne subsiste dans   
  les assemblages filtrés de Flye et Smartdenovo.

## 05/11 :  

* **Assemblage Smartdenovo pour les 3 souches filtrées et fichiers Nanostats** : *(Adeline)*  
**Commentaire** :  
Lors de la comparaison des résultats de Nanostat pour les données brutes et filtrées, nous remarquons que  
les métriques (N50, longueur du génome, nombre de contigs...) sont identiques pour les souches 7890 et 7895.  
Toutefois, pour la souche 8039, une différence notable apparaît : on passe d'un génome de 9 Mb et 24 contigs  
pour les données brutes à un génome de 10 Mb et 65 contigs pour les données filtrées. Cela semble étrange,  
et un nouvel assemblage pour cette souche sera réalisé.

* **Rédaction des fichiers README.md et code_projet.sh** : *(Adeline)*  
**Commentaire** :  
Le fichier `README.md` décrit les différents dossiers dans le répertoire `/data/projet4`. Le fichier   
`code_projet.sh` contient les commandes spécifiques utilisées pour obtenir les résultats du projet.  

* **Création du fichier lab_journal.md et modification du Lab_journal.md en command_journal.md** : *(Céline)*  
**Commentaire** :  
Le fichier `lab_journal.md` (celui que vous lisez actuellement) présente les différentes tâches effectuées.  
Le fichier `command_journal.md` contient les commandes associées à chaque tâche, tandis que le fichier `README.md`   
explique l'organisation des dossiers, et le fichier `code_projet.sh` regroupe les commandes nécessaires pour   
reproduire les résultats.

* **Génération des histogrammes de la distribution de la longueur des scaffolds pour les 3 souches (Flye et   
Smartdenovo)** : *(Adeline)*  
**Commentaire** :  
Les histogrammes montrent que les contigs obtenus avec Smartdenovo sont moins nombreux, plus longs, et   
contiennent moins de petites séquences comparé à Flye, qui génère davantage de petits contigs.  

**Pour la suite** :  
Nous allons privilégier l'utilisation des assemblages filtrés plutôt que des bruts, car la différence est   
négligeable et il est préférable de travailler avec un nombre réduit de séquences. L'étape suivante consistera   
à effectuer un **polish avec Racon** pour nettoyer les assemblages et un **BUSCO** pour évaluer la complétude   
des assemblages réalisés avec Flye et Smartdenovo.

## 09/11 :  

* **Installation de Racon pour le polissage** : *(Adeline)*  
L'installation de **Racon** a été effectuée pour permettre le polissage des assemblages de génomes et   
améliorer leur qualité.

## 11/11 :  

* **Installation de Minimap2 et de Samtools** : *(Adeline)*

* **Test d'utilisation de Minimap2 sur un fichier d'assemblage de Smartdenovo** : *(Céline et Adeline)*  
**Commentaire** :  
Nous avons tenté d'utiliser Racon, mais nous avons rencontré un problème récurrent avec l'erreur   
"Aborted (core dumped)", empêchant l'utilisation de l'outil pour le polissage des assemblages.

## 18/11 :  

* **Installation de Mummer** : *(Adeline)*

* **Création d'un environnement BUSCO et installation de BUSCO (v. 5.8.0)** : *(Céline)*

## 19/11 :  

* **Lancement de BUSCO sur l'assemblage 7890_filtered de Flye et Smartdenovo** : *(Céline et Adeline)*  
**Commentaire** :  
La commande BUSCO n'a pas fonctionné, malgré plusieurs tentatives et modifications du nombre de threads.   
Le serveur a planté et le job a été tué. Cependant, des fichiers de sortie ont été générés, incluant des   
logs sans erreur, mais nous n'avons pas obtenu le fichier txt de sortie attendu avec les informations complètes.


## 20/11 :  

* **Relance de Minimap2 avec automatic_launch.py** :  
**Commentaire** :  
Une relance de Minimap2 a été nécessaire en raison d'un fichier SAM corrompu. Nous avons utilisé   
`automatic_launch.py` pour suivre l'erreur et faciliter le diagnostic.

* **Réinstallation de Mummer dans l'environnement BUSCO et installation de Gnuplot** :  
Mummer (version 3.23) et Gnuplot (version 5.4.10) ont été installés dans l'environnement BUSCO pour   
éviter des conflits avec l'environnement Flye.


## 21/11 :  

* **Installation de BWA (version 0.7.17)**

* **Génération de fichiers SAM avec BWA**  
Nous avons généré de nouveaux fichiers SAM en utilisant l'outil BWA au lieu de Minimap2. Les fichiers   
Illumina ont été concaténés pour être utilisables par Racon.

* **Re-test avec Racon** :  
Nous avons testé à nouveau Racon avec les fichiers générés par BWA, mais l'erreur persistante   
"error: empty overlap set!" a été rencontrée, empêchant le bon fonctionnement du polissage.

## 23/11 :  

* **Téléchargement des BUSCO** : *(Adeline)*

* **Génération des fichiers SAM avec BWA et polishing avec Racon** : *(Adeline)*

* **Réalisation de MUMMER plot via Galaxy** : *(Céline)*  
**Commentaire** :  
Les BUSCO ont été réalisés par Mme. Friedrich en raison d'un problème de place ou de mémoire sur le  
serveur, ce qui rendait impossible la commande directement sur notre infrastructure. Les fichiers SAM   
ont été générés avec BWA, en concaténant les fichiers Illumina, puis le polishing a été effectué avec Racon.  
En raison de problèmes avec les outils de visualisation des MUMMER plots sur notre serveur, nous avons   
réalisé ces derniers via Galaxy.


## 24/11 :  

* **Génération des plots de BUSCO** : *(Adeline)*  
**Commentaire** :  
Les résultats de BUSCO montrent que les assemblages réalisés par Flye sont légèrement meilleurs que ceux   
de Smartdenovo (moins de séquences Missing, Fragmented et Duplicated), surtout pour la souche 8039.   
Nous avons donc décidé d'utiliser les assemblages de Flye pour la suite du projet.

* **Test d'une commande avec tblastn pour explorer les options** : *(Adeline)*

## 27/11 :  

* **Test d'une nouvelle commande pour tblastn** : *(Adeline)*

* **Tri des résultats de tblastn en fonction du %ID et de la longueur minimale** : *(Adeline)*

## 28/11 :  

* **Lancement du filtrage des fichiers tblastn en fonction du pourcentage de couverture** : *(Adeline et Céline)*  
Filtrage des séquences protéiques pour ne garder que celles ayant une couverture supérieure à 90%.

* **Création d'un script R pour un tableau récapitulatif de présence/absence des protéines** : *(Adeline)*  
Automatisation dans le fichier `code_projet.sh`.

* **Mise à jour du README et génération des fichiers .yml** : *(Céline)*  
Les fichiers .yml résument les packages de chaque environnement pour faciliter le partage et la reproductibilité.


## 29/11 :  

* **Test de différents seuils avec la commande de tri pour les résultats de blast** : *(Adeline)*

## 03/12 :  

* **Création d'un script R pour un diagramme de Venn** : *(Céline)*  
Ce script permet de générer un diagramme de Venn pour illustrer les résultats de BLAST et visualiser   
combien de protéines sont partagées entre les différentes souches ou absentes.

* **Réalisation de MUMMER plot via Galaxy** : *(Céline)*  
Comparaison des assemblages Flye contre la référence brbr pour vérifier s'il manque des régions dans   
les assemblages de Flye.  
**Commentaire** :  
Les mummerplots avec la séquence de référence ne fonctionnaient pas sur Galaxy, et nous avons rencontré   
des difficultés pour utiliser MUMMER sur le serveur en raison d'un manque d'espace pour les bibliothèques.   
Nous avons donc décidé de mettre cette tâche en pause et de l'ouvrir pour d'autres solutions.