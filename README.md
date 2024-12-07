# projet4_PTU

## Description du Projet
Ce projet tutoré de M2BBS se concentre sur une étude comparative des génomes acquis au sein de la levure *Brettanomyces bruxellensis*. L'objectif principal est de comparer les assemblages de génomes produits à partir des données de séquençage de plusieurs souches de *Brettanomyces bruxellensis* (7890, 7895, 8039) en utilisant différents outils de bioinformatique pour l'assemblage et l'analyse des données de séquence. Ces outils incluent Flye, Smartdenovo, et plusieurs autres pour le filtrage des données, le polissage des assemblages, et l'analyse de la qualité.

## Structure du Dossier `projet4/`

Le dossier `projet4/` contient les fichiers et sous-dossiers suivants :

### Fichiers principaux :
- **README.md** : Fichier d'explication générale du projet.
- **lab_journal.md** : Cahier de laboratoire contenant la description des tâches accomplies.
- **command_journal.md** : Brouillon des commandes effectuées pour chaque tâche du `lab_journal.md`.

### Sous-dossiers :

#### **conda/**
Environnements conda utilisés pour les différentes étapes du projet.
  - **gagnon/nanostat_env/** : Environnement contenant les packages NanoStat et R.
  - **masson/flye_env/** : Environnement contenant les packages Flye et Smartdenovo.

#### **code/**
Scripts et codes utilisés pour l'automatisation et le traitement des données.
  - **code_projet.sh** : Contient les commandes permettant de générer les différents résultats dans le dossier `data/`.
  - **automatic_launch.py** : Script permettant de lancer automatiquement plusieurs commandes.

#### **data/**
Contient toutes les données utilisées et générées pendant le projet.
  - **blast/** : Contient les fichiers de sortie de `tblastn`.
  - **busco/** : Contient les données provenant de l'outil BUSCO.
    - **BUSCO_summaries** : Contient les résumés de BUSCO et le script pour générer la figure récapitulative des résultats.
  - **bwa/** : Contient les fichiers résultants du mapping par `BWA` pour les assemblages Smartdenovo et Flye.
  - **data_modified/** : Contient les séquences modifiées avec `Seqkit`.
    - **LongReads_wo_1000/** : Contient les séquences filtrées (sequences inférieures à 1000 pb).
  - **flye/** : Contient les fichiers de sortie de l'outil Flye.
    - **YSJ7890_output** : Assemblages pour la souche 7890 (brutes et filtrées).
    - **YSJ7895_output** : Assemblages pour la souche 7895 (brutes et filtrées).
    - **YSJ8039_output** : Assemblages pour la souche 8039 (brutes et filtrées).
  - **length_plot_data/** : Contient les plots de la distribution de la taille des scaffolds pour chaque assemblage.
  - **mummer/** : Contient les MUMMERPLOTS des comparaisons des alignements entre Smartdenovo et Flye.
  - **racon/** : Contient les assemblages polishes réalisés avec Racon.
  - **raw/** : Contient les données brutes utilisées dans l'étude.
    - **LongReads/** : Contient les séquences brutes et corrigées.
    - **ShortReads/** : Contient les séquences Illumina pairées.
    - **brbr.fasta et brbr.gff** : Séquence de référence pour *Brettanomyces bruxellensis*.
    - **brettAllProt_ref2n.fasta** : Contient les séquences protéiques de la référence brbr.
  - **resume_reads/** : Contient les fichiers résumés des lectures.
    - **_resume(_tsv)** : Fichier résumé de NanoStat des séquences brutes.
    - **_flye_raw(_filtered)assembly_resume** : Résumé des assemblages Flye.
    - **_smartdenovo_raw(_filtered)assembly_resume** : Résumé des assemblages Smartdenovo.
    - **resume_reads.tsv** : Résumé des trois fichiers _resume, avec la couverture des lectures.
  - **smartdenovo/** : Contient les fichiers de sortie de l'outil Smartdenovo.
    - **_filtered/** : Assemblages avec les séquences filtrées.
    - **_raw/** : Assemblages avec les séquences brutes.