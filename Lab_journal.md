# Journal de bord

## 20/10 : 
* Mise en place du Github : (Céline)
    - commandes :   ssh-keygen -t ed25519 -C "celine.masson2@etu.unistra.fr" 
                    L’identification a été saved au chemin : /home/masson/.ssh/id_ed25519
                    La clé publique a été saved au chemin : /home/masson/.ssh/id_ed25519.pub
                    cat ~/.ssh/id_ed25519.pub 
                    get init
                    git remote add origin git@github.com:celinemasson/projet4_PTU
                    git remote set-url origin git@github.com:celinemasson/projet4_PTU.git
                    

## 23/10 : 
* Création des environnements : 
    - flye_env + filtlong : /data/projet4/conda/masson/flye_env (Céline)
    commandes : conda create -n flye_env -c bioconda flye 
                conda rename -p /home/masson/.conda/envs/flye_env /data/projet4/conda/masson/flye_env 
                conda install -c bioconda filtlong 
            version : 2.8.1
    - smartdenovo : /data/projet4/conda/gagnon/smartdenovo/ (Adeline)
    commandes : conda create -p /data/projet4/conda/gagnon/smartdenovo python=3.11
                conda install bioconda::smartdenovo
            version : 1.0.0

* Organisation des dossiers : (Adeline)
    - fichier README et Lab_journal
    - code : avec tous les scripts et code utilisé
    - data :
        - raw : données brutes de Long/Shortreads
        - filtlong : données testes d'output
    - conda : là où sont stocker les environnements conda

* Lancement d'un test Filtlong :
    préparation des données : (Adeline)
        - Extraction des 1000 premières séquences du fichier fasta de la levure Teq, et compression :
            head -n 2000 data/raw/Longreads_dezip/YJS7890_1n_correctedLR.fasta > data/raw/Longreads_dezip/YJS7890_1000seq.fasta
            gzip data/raw/Longreads_dezip/YJS7890_1000seq.fasta


    commande : filtlong -1 /data/projet4/data/raw/ShortReads/YJS7890_Teq_1.fq.gz -2 /data/projet4/data/raw/ShortReads/YJS7890_Teq_2.fq.gz --min_length 1000 --keep_percent 90 --target_bases 20000000 /data/projet4/data/raw/Longreads_dezip/YJS7890_1000seq.fasta.gz | gzip > /data/projet4/data/filtlong/output_YJS7890_Teq_2_test.fasta.gz (Céline)


## 25/10 :
* Ajout du git ignore : (Adeline)
    - Commande :
        touch .gitignore
        Et ajout des dossiers conda et data
* Déplacement de tous les environnement en un seul :
    environment location: /data/projet4/conda/masson/flye_env


## 28/10 :
* Ajout du package samtools dans l'environnement flye_env (Céline) 
    - Commande :
    conda install -c bioconda samtools
    (version 1.3.1)
    conda install -c conda-forge ncurses
    (version 6.4)

* Ajout du package nanostat dans un nouvel environnement nanostat_env : (Adeline)
    conda create -p conda/gagnon/nanostat_env python==3.7
    conda activate /data/projet4/conda/gagnon/nanostat_env
    conda install -c bioconda nanostat
    (version 1.4.0)

    et installe de R :
    conda install -c conda-forge r
    (version 4.4)

* Utilisation de Nanostat pour extraire les métriques : (Céline)
    commande : NanoStat --fasta /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz \
         --outdir /data/projet4/data/resume_reads \
         --name YJS7890_1n_resume
         (fichier text en sortie)

    En format tsv : (Adeline)
        NanoStat --fasta /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz \
         --outdir /data/projet4/data/resume_reads \
         --name YJS7890_1n_resume_tsv --tsv

* Calcul de la profondeur de séquences : (Céline)
    Profondeur = Nombre total de bases / Taille du génome (13 Mb) 
    Profondeur 7890 (Tequila) = 214 278 043 / 13 000 000 = 16.4829
    Profondeur 7895 (Beer) = 332 449 493 / 13 000 000 = 25.5730
    Profondeur 8039 (Wine) = 386 573 797 / 13 000 000 = 29.7364

* Merge des fichiers avec R : (Adeline)
    data_YJS7890 <- read.table("data/resume_reads/YJS7890_1n_resume_tsv", header = TRUE, col.names = c("Metrics", "dataset_YJS7890"))
    data_YJS7895 <- read.table("data/resume_reads/YJS7895_1n_resume_tsv", header = TRUE, col.names = c("Metrics", "dataset_YJS7895"))
    data_YJS8039 <- read.table("data/resume_reads/YJS8039_1n_resume_tsv", header = TRUE, col.names = c("Metrics", "dataset_YJS8039"))
    merged_data <- cbind(data_YJS7890["Metrics"], data_YJS7890["dataset_YJS7890"], data_YJS7895["dataset_YJS7895"], data_YJS8039["dataset_YJS8039"])
    merged_data <- rbind(merged_data, list(Metrics = "depth",dataset_YJS7890 = 16.4829,dataset_YJS7895 = 25.5730, dataset_YJS8039 = 29.7364))
    write.table(merged_data, "data/resume_reads/resume_reads.tsv", sep = "\t", quote = FALSE, row.names = FALSE)
