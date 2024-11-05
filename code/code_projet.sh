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
