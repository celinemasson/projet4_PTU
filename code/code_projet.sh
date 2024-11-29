### Creation of environments
## flye,smartdenovo and seqkit
conda create -n flye_env -c bioconda flye
conda rename -p /home/masson/.conda/envs/flye_env /data/projet4/conda/masson/flye_env
conda activate /data/projet4/conda/masson/flye_env
conda install -c bioconda seqkit
conda install bioconda::smartdenovo

## nanostat and R
conda create -p conda/gagnon/nanostat_env python==3.7
conda activate /data/projet4/conda/gagnon/nanostat_env
conda install -c bioconda nanostat
conda install -c conda-forge r
conda install -c conda-forge r-diagrammer


### Copy of the data
mkdir -p data/raw
cp /home/friedrich/* data/raw/


### Nanostat
## Use Nanostat to extract metrics
mkdir -p data/resume_reads

# output in text format
for specie in YJS7890 YJS7895 YJS8039; do
    # output in text format
    NanoStat --fasta data/raw/LongReads/Corrected/${specie}_1n_correctedLR.fasta.gz --outdir data/resume_reads --name ${specie}_1n_resume
    # tsv format for calculation
    NanoStat --fasta data/raw/LongReads/Corrected/${specie}_1n_correctedLR.fasta.gz --outdir data/resume_reads --name ${specie}_1n_resume_tsv --tsv
done

## Merge files into a single file with R
R
# read file and stock in a variable
data_YJS7890 <- read.table("data/resume_reads/YJS7890_1n_resume_tsv", header = TRUE, col.names = c("Metrics", "dataset_YJS7890"))
data_YJS7895 <- read.table("data/resume_reads/YJS7895_1n_resume_tsv", header = TRUE, col.names = c("Metrics", "dataset_YJS7895"))
data_YJS8039 <- read.table("data/resume_reads/YJS8039_1n_resume_tsv", header = TRUE, col.names = c("Metrics", "dataset_YJS8039"))

# merge files and add a line for the depth
merged_data <- cbind(data_YJS7890["Metrics"], data_YJS7890["dataset_YJS7890"], data_YJS7895["dataset_YJS7895"], data_YJS8039["dataset_YJS8039"])
merged_data <- rbind(merged_data, list(Metrics = "depth", dataset_YJS7890 = 16.4829,dataset_YJS7895 = 25.5730, dataset_YJS8039 = 29.7364))

# write the resume file in "data/resume_reads/resume_reads.tsv"
write.table(merged_data, "data/resume_reads/resume_reads.tsv", sep = "\t", quote = FALSE, row.names = FALSE)

q()
n


### File filtering
mkdir data/data_modified

# delete sequences of less than 1000 bp
for specie in YJS7890 YJS7895 YJS8039; do
    echo $specie
    seqkit seq -m 1000 /data/projet4/data/raw/LongReads/Corrected/${specie}_1n_correctedLR.fasta.gz | gzip > /data/projet4/data/data_modified/LongReads_wo_1000/filtered_${specie}_1n_correctedLR.fasta.gz
done


### Assembling genomes with filtered data

## flye
for specie in YJS7890 YJS7895 YJS8039; do
    echo $specie
	mkdir -p data/flye/${specie}_output/${specie}_filtered
    nohup flye --nano-corr /data/projet4/data/data_modified/LongReads_wo_1000/filtered_${specie}_1n_correctedLR.fasta.gz --out-dir /data/projet4/data/flye/${specie}_output/${specie}_filtered --genome-size 13m --threads 4 > /data/projet4/data/flye/${specie}_output/flye_output_${specie}_raw.log 2>&1 &
    NanoStat --fasta /data/projet4/data/flye/${specie}_output/${specie}_filtered/assembly.fasta --outdir /data/projet4/data/resume_reads/ --name ${specie}_flye_filteredassembly_resume
done

## smartdenovo
for specie in YJS7890 YJS7895 YJS8039; do
    echo $specie
    mkdir -p data/smartdenovo/${specie}_filtered
    # perfom smartdenovo
    /data/projet4/conda/masson/flye_env/bin/smartdenovo.pl -t 2 -p ${specie}_filtered -c 1 /data/projet4/data/data_modified/LongReads_wo_1000/filtered_${specie}_1n_correctedLR.fasta.gz > data/smartdenovo/${specie}_filtered/${specie}_filtered.mak
    make -C /data/projet4/data/smartdenovo/${specie}_filtered/ -f /data/projet4/data/smartdenovo/${specie}_filtered/${specie}_filtered.mak
    # convert cns file into fasta file
    cp data/smartdenovo/${specie}_filtered/${specie}_filtered.dmo.cns data/smartdenovo/${specie}_filtered/${specie}_filtered.dmo.cns.fasta
    # make a resume file with statistic of assembly
    NanoStat --fasta /data/projet4/data/smartdenovo/${specie}_filtered/${specie}_filtered.dmo.cns.fasta --outdir /data/projet4/data/resume_reads/ --name ${specie}_smartdenovo_filteredassembly_resume
done


### Calculating the length of scaffold
for specie in YJS7890 YJS7895 YJS8039; do
    awk '/^>/ {if (NR>1) print length(seq); seq=""; next} {seq = seq $0} END {print length(seq)}' /data/projet4/data/smartdenovo/${specie}_filtered/${specie}_filtered.dmo.cns.fasta > data/smartdenovo/${specie}_filtered/scaffold_lengths_${specie}_filtered.txt
    awk '/^>/ {if (NR>1) print length(seq); seq=""; next} {seq = seq $0} END {print length(seq)}' /data/projet4/data/flye/${specie}_output/${specie}_filtered/assembly_${specie#YJS}_filtered.fasta > data/flye/${specie}_output/${specie}_filtered/scaffold_lengths_${specie}_filtered.txt
done

## Plot the length of the scaffold
mkdir -p data/length_plot_data/

R
species<-c("YJS7890", "YJS7895", "YJS8039")
for (specie in species) {
    scaffold_file <- paste0("data/smartdenovo/",specie,"_filtered/scaffold_lengths_",specie,"_filtered.txt")
    scaffold_lengths <- read.table(scaffold_file)$V1
    png_file <- paste0("/data/projet4/data/length_plot_data/smartdenovo_scaffold_size_distribution_",specie,"_filtered.png")
    png(png_file)
    hist(scaffold_lengths, breaks=100)
    dev.off()
}

for (specie in species) {
    scaffold_file <- paste0("data/flye/",specie,"_output/",specie,"_filtered/scaffold_lengths_",specie,"_filtered.txt")
    scaffold_lengths <- read.table(scaffold_file)$V1
    png_file <- paste0("/data/projet4/data/length_plot_data/flye_scaffold_size_distribution_",specie,"_filtered.png")
    png(png_file)
    hist(scaffold_lengths, breaks=100)
    dev.off()
}

q()
n


### Concate illumina file to use with bwa and racon
for specie in YJS7890 YJS7895 YJS8039; do
    cat ${specie}*_1.fq.gz ${specie}*_2.fq.gz > illumina_${specie#YJS}.fq.gz
    # replace "/1" by ":1" in the name
    zcat illumina_${specie#YJS}.fq.gz | sed '/^@/s|/1$|:1|; /^@/s|/2$|:2|' | gzip > illumina_${specie#YJS}_rename.fq.gz
done


### Generate sam file to use with Racon

## flye
for specie in YJS7890 YJS7895 YJS8039; do
    echo $specie
    # Perform BWA
    bwa index data/flye/${specie}_output/${specie}_filtered/assembly_${specie#YJS}_filtered.fasta
    bwa mem /data/projet4/data/flye/${specie}_output/${specie}_filtered/assembly_${specie#YJS}_filtered.fasta /data/projet4/data/raw/ShortReads/illumina_${specie#YJS}_rename.fq.gz > /data/projet4/data/bwa/bwa_${specie#YJS}_flye.sam
    # Perform Racon
    racon /data/projet4/data/raw/ShortReads/illumina_${specie#YJS}_rename.fq.gz /data/projet4/data/bwa/bwa_${specie#YJS}_flye.sam /data/projet4/data/flye/${specie}_output/${specie}_filtered/assembly_${specie#YJS}_filtered.fasta > /data/projet4/data/racon/racon_${specie#YJS}_flye.fasta
done

## smartdenovo
for specie in YJS7890 YJS7895 YJS8039; do
    echo $specie
    # Perform BWA
    bwa index data/smartdenovo/${specie}_filtered/${specie}_filtered.dmo.cns.fasta
    bwa mem /data/projet4/data/smartdenovo/${specie}_filtered/${specie}_filtered.dmo.cns.fasta /data/projet4/data/raw/ShortReads/illumina_${specie#YJS}_rename.fq.gz > /data/projet4/data/bwa/bwa_${specie#YJS}_smartdenovo.sam
    # Perform Racon
    racon /data/projet4/data/raw/ShortReads/illumina_${specie#YJS}_rename.fq.gz /data/projet4/data/bwa/bwa_${specie#YJS}_smartdenovo.sam /data/projet4/data/smartdenovo/${specie}_filtered/${specie}_filtered.dmo.cns.fasta > /data/projet4/data/racon/racon_${specie#YJS}_smartdenovo.fasta
done

## test with Nanostat
for specie in YJS7890 YJS7895 YJS8039; do
    echo $specie
    NanoStat --fasta /data/projet4/data/racon/racon_${specie#YJS}_flye.fasta --outdir data/resume_reads/ --name racon_${specie#YJS}_flye_resume.tsv
done

for specie in YJS7890 YJS7895 YJS8039; do
    echo $specie
    NanoStat --fasta /data/projet4/data/racon/racon_${specie#YJS}_smartdenovo.fasta --outdir data/resume_reads/ --name racon_${specie#YJS}_smartdenovo_resume.tsv
done


### Blast with a reference file
for specie in YJS7890 YJS7895 YJS8039; do
    echo $specie
    tblastn -query data/raw/brettAllProt_ref2n.fasta -subject data/racon/racon_${specie#YJS}_flye.fasta -out data/blast/tblastn_${specie#YJS}_flye.txt -evalue 1e-5 -outfmt "6 qseqid qlen sseqid slen pident length qstart qend sstart send evalue"
done

# Sort blast result with ID and length
for specie in YJS7890 YJS7895 YJS8039; do
    # Initialise treshold with a minimum %ID of 70 and %coverage of 70%
    ID=70
    cover=70
    cat data/blast/tblastn_${specie#YJS}_flye.txt | awk -vOFS='\t' -vID=$ID -vcover=$cover '$5>ID && ($6/$2*100)>cover {print $0}' > data/blast/tblastn_sort_${specie#YJS}_flye.txt
done

# Create table with presence or not of protein
R
# Initialise variable 
species <- c("7890", "7895", "8039")
ref_data <- readLines("data/raw/brettAllProt_ref2n.fasta")
# Identifie name of protein in the reference file with ">"
protein_ref <- ref_data[grep("^>", ref_data)]
# Delete the ">" to only have the name
protein_ref <- gsub("^>", "", protein_ref)
presence_absence <- data.frame("Protein" = protein_ref)

for (specie in species) {
    tblastn_path <- paste0("data/blast/tblastn_sort_",specie,"_flye.txt")
    tblastn_data <- read.table(tblastn_path, header = FALSE, sep = "\t")
    # Take the first colone of the blast result to have the name of proteins found
    proteins_found <- tblastn_data$V1

    presence <- c()
    for (protein in protein_ref) {
        if (protein %in% proteins_found) {
            presence <- c(presence, "presence")
        } else {
            presence <- c(presence, "absence")
        }
    }
    specie_name <- paste0("YJS", specie)
    presence_absence[[specie_name]] <- presence
}

output_path <- "data/blast/summary_protein.tsv"
write.table(presence_absence, file = output_path, sep = "\t", row.names = FALSE, quote = FALSE)
