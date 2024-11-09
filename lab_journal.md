# Journal de bord (projet4)

Commentaire : Par soucis de lisibilité, ce journal de bord ne contient pas les commandes effectuées. Cependant, elles sont trouvables dans le fichier command_journal.md, pour chaque jour et chaque tâche correspondante. 

## 20/10 :
* Mise en place du github (Céline)
Lien : https://github.com/celinemasson/projet4_PTU 

## 23/10 : 
* Création des environnements : 
  * flye_env : /data/projet4/conda/masson/flye_env (Céline)
    * package flye (version 2.8.1)
    * package filtlong 

  * smartdenovo : /data/projet4/conda/gagnon/smartdenovo (Adeline)
    * package smartdenovo (version 1.0.0)

* Organisation des dossiers : (Adeline)
  * création de fichiers markdown README et Lab_journal 
  * création de nouveaux dossiers : 
    * code : contiendra les scripts 
    * data : contient les données brutes et produites
      - raw : données brutes des Long/Shortreads
      - filtlong : données output de filtlong 
    * conda : contient les environnements conda 

* Lancement d'un test Filtlong : (Adeline)
  * préparation des données test : extraction des 1000 premières séquences du fichier fasta de la levure 7890 (tequila) et compression du fichier 
  * test de Filtlong sur les données test (Céline)

Commentaire : Flye et Smartdenovo nous serviront pour faire des assemblages de génome à partir des séquences LongReads. Filtlong sera utilisé pour filtrer les données (réduire la profondeur).

## 25/10 : (Adeline)
* Ajout du git ignore pour empêcher le transfert des données trop lourdes sur le github : les fichiers contenues dans le git ignore ne sont pas pris en compte lors de la sauvegarde vers le git
* Fusion des environnements flye et smartdenovo en un seul : /data/projet4/conda/masson/flye_env

## 28/10 : 

* Création d'un nouvel environnement pour nanostat car le package est incompatible avec certains packages de l'environnement flye_env. /data/projet4/conda/gagnon/nanostat_env (Adeline) 
  * package nanostat (version 1.4.0)
  * package R (version 4.4)

* Utilisation de Nanostat pour extraire les métriques des séquences (N50, longueurs moyennes...) des trois souches (Céline, fichiers txt ; Adeline, fichiers tsv). Les fichiers Nanostats se trouvent dans ./data/resume_reads/

* Calcul de la profondeur des séquences : (Céline) 
Suivant la formule : pronfondeur = nombre total de bases / taille du génome (13Mb)
  * Profondeur 7890 (Tequila) = 214 278 043 / 13 000 000 = 16.4829
  * Profondeur 7895 (Beer) = 332 449 493 / 13 000 000 = 25.5730
  * Profondeur 8039 (Wine) = 386 573 797 / 13 000 000 = 29.7364 

Commentaire : L'idée que "plus la profondeur est importante mieux c'est" est fausse. Une profondeur intéressante est environ vers 30X. On a donc cherché à savoir la profondeur de séquençage de nos souches, pour voir si nous avions des profondeurs supérieures à 40X. Ce n'est pas le cas ici, on ne passe pas les 30X. La profondeur est donc acceptable, l'utilisation de Filtlong pour réduire la profondeur ne sera pas nécessaire. 

* Merge des fichiers nanostat avec R pour avoir un seul tableau pour les trois souches avec R (Adeline) 

## 29/10 : 

* Ajout d'un package seqkit sur l'environnement flye_env (version 2.8.2) (Céline)

* Filtre des fichiers LongReads Corrected afin de supprimer les séquences de moins de 1000 pb avec seqkit (Céline) 

Commentaire : enlever les fragments trop petits permettrait de réduire le bruit (les petites séquences peuvent être des répétitions et ne pas porter beaucoup d'informations), réduire le nombre de séquence dans le fichier et potentiellement avoir un meilleur assemblage. Cependant, on ne peut pas exclure la perte potentielle d'informations. 

* Assemblage de génome avec flye pour la souche 7890 : (Céline)
  * sans modification : sur les raw data 
  * avec fichier filtré : sans les séquences < 1000 pb 

* Assemblage de génome avec smartdenovo pour la souche 7890 : (Adeline)
  * sans modification : sur les raw data 
  * avec fichier filtré : sans les séquences < 1000 pb 

* Création des fichiers Nanostat (resume_reads) pour les assemblages de flye et smartdenovo (Céline)

Commentaire : les assemblages de flye semblent avoir marché, on a des assemblages d'environ 11 Mb (proche des 13 Mb estimé donc cohérent). On ne note pas de grande différence entre les assemblages avec les données brutes et les données filtrées. Il semble y avoir un problème avec les assemblages de smartdenovo car l'assemblage ne fait que 3 Mb avec des milliers de contigs. On ne pense pas qu'ils aient bien marché, sans doute un problème lors de la commande. Ils seront à refaire. 

## 03/11 

* Comptage du nombre de séquences en dessous de 1000pb pour chaque souche afin d'estimer si on enlève beaucoup de séquences dans les fichiers des différentes souches. (Céline)

Commentaire : on trouve que 9 séquences de moins de 1000 bp pour la souche 7890. Cependant le nombre de séquences inférieures à 1000 bp pour les deux autres souches sont plus importantes (7895 : 578; 8039 : 1093). Peut être que pour ces dernières souches, l'assemblage sera plus différent entre les données brutes et filtrées. 

* Assemblage flye des souches 7895 et 8039 (brutes et filtrées) et création des fichiers récapitulatifs Nanostat (Céline)

Commentaire : Les données semblent cohérentes, la taille du génome est cohérente. Pour une même souche, on note une différence faible entre les filtrées et les brutes (généralement un contig). 

* Création du script automatic_launch.py pour lancer plusieurs commandes les unes après les autres (Céline)

* Assemblage flye pour la souche 7890 brut : (Céline)
  * test avec l'option --min overlap (300 et 750) 
  * test avec l'option -- scaffold 
(lancés en automatique via le script automatic_launch.py dans la nuit, en attente des résultats)

Commentaire : ces assemblages sont des tests de nouvelles fonctions. --min overlap sépcifie la longueur minimale du chevauchement entre deux séquences pour qu'elles soient considérées comme adjacentes. La valeur de base est de 500, mais peut être diminuée si les données sont de bonne qualité (ce qui est le cas ici). On a donc fait un test avec une valeur plus faible (300) et plus forte (750) pour voir les différences et les effets. Aussi, --scaffold permettrait d'assembler les contigs en scaffold.

* Assemblage smartdenovo sur les 3 souches (brutes) et fichiers Nanostat (Adeline)
(lancés en automatique via le script automatic_launch.py dans la nuit, en attente des résultats)

* Diagramme de distribution des longueurs des contigs des assemblages par R afin de voir si l'on a pas de trop petites séquences sur 7890 filtrées pour les assemblages flye et smartdenovo  (Adeline)

## 05/11

* Assemblage smartdenovo pour les 3 souches filtrées et fichiers Nanostats (Adeline)

Commentaire : En comparant les Nanostats pour une souche entre les brutes et les filtrées, on remarque que les métriques sont identiques (N50, longueur du génome, nombre de contig...) pour les souches 7890 et 7895. Cependant, on observe une différence assez importante entre les deux versions pour la souche 8039 : on passe d'un génome de 9Mb et de 24 contigs pour les brutes à un génome de 10 Mb et de 65 contigs pour les filtrées. Cela nous semble étrange, donc nous allons refaire un assemblage pour cette souche. 

* Rédaction des fichiers README.md et code_projet.sh (Adeline)

* Création du fichier lab_journal.md et modification du Lab_journal.md en command_journal.md (Céline)

Commentaire : le fichier lab_journal.md (celui que vous lisez) contient les différentes tâches effectuées et le fichier command_journal.md contient les commandes relatives à ces tâches. Le fichier README.md contient une explication des différents dossiers sur /data/projet4 et le fichier code_projet.sh ne contient que les commandes à suivre et qui fonctionnent pour arriver à nos résultats.

* Génération des histogrammes de la distribution de la longueur des scaffolds pour les 3 souches (flye et smartdenovo). (Adeline)

Commentaire : on remarque que les contigs issus de l'assemblage avec smartdenovo sont moins nombreux, plus longs et contiennent peu de petites séquences alors que du côté de flye, on a plus de petits contigs. 


Pour la suite : nous allons par la suite travailler sur les assemblages filtrés plutôt que sur les bruts, car la différence est minime et autant privilégier un nombre moins important de séquences dans les fichiers. Pour finir l'étape "assemblage" du projet, il nous reste à faire un polish avec Racon afin de nettoyer les assemblages et de faire un BUSCO sur les assemblages flye et smartdenovo afin de voir si la complétude est similaire entre deux assemblages de deux packages différents.

## 09/11

* Installation de Racon pour le polissage (Adeline)