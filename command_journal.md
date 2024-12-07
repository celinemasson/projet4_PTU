# Journal de bord

## 20/10 : 
* **Mise en place du Github** : *(Céline)*
    - Commandes :
        ```bash
        ssh-keygen -t ed25519 -C "celine.masson2@etu.unistra.fr"
        # L’identification a été enregistrée au chemin :
        /home/masson/.ssh/id_ed25519
        # La clé publique a été enregistrée au chemin :
        /home/masson/.ssh/id_ed25519.pub
        cat ~/.ssh/id_ed25519.pub
        git init
        git remote add origin git@github.com:celinemasson/projet4_PTU
        git remote set-url origin git@github.com:celinemasson/projet4_PTU.git
        ```

## 23/10 : 
* **Création des environnements** : 
    - *flye_env + filtlong* : `/data/projet4/conda/masson/flye_env` *(Céline)*  
      Commandes :  
      ```bash
      conda create -n flye_env -c bioconda flye
      conda rename -p /home/masson/.conda/envs/flye_env /data/projet4/conda/masson/flye_env
      conda install -c bioconda filtlong
      ```
      Version : 2.8.1
    - *smartdenovo* : `/data/projet4/conda/gagnon/smartdenovo/` *(Adeline)*  
      Commandes :  
      ```bash
      conda create -p /data/projet4/conda/gagnon/smartdenovo python=3.11
      conda install -c bioconda smartdenovo
      ```
      Version : 1.0.0

* **Organisation des dossiers** : *(Adeline)*
    - Création des fichiers `README` et `Lab_journal`
    - Structure des dossiers :
        - `code` : scripts et codes utilisés
        - `data` :
            - `raw` : données brutes (Long/Shortreads)
            - `filtlong` : données testées en sortie
        - `conda` : stockage des environnements conda

* **Lancement d'un test Filtlong** : *(Adeline)*
    - Préparation des données :
        Extraction des 1000 premières séquences du fichier FASTA de la levure *Tequila*, et compression :
        ```bash
        head -n 2000 data/raw/Longreads_dezip/YJS7890_1n_correctedLR.fasta > data/raw/Longreads_dezip/YJS7890_1000seq.fasta
        gzip data/raw/Longreads_dezip/YJS7890_1000seq.fasta
        ```
    - Commande : *(Céline)*
        ```bash
        filtlong -1 /data/projet4/data/raw/ShortReads/YJS7890_Teq_1.fq.gz \
                 -2 /data/projet4/data/raw/ShortReads/YJS7890_Teq_2.fq.gz \
                 --min_length 1000 --keep_percent 90 --target_bases 20000000 \
                 /data/projet4/data/raw/Longreads_dezip/YJS7890_1000seq.fasta.gz \
        | gzip > /data/projet4/data/filtlong/output_YJS7890_Teq_2_test.fasta.gz
        ```

## 25/10 :
* **Ajout du `.gitignore`** : *(Adeline)*
    - Commandes :
        ```bash
        touch .gitignore
        # Ajout des dossiers conda et data
        ```

* **Déplacement de tous les environnements dans un seul emplacement** :  
  Chemin : `/data/projet4/conda/masson/flye_env`

## 28/10 : 

* **Ajout du package Nanostat dans un nouvel environnement `nanostat_env`** : *(Adeline)*  
    - **Commandes :**  
      ```bash
      conda create -p conda/gagnon/nanostat_env python==3.7
      conda activate /data/projet4/conda/gagnon/nanostat_env
      conda install -c bioconda nanostat
      ```
      - **Version :** 1.4.0

    - **Installation de R :**  
      ```bash
      conda install -c conda-forge r
      ```
      - **Version :** 4.4

* **Utilisation de Nanostat pour extraire les métriques** : *(Céline)*  
    - **Commande :**  
      ```bash
      NanoStat --fasta /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz \
               --outdir /data/projet4/data/resume_reads \
               --name YJS7890_1n_resume
      ```
      - Résultat : fichier `.txt` en sortie.  

    - **Format TSV :** *(Adeline)*  
      ```bash
      NanoStat --fasta /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz \
               --outdir /data/projet4/data/resume_reads \
               --name YJS7890_1n_resume_tsv --tsv
      ```

* **Calcul de la profondeur des séquences** : *(Céline)*  
    - **Formule :**  
      Profondeur = Nombre total de bases / Taille du génome (13 Mb).  
    - **Résultats :**  
      - **Profondeur YJS7890 (Tequila) :**  
        \( 214,278,043 \, / \, 13,000,000 = 16.4829 \)  
      - **Profondeur YJS7895 (Beer) :**  
        \( 332,449,493 \, / \, 13,000,000 = 25.5730 \)  
      - **Profondeur YJS8039 (Wine) :**  
        \( 386,573,797 \, / \, 13,000,000 = 29.7364 \)

* **Merge des fichiers avec R** : *(Adeline)*  
    - **Code R :**  
      ```R
      data_YJS7890 <- read.table("data/resume_reads/YJS7890_1n_resume_tsv", header = TRUE, col.names = c("Metrics", "dataset_YJS7890"))
      data_YJS7895 <- read.table("data/resume_reads/YJS7895_1n_resume_tsv", header = TRUE, col.names = c("Metrics", "dataset_YJS7895"))
      data_YJS8039 <- read.table("data/resume_reads/YJS8039_1n_resume_tsv", header = TRUE, col.names = c("Metrics", "dataset_YJS8039"))

      merged_data <- cbind(
        data_YJS7890["Metrics"],
        data_YJS7890["dataset_YJS7890"],
        data_YJS7895["dataset_YJS7895"],
        data_YJS8039["dataset_YJS8039"]
      )

      merged_data <- rbind(
        merged_data,
        list(
          Metrics = "depth",
          dataset_YJS7890 = 16.4829,
          dataset_YJS7895 = 25.5730,
          dataset_YJS8039 = 29.7364
        )
      )

      write.table(merged_data, "data/resume_reads/resume_reads.tsv", sep = "\t", quote = FALSE, row.names = FALSE)
      ```

## 29/10 :

* **Ajout du package Seqkit dans l'environnement `flye_env`** : *(Céline)*  
    - **Commande :**  
      ```bash
      conda install -c bioconda seqkit
      ```
      - **Version :** 2.8.2

* **Filtrage des fichiers LongReads Corrected : supprimer les séquences de moins de 1000 pb avec Seqkit** : *(Céline)*  
    - **Commande :**  
      ```bash
      seqkit seq -m 1000 /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz | gzip > /data/projet4/data/data_modified/LongReads_wo_1000/filtered_YJS7890_1n_correctedLR.fasta.gz
      ```
    - **Fichiers sans gaps :**  
      ```bash
      seqkit seq -m 1000 -g /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz | gzip > /data/projet4/data/data_modified/LongReads_wo_1000/nogap_filtered_YJS7890_1n_correctedLR.fas
      ```

* **Test pour vérifier si le filtre a fonctionné avec Seqkit** : *(Céline)*  
    - **Commandes :**  
      Pour les données brutes :  
      ```bash
      seqkit stats -T /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz | awk 'NR==2 {print $6}'
      ```
      - Résultat : 977 bp pour la séquence la plus petite.  
      Pour les données filtrées :  
      ```bash
      seqkit stats -T /data/projet4/data/data_modified/LongReads_wo_1000/filtered_YJS7890_1n_correctedLR.fasta.gz | awk 'NR==2 {print $6}'
      ```
      - Résultat : 1000 bp pour la séquence la plus petite.

* **Lancement des assemblages de génome avec Flye pour la souche 7890 sans modifications et filtrée** : *(Céline)*  
    - **Commande pour les données brutes :**  
      ```bash
      nohup flye --nano-corr /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz --out-dir /data/projet4/data/flye/YJS7890_output/YJS7890_raw --genome-size 13m --threads 4 > /data/projet4/data/flye/YJS7890_output/YJS7890_raw/log.txt &
      ```
      - Les fichiers de sortie se trouvent dans :  
        `/data/projet4/data/flye/YJS7890_output/YJS7890_raw/`

    - **Sans les séquences < 1000 pb :**  
      ```bash
      nohup flye --nano-corr /data/projet4/data/data_modified/LongReads_wo_1000/filtered_YJS7890_1n_correctedLR.fasta.gz --out-dir /data/projet4/data/flye/YJS7890_output
	  ```
## 03/11 :

* **Comptage du nombre de séquences en dessous de 1000 pb** : *(Céline)*  
    - **Exemple de commande :**  
      ```bash
      seqkit seq -m 0 -M 999 YJS7890_1n_correctedLR.fasta.gz | seqkit stats
      ```
    - Résultats pour les souches :  
      - **Wine :** 1093 séquences < 1000 pb  
      - **Beer :** 578 séquences < 1000 pb  
      - **Tequila :** 9 séquences < 1000 pb (peut être négligeable)

* **Lancement des assemblages Flye pour les souches 7895 et 8039 (raw et filtered)** : *(Céline)*  
    - **Commande pour la souche 7895 :**  
      ```bash
      nohup flye --nano-corr /data/projet4/data/raw/LongReads/Corrected/YJS7895_1n_correctedLR.fasta.gz --out-dir /data/projet4/data/flye/YJS7895_output/YJS7895_raw --genome-size 13m --threads 4 > /data/projet4/data/flye/YJS7895_output/YJS7895_raw/log.txt &
      ```
    - **Commande pour la souche 8039 :**  
      ```bash
      nohup flye --nano-corr /data/projet4/data/raw/LongReads/Corrected/YJS8039_1n_correctedLR.fasta.gz --out-dir /data/projet4/data/flye/YJS8039_output/YJS8039_raw --genome-size 13m --threads 4 > /data/projet4/data/flye/YJS8039_output/YJS8039_raw/log.txt &
      ```

* **Lancement de plusieurs assemblages Flye pour 7890 raw** : *(Céline)*  
    - Test avec l'option `--min-overlap` (300 et 750)  
    - Test avec une référence `--polish-target`  
    - Test avec l'option `--scaffold`

* **Création du script `automatic_launch.py`** : *(Céline)*  
    - Script pour lancer plusieurs lignes de commande à la suite.

* **Re-test de la commande Smartdenovo pour la souche 7890** : *(Adeline)*  
    - **Commande :**  
      ```bash
      /data/projet4/conda/masson/flye_env/bin/smartdenovo.pl -t 4 -p YJS7890_raw -c 1 /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz > data/smartdenovo/YJS7890_raw/YJS7890_raw.mak
      make -f data/smartdenovo/YJS7890_raw/YJS7890_raw.mak
      ```
    - **Résumé avec NanoStat :**  
      - **Commande :**  
        ```bash
        cp /data/projet4/data/smartdenovo/YJS7890_raw/YJS7890_raw.dmo.cns /data/projet4/data/smartdenovo/YJS7890_raw/YJS7890_raw.dmo.cns.fasta
        NanoStat --fasta /data/projet4/data/smartdenovo/YJS7890_raw/YJS7890_raw.dmo.cns.fasta --outdir /data/projet4/data/resume_reads/ --name YJS7890_smartdenovo_rawassembly_resume
        ```

* **Lancement des assemblages Smartdenovo pour les souches 7895 et 8039** : *(Adeline)*  
    - **Commande pour la souche 7895 :**  
      ```bash
      /data/projet4/conda/masson/flye_env/bin/smartdenovo.pl -t 4 -p YJS7895_raw -c 1 /data/projet4/data/raw/LongReads/Corrected/YJS7895_1n_correctedLR.fasta.gz > data/smartdenovo/YJS7895_raw/YJS7895_raw.mak
      make -C /data/projet4/data/smartdenovo/YJS7895_raw/ -f data/smartdenovo/YJS7895_raw/YJS7895_raw.mak
      ```
    - **Commande pour la souche 8039 :**  
      ```bash
      /data/projet4/conda/masson/flye_env/bin/smartdenovo.pl -t 4 -p YJS8039_raw -c 1 /data/projet4/data/raw/LongReads/Corrected/YJS7895_1n_correctedLR.fasta.gz > data/smartdenovo/YJS8039_raw/YJS8039_raw.mak
      make -C /data/projet4/data/smartdenovo/YJS8039_raw/ -f /data/projet4/data/smartdenovo/YJS8039_raw/YJS8039_raw.mak
      ```
    - **Lancement des souches YJS8039 non filtré et YJS7895, YJS8039 filtré avec le script de Céline.**

* **Calcul de la longueur des scaffolds et génération du plot avec R** : *(Adeline)*  
    - **Commande :**  
      ```bash
      awk '/^>/ {if (NR>1) print length(seq); seq=""; next} {seq = seq $0} END {print length(seq)}' /data/projet4/data/smartdenovo/YJS7890_raw/YJS7890_raw.dmo.cns.fasta > data/smartdenovo/YJS7890_raw/scaffold_lengths.txt
      ```
    - **Plot avec R :**  
      ```R
      scaffold_lengths <- read.table("scaffold_lengths.txt")$V1
      png("/data/projet4/data/length_plot_data/smartdenovo_scaffold_size_distribution.png")
      hist(scaffold_lengths, breaks=100)
      dev.off()
      ```


## 09/11 :

* **Installation de Racon sur l'environnement conda flye_env** : *(Adeline)*  
    - **Commande :**  
      ```bash
      conda install bioconda::racon
      ```
    - **Version :** v1.4.3

## 11/11 :

* **Installation de Minimap2 et de Samtools sur l'environnement conda flye_env** : *(Adeline)*  
    - **Commande pour Minimap2 :**  
      ```bash
      conda install bioconda::minimap2
      ```
    - **Version :** 2.22  
    - **Commande pour Samtools :**  
      ```bash
      conda install bioconda::samtools
      ```
    - **Version :** 1.5

* **Utilisation de Minimap2** : *(Adeline)*  
    - **Pour Smartdenovo :**  
      - **Commande :**  
        ```bash
        minimap2 -ax asm5 -t 4 /data/projet4/data/raw/brbr.fasta /data/projet4/data/smartdenovo/YJS7890_filtered/YJS7890_filtered.dmo.cns.fasta > /data/projet4/data/minimap/smartdenovo/alignement_YJS7890.sam
        ```

## 18/11 :

* **Installation de Mummer dans l'environnement flye_env** : *(Adeline)*  
    - **Commande :**  
      ```bash
      conda install bioconda::mummer
      ```
    - **Version :** 3.23

* **Création d'un environnement conda pour Busco** : *(Céline)*  
    - **Commande :**  
      ```bash
      conda create -p /data/projet4/conda/masson/busco_env
      conda install -c conda-forge -c bioconda busco=5.8.0
      ```

* **Test de BUSCO avec l'assemblage 7890_filtered de Flye** : *(Céline)*  
    - **Commande :**  
      ```bash
      nohup busco -i /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta -o busco_flye_7890_filtered -l fungi_odb10 -m genome &
      ```
    - **Commentaire :** La librairie utilisée pour cela est la librairie des fungi (`fungi_odb10`).

## 19/11 :

* **Nouvelle tentative BUSCO** : *(Céline)*  
    - **Commande :**  
      ```bash
      nohup busco -i /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta -o busco_flye_7890_filtered -l fungi_odb10 -m genome &
      ```

* **Tentative de Racon** : *(Céline)*  
    - **Commande minimap2 :**  
      ```bash
      minimap2 -ax sr -t 4 /data/projet4/data/raw/ShortReads/YJS7890_Teq_1.fq.gz \
      /data/projet4/data/raw/ShortReads/YJS7890_Teq_2.fq.gz \
      /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta \
      | gzip > /data/projet4/data/minimap/alignements_7890_minimap.sam.gz
      ```
    - **Commentaire :**  
      Au début, on a essayé sans mettre un fichier `.sam` zippé en output, mais une erreur est apparue :  
      `[ERROR] failed to write the results: No space left on device`, ce qui indique qu'il n'y avait pas assez de place. Le problème a été résolu en compressant le fichier de sortie avec `gzip`.

* **Tentative MUMmer** : *(Céline)*  
    - **Commande :**  
      ```bash
      nucmer --prefix=alignment /data/projet4/data/smartdenovo/YJS7890_filtered/YJS7890_filtered.dmo.cns.fasta /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta
      mummerplot -terminal --png --layout --prefix=alignment alignment.delta
      ```
    - **Autre commande :**  
      ```bash
      mummer -mum -b -c data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta data/smartdenovo/YJS7890_filtered/YJS7890_filtered.dmo.cns.fasta > data/mummer/mummer_flye_smart_YJS7890.mums
      mummerplot -postscript -p mummer data/mummer/mummer_flye_smart_YJS7890.mums
      ```

## 20/11 :

* **Installation de Mummer et Gnuplot dans l'environnement Busco** : *(Céline)*  
    - **Mummer :**  
      ```bash
      conda install bioconda::mummer
      ```
      - **Version :** 3.23  
    - **Gnuplot :**  
      ```bash
      conda install conda-forge::gnuplot
      ```
      - **Version :** 5.4.10

## 21/11 :

* **Installation de BWA et Blast dans l'environnement flye_env** : *(Adeline)*  
    - **BWA :**  
      ```bash
      conda install bioconda::bwa
      ```
      - **Version :** 0.7.17  
    - **Blast :**  
      Blast est déjà installé sur le serveur avec la version 2.12.0.

* **Génération de fichier SAM avec BWA** : *(Céline)*  
    - **Commande :**  
      ```bash
      bwa index /data/projet4/data/raw/brbr.fasta
      bwa mem /data/projet4/data/raw/brbr.fasta /data/projet4/data/raw/ShortReads/YJS7890_Teq_1.fq.gz /data/projet4/data/raw/ShortReads/YJS7890_Teq_2.fq.gz > /data/projet4/data/bwa/7890_bwa.sam
      ```

* **Concaténation des fichiers Illumina** : *(Céline)*  
    - **Commande pour concaténer :**  
      ```bash
      cat YJS7890_Teq_1.fq.gz YJS7890_Teq_2.fq.gz > illumina_7890.fq.gz
      ```
    - **Décompression :**  
      ```bash
      gzip -d illumina_7895.fq.gz
      ```

* **Re-test avec Racon et ce fichier SAM** : *(Céline & Adeline)*  
    - **Commande :**  
      ```bash
      racon /data/projet4/data/raw/ShortReads/illumina_7890.fq.gz /data/projet4/data/bwa/7890_bwa.sam /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta > /data/projet4/data/racon/racon_output.fasta
      ```

## 23/11 :

* **Téléchargement des fichiers BUSCO réalisés par Mme. Friedrich** : *(Adeline)*

* **Concaténation de tous les fichiers Illumina et renommage de `/1` en `:1`** : *(Adeline)*  
    - **Commande :**  
      ```bash
      zcat illumina_7890.fq.gz | sed '/^@/s|/1$|:1|; /^@/s|/2$|:2|' | gzip > illumina_7890_rename.fq.gz
      ```

* **Re-génération du fichier SAM avec BWA** : *(Adeline)*  
    - **Commande :**  
      ```bash
      bwa index data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta
      bwa mem /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta /data/projet4/data/raw/ShortReads/illumina_7890_rename.fq.gz > /data/projet4/data/bwa/7890_bwa.sam
      ```

* **Polishing avec Racon** : *(Adeline)*  
    - **Commande :**  
      ```bash
      racon /data/projet4/data/raw/ShortReads/illumina_7890_rename.fq.gz /data/projet4/data/bwa/7890_bwa.sam /data/projet4/data/flye/YJS7890_output/YJS7890_filtered/assembly_7890_filtered.fasta > /data/projet4/data/racon/racon_7890_flye.fasta
      ```

* **Réalisation de MUMMER plot via Galaxy** : *(Céline)*  
    - **Outil :** Mummer  
    - **Paramètres :**
        - **Référence Sequence :** fichier smartdenovo (assemblage fasta)
        - **Query Sequence :** fichier flye (assemblage fasta)
        - **Minimum Match Length :** 2500, 3000 ou 5000  
    - **Commentaire :**  
      Des tests ont été réalisés avec différentes options pour MUMmer (changement d'anchoring avec `-mumreference` ou `-mum`, ajustement de la longueur de rupture à 100...), mais cela n'a pas induit de différences notables sur les plots.

* **Test avec Nanostat des fichiers Racon** : *(Adeline)*  
    - **Commande :**  
      ```bash
      NanoStat --fasta /data/projet4/data/racon/racon_7890_flye.fasta --outdir data/resume_reads/ --name racon_7890_flye_resume.tsv
      ```

## 24/11 :

* **Génération des plots de BUSCO** : *(Adeline)*  
    - **Commande :**  
      - Copier tous les fichiers `short_summary.txt` dans un dossier et ensuite utiliser le script `generate_plot.py` fourni par BUSCO :
      ```bash
      cp data/busco/flyeAssemblies_busco/busco_flye_7890_filtered/short_summary.*.txt data/busco/BUSCO_summaries/
      python3 conda/masson/busco_env/bin/generate_plot.py -wd data/busco/BUSCO_summaries/
      ```

* **Test avec Blast** : *(Adeline)*  
    - **Commande :**  
      ```bash
      tblastn -query data/raw/brettAllProt_ref2n.fasta -subject data/racon/racon_7890_flye.fasta -out data/blast/tblastn_7890_flye.txt -evalue 1e-5 -outfmt 6
      ```

## 27/11 :

* **Test de la nouvelle commande pour Blast** : *(Adeline)*  
    - **Commande :**  
      ```bash
      tblastn -query data/raw/brettAllProt_ref2n.fasta -subject data/racon/racon_7890_flye.fasta -out data/blast/tblastn_7890_flye.txt -evalue 1e-5 -outfmt "6 qseqid qlen sseqid slen pident length qstart qend sstart send evalue"
      ```

* **Tri des résultats de Blast en fonction du %ID et de la longueur minimum** : *(Adeline)*  
    - **Commande :**  
      ```bash
      cat data/blast/tblastn_7890_flye.txt | awk '$5>80 && $2>500 {print $0}' > data/blast/tblastn_sort_7890_flye.txt
      ```

## 28/11 :

* **Re-test de la commande de tri de Blast en se basant sur le pourcentage de couverture** : *(Céline et Adeline)*  
    - **Commande :**  
      ```bash
      cat data/blast/tblastn_7890_flye.txt | awk '$5>80 && ($6/$2*100)>90 {print $0}' > data/blast/tblastn_sort_7890_flye.txt
      ```

* **Création d'un tableau présence/absence pour les protéines** : *(Adeline)*  
    - **Code R :**  
      ```r
      tblastn_data <- read.table("data/blast/tblastn_sort_7890_flye.txt", header = FALSE, sep = "\t")
      proteins_found <- tblastn_data$V1

      ref_data <- readLines("data/raw/brettAllProt_ref2n.fasta")
      protein_ref <- ref_data[grep("^>", ref_data)]
      protein_ref <- gsub("^>", "", protein_ref)

      presence <- c()
      for (protein in protein_ref) {
        if (protein %in% proteins_found) {
          presence <- c(presence, TRUE)
        } else {
          presence <- c(presence, FALSE)
        }
      }

      presence_absence <- data.frame("Protein" = protein_ref, "YJS7890" = presence)
      ```

* **Génération des fichiers YAML pour les environnements conda** : *(Céline)*  
    - **Commande : exemple pour l'environnnement BUSCO**  
      ```bash
      conda env export > packages_busco_env.yml
      ```