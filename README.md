# projet4_PTU
Github du projet tutoré de M2BBS. Etude comparative des génomes acquis au sein de la levure Brettanomyces bruxellensis.

Le dossier projet4/ est composé de différents fichiers :
* README.md : ce fichier
* lab_journal.md : le cahier de laboratoire contenant la description des tâches accomplies
* command_journal.md : brouillon des commandes effectuées pour chaque tâche du lab_journal.md

Et de différents sous-dossiers :
* conda/ : contenant les différents environnements utilisés
    * gagnon/nanostat_env/ : contenant l'environnement avec les packages NanoStat et R
    * masson/flye_env/ : contenant l'environnement avec les packages Flye et Smartdenovo

* code/ : contenant les scripts et codes utilisés
    * code_projet.sh : contenant le code utilisé pour générer les différents outputs dans le dossier data/
    * automatic_launch.py : script permettant de lancer des commandes automatiquement

* data/ : contenant toutes les données utilisées
    * blast/ : contenant les fichiers de sortie de tblastn 
    * busco/ : contenant les donénes provenant des busco
        - BUSCO_summaries : contient les short_summaries des BUSCO, le script pour faire la figure récapitulative des BUSCO
    * bwa/ : contenant les fichiers résultants du mapping par bwa pour smartdenovo et flye 
    * data_modified/ : contenant les séquences modifiées avec Seqkit
        - LongReads_wo_1000/ : contenant les fichiers avec les séquences inférieures à 1000 bases filtrées de data/raw LongReads/Corrected/
    * flye/ : contenant les fichiers output de l'outil flye
        - YSJ7890_output : contient les fichiers de sorties flye pour la souche 7890 (raw : flye à partir des données brutes ; filtered : flye à partir des données filtrées)
        - YSJ7895_output : contient les fichiers de sorties flye pour la souche 7895 (raw : flye à partir des données brutes ; filtered : flye à partir des données filtrées)
        - YSJ8039_output : contient les fichiers de sorties flye pour la souche 7890 (raw : flye à partir des données brutes ; filtered : flye à partir des données filtrées)
    * length_plot_data/ : contenant les plots de la distibution de la taille des scaffolds pour chaque assemblage 
    * mummer/ : contenant les MUMMERPLOT des comparaisons des alignements. Les alignements smartdenovo et flye sont comparés entre eux pour chaque souche. 
    * racon/ : contenant les assemblages polish par racon 
    * raw/ : contenant les données brutes
        - LongReads/ : avec les séquences brutes et corrigées
        - ShortReads/ : avec les séquences pairées issues d'Illumina
        - brbr.fasta et brbr.gff : séquence de référence
        - brettAllProt_ref2n.fasta : contient les séquences protéiques des protéines retrouvée dans la référence (brbr)
    * * resume_reads/ : contenant tous les fichiers résumés
        - _resume(_tsv) : fichier résumé de NanoStat des séquences de data/raw/LongReads/Corrected/, et aussi en format tsv
        - _flye_raw(_filtered)assembly_resume : fichier résumé de NanoStat des assemblages de Flye
        - _smartdenovo_raw(_filtered)assembly_resume : fichier résumé de NanoStat des assemblages de Smartdenovo
        - resume_reads.tsv : résumé des trois fichiers _resume, avec en plus la couverture
    * smartdenovo/ : contenant les fichiers output de l'outil smartdenovo
        - _filtered/ : assemblage avec les séquences contenues dans data/data_modified/LongReads_wo_1000/, contenant le fichier d'assemblage en format .cns (convertis en .cns.fasta)
        - _raw/ : assemblage avec les séquences contenues dans data/LongReads/Corrected/, contenant le fichier d'assemblage en format .cns (convertis en .cns.fasta)
   
