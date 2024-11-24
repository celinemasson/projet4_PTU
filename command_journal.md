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
         (fichier .txt en sortie)

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

## 29/10 :
* Ajout d'un package seqkit sur l'environnement flye_env : (Céline)
    commande : conda install -c bioconda seqkit
    (version 2.8.2)

* Filtre des fichiers LongReads Corrected : supprimer les séquences de moins de 1000 pb avec seqkit: (Céline)
    commande : seqkit seq -m 1000 /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz | gzip > /data/projet4/data/data_modified/LongReads_wo_1000/filtered_YJS7890_1n_correctedLR.fasta.gz

    fichiers sans gaps : seqkit seq -m 1000 -g /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz | gzip > /data/projet4/data/data_modified/LongReads_wo_1000/nogap_filtered_YJS7890_1n_correctedLR.fasta.gz

* Test pour voir si le filtre a marché : avec seqkit (Céline)
    commandes : seqkit stats -T /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz | awk 'NR==2 {print $6}'
                --> pour les data raw : 977 bp pour la séquence la plus petite 
                seqkit stats -T /data/projet4/data/data_modified/LongReads_wo_1000/filtered_YJS7890_1n_correctedLR.fasta.gz | awk 'NR==2 {print $6}'
                --> pour les data filtrées : 1000 bp pour la séquence la plus petite

* Lancement des assemblages de génome avec flye pour la souche 7890 sans modifications et filtrée : (Céline)
    commandes : nohup flye --nano-corr /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz --out-dir /data/projet4/data/flye/YJS7890_output/YJS7890_raw --genome-size 13m --threads 4 > /data/projet4/data/flye/YJS7890_output/flye_output.log 2>&1 & 

    --> les fichiers de sorties se trouvent dans ./data/flye/YJS7890_output/YJS7890_raw/

    Sans les séquences < 1000 bp : 
    nohup flye --nano-corr /data/projet4/data/data_modified/LongReads_wo_1000/filtered_YJS7890_1n_correctedLR.fasta.gz --out-dir /data/projet4/data/flye/YJS7890_output/YJS7890_filtered --genome-size 13m --threads 4 > /data/projet4/data/flye/YJS7890_output/flye_YJS7890_filtered_output.log 2>&1 &

    --> les fichiers de sorties se trouvent dans ./data/flye/YJS7890_output/YJS7890_filtered/

* Assemblage de génome avec smartdenovo pour la souche 7890 sans modifications et filtrée : (Adeline)
    commande :
        /data/projet4/conda/masson/flye_env/bin/smartdenovo.pl -t 4 -p YJS7890_raw /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz > YJS7890_raw.mak
        make -f YJS7890_raw.mak
    --> les fichiers de sorties se trouvent dans ./data/smartdenovo/YJS7890_raw

    Sans les séquences < 1000 bp :
        /data/projet4/conda/masson/flye_env/bin/smartdenovo.pl -t 4 -p YJS7890_filtered /data/projet4/data/data_modified/LongReads_wo_1000/filtered_YJS7890_1n_correctedLR.fasta.gz > YJS7890_filtered.mak
        make -f YJS7890_filtered.mak
    --> les fichiers de sorties se trouvent dans ./data/smartdenovo/YJS7890_filtered

* Création des fichiers resume des assemblages flye : (Céline)
    commande :  NanoStat --fasta /data/projet4/data/flye/YJS7890_output/YJS7890_raw/assembly.fasta --outdir /data/projet4/data/resume_reads/ --name YJS7890_flye_rawassembly_resume
    --> pour les raw data

    NanoStat --fasta /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly.fasta --outdir /data/projet4/data/resume_reads/ --name YJS7890_flye_filteredassembly_resume
    --> pour les data filtrées

* Création des fichiers resume des assemblages smatdenovo : (Céline)
    commande : NanoStat --fasta /data/projet4/data/smartdenovo/YJS7890_raw/YJS7890_raw.fa.gz \ --outdir /data/projet4/data/resume_reads/ \ --name YJS7890_smartdenovo_rawassembly_resume
    --> pour les raw data 

    NanoStat --fasta /data/projet4/data/smartdenovo/YJS7890_filtered/YJS7890_filtered.fa.gz --outdir /data/projet4/data/resume_reads/ --name YJS7890_smartdenovo_filteredassembly_resume
    --> pour les data filtrées


## 03/11 : 
* Comptage du nombre de séquences en dessous de 1000 pb : (Céline)
    exemple de commande : seqkit seq -m 0 -M 999 YJS7890_1n_correctedLR.fasta.gz | seqkit stats
    --> filtrage des séquences nécessaire pour les souches Wine (nb_seq < 1000 = 1093) et Beer (nb_seq < 1000 = 578), peut être négligeable pour Tequila (nb_seq < 1000 = 9)


* Run des assemblages flye des souches 7895 et 8039 (raw et flitered) : (Céline)
    commandes : 
    souche 7895 :
    nohup flye --nano-corr /data/projet4/data/raw/LongReads/Corrected/YJS7895_1n_correctedLR.fasta.gz --out-dir /data/projet4/data/flye/YJS7895_output/YJS7895_raw --genome-size 13m --threads 4 > /data/projet4/data/flye/YJS7895_output/flye_output_7895raw.log 2>&1 & 
    souche 8039 :
    nohup flye --nano-corr /data/projet4/data/raw/LongReads/Corrected/YJS8039_1n_correctedLR.fasta.gz --out-dir /data/projet4/data/flye/YJS8039_output/YJS8039_raw --genome-size 13m --threads 4 > /data/projet4/data/flye/YJS8039_output/flye_output_8039raw.log 2>&1 &

* Run de plusieurs flye pour 7890 raw : (Céline)
    - test avec l'option --min overlap (300 et 750)
    - test avec une référence --polish-target
    - test avec l'option --scaffold 

* Création automatic_launch.py : pour lancer plusieurs lignes de commande à la suite

* Re teste de la commande smartdenovo : (Adeline)
    commande :
    /data/projet4/conda/masson/flye_env/bin/smartdenovo.pl -t 4 -p YJS7890_raw -c 1 /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz > data/smartdenovo/YJS7890_raw/YJS7890_raw.mak
    make -f data/smartdenovo/YJS7890_raw/YJS7890_raw.mak

    résumé avec nanostat :
    cp /data/projet4/data/smartdenovo/YJS7890_raw/YJS7890_raw.dmo.cns /data/projet4/data/smartdenovo/YJS7890_raw/YJS7890_raw.dmo.cns.fasta
    NanoStat --fasta /data/projet4/data/smartdenovo/YJS7890_raw/YJS7890_raw.dmo.cns.fasta --outdir /data/projet4/data/resume_reads/ --name YJS7890_smartdenovo_rawassembly_resume

* Run des assemblages smartdenovo des souches 7895 et 8039 : (Adeline)
    commande :
    souche 7895 :
    /data/projet4/conda/masson/flye_env/bin/smartdenovo.pl -t 4 -p YJS7895_raw -c 1 /data/projet4/data/raw/LongReads/Corrected/YJS7895_1n_correctedLR.fasta.gz > data/smartdenovo/YJS7895_raw/YJS7895_raw.mak
    make -C /data/projet4/data/smartdenovo/YJS7895_raw/ -f data/smartdenovo/YJS7895_raw/YJS7895_raw.mak

    souche 8039 :
    /data/projet4/conda/masson/flye_env/bin/smartdenovo.pl -t 4 -p YJS8039_raw -c 1 /data/projet4/data/raw/LongReads/Corrected/YJS7895_1n_correctedLR.fasta.gz > data/smartdenovo/YJS8039_raw/YJS8039_raw.mak
    make -C /data/projet4/data/smartdenovo/YJS8039_raw/ -f /data/projet4/data/smartdenovo/YJS8039_raw/YJS8039_raw.mak

    + lancement des souches YJS8039 non filtré et YJS7895, YJS8039 filtré avec le script de Céline

* Calcul longueur scaffold et plot avec R : (Adeline)
    commande :
    awk '/^>/ {if (NR>1) print length(seq); seq=""; next} {seq = seq $0} END {print length(seq)}' /data/projet4/data/smartdenovo/YJS7890_raw/YJS7890_raw.dmo.cns.fasta > data/smartdenovo/YJS7890_raw/scaffold_lengths.txt
    
    R
    scaffold_lengths <- read.table("scaffold_lengths.txt")$V1
    png("/data/projet4/data/length_plot_data/smartdenovo_scaffold_size_distribution.png")
    hist(scaffold_lengths, breaks=100)
    dev.off()


## 09/11 :
* Installation de Racon sur l'environnement conda flye_env : (Adeline)
    commande :
    conda install bioconda::racon
    version : v1.4.3


## 11/11 :
* Installation de Minimap2 et de Samtools sur l'environnement conda flye_env : (Adeline)
    commande :
     conda install bioconda::minimap2
    version : 2.22

     conda install bioconda::samtools
    version : 1.5

* Utilisation de Minimap 2 :
    Pour smartdenovo : (Adeline)
    commande :
    minimap2 -ax asm5 -t 4 /data/projet4/data/raw/brbr.fasta /data/projet4/data/smartdenovo/YJS7890_filtered/YJS7890_filtered.dmo.cns.fasta > /data/projet4/data/minimap/smartdenovo/alignement_YJS7890.sam


## 18/11 : 
* Installation de Mummer dans l'environnement flye_env : (Adeline)
    commande :
      conda install bioconda::mummer
    version : 3.23

* Création d'un envrionnement conda pour Busco : (Céline) 
    commande :  conda create -p /data/projet4/conda/masson/busco_env 
                conda install -c conda-forge -c bioconda busco=5.8.0

* Test de BUSCO avec l'assemblage 7890_filtered de flye : (Céline)
    commande : nohup busco -i /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta -o busco_flye_7890_filtered -l fungi_odb10 -m genome & 

Commentaire : la librairie utilisée pour cela est la librairie des fungi (fungi_odb10)

## 19/11 : 
* Tentative numéro 30 : BUSCO (Céline)
    commande : nohup busco -i /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta -o busco_flye_7890_filtered -l fungi_odb10 -m genome & 

* Tentative de Racon : (Céline)
    commande minimap2 : minimap2 -ax sr -t 4 /data/projet4/data/raw/ShortReads/YJS7890_Teq_1.fq.gz \
/data/projet4/data/raw/ShortReads/YJS7890_Teq_2.fq.gz \
/data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta \
| gzip > /data/projet4/data/minimap/alignements_7890_minimap.sam.gz

Commentaire : au début, on a essayé sans mettre un fichier sam zippé en output mais on a eu une erreur ([ERROR] failed to write the results: No space left on device) qui nous indique que nous n'avons pas assez de place. Après avoir fait une commande (du -h --max-depth=1 /data/projet4/data/minimap/ | sort -h) pour voir la place prise par les fichiers, on observait que les fichiers minimap2 non terminés lors de la commande faisaient déjà 53G. Nous avons donc tenté de faire avec un fichier .gz en sortie afin de limiter la place prise. 

* Tentative MUMmer : (Céline)
commande :  nucmer --prefix=alignment /data/projet4/data/smartdenovo/YJS7890_filtered/YJS7890_filtered.dmo.cns.fasta /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta 
            mummerplot -terminal --png --layout --prefix=alignment alignment.delta 
test d'une autre commande :
    mummer -mum -b -c data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta data/smartdenovo/YJS7890_filtered/YJS7890_filtered.dmo.cns.fasta > data/mummer/mummer_flye_smart_YJS7890.mums
    mummerplot -postscript -p mummer data/mummer/mummer_flye_smart_YJS7890.mums

## 20/11 : 
* Installation mummer et gnuplot dans l'environnement busco_env : (Céline)
mummer : conda install bioconda::mummer (version : 3.23)
gnuplot : conda install conda-forge::gnuplot (version : 5.4.10)

## 21/11 :
* Installation de BWA et blast dans l'environnement flye_env : (Adeline)
BWA : conda install bioconda::bwa (version : 0.7.17)
blast : se trouve déjà sur le serveur en version 2.12.0

* Génération de fichier SAM avec BWA : (Céline)
commande : bwa index /data/projet4/data/raw/brbr.fasta
bwa mem /data/projet4/data/raw/brbr.fasta /data/projet4/data/raw/ShortReads/YJS7890_Teq_1.fq.gz /data/projet4/data/raw/ShortReads/YJS7890_Teq_2.fq.gz > /data/projet4/data/bwa/7890_bwa.sam

* Concaténation des fichiers Illumina : (Céline)
commande : cat YJS7890_Teq_1.fq.gz YJS7890_Teq_2.fq.gz > illumina_7890.fq.gz
Puis le dézipper :
commande : gzip -d illumina_7895.fq.gz

* Re-test avec Racon et ce fichier SAM : (Céline & Adeline)
commande : racon /data/projet4/data/raw/ShortReads/illumina_7890.fq.gz /data/projet4/data/bwa/7890_bwa.sam /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta > /data/projet4/data/racon/racon_7890_flye.fasta

## 23/11 : 
* Téléchargement des busco (réalisés par Mme. Friedrich) (Adeline)

* Concaténation de tous les fichiers illumina, et rename /1 en :1 : (Adeline)
commande : zcat illumina_7890.fq.gz | sed '/^@/s|/1$|:1|; /^@/s|/2$|:2|' | gzip > illumina_7890_rename.fq.gz

* Re régénration de fichier SAM avec BWA : (Adeline)
commande : bwa index data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta
    bwa mem /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta /data/projet4/data/raw/ShortReads/illumina_7890_rename.fq.gz > /data/projet4/data/bwa/7890_bwa.sam 

* Polishing avec Racon : (Adeline)
commande : racon /data/projet4/data/raw/ShortReads/illumina_7890_rename.fq.gz /data/projet4/data/bwa/7890_bwa.sam /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta > /data/projet4/data/racon/racon_7890_flye.fasta

* Réalisation de MUMMER plot via Galaxy : (Céline)
Outil : Mummer 
Paramètres : 
Référence Sequence : fichier smartdenovo (assemblage fasta)
Query Sequence : fichier flye (assemblage fasta)
Minimum Match Length : 2500 ou 3000 ou 5000 

Commentaire : des tests ont été fait avec différentes options pour le mummer (changement de Anchoring avec -mumreference ou -mum, break length 100...) mais cela n'induisait pas de différences sur les plots. 

* Test avec Nanostat des fichiers Racon : (Adeline)
commande : NanoStat --fasta /data/projet4/data/racon/racon_7890_flye.fasta --outdir data/resume_reads/ --name racon_7890_flye_resume.tsv
