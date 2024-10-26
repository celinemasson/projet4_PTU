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
            version : 1.13

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
