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
mkdir data/raw
cp /home/friedrich/* data/raw/


### Nanostat
## Use Nanostat to extract metrics
mkdir data/resume_reads

# output in text format
NanoStat --fasta data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz --outdir data/resume_reads --name YJS7890_1n_resume
NanoStat --fasta data/raw/LongReads/Corrected/YJS7895_1n_correctedLR.fasta.gz --outdir data/resume_reads --name YJS7895_1n_resume
NanoStat --fasta data/raw/LongReads/Corrected/YJS8039_1n_correctedLR.fasta.gz --outdir data/resume_reads --name YJS8039_1n_resume

# tsv format for calculation (with --tsv)
NanoStat --fasta data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz --outdir data/resume_reads --name YJS7890_1n_resume_tsv --tsv
NanoStat --fasta data/raw/LongReads/Corrected/YJS7895_1n_correctedLR.fasta.gz --outdir data/resume_reads --name YJS7895_1n_resume_tsv --tsv
NanoStat --fasta data/raw/LongReads/Corrected/YJS8039_1n_correctedLR.fasta.gz --outdir data/resume_reads --name YJS8039_1n_resume_tsv --tsv

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


### File filtering
mkdir data/data_modified

# delete sequences of less than 1000 bp
seqkit seq -m 1000 /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz | gzip > /data/projet4/data/data_modified/LongReads_wo_1000/filtered_YJS7890_1n_correctedLR.fasta.gz

# and without the gaps
seqkit seq -m 1000 -g /data/projet4/data/raw/LongReads/Corrected/YJS7890_1n_correctedLR.fasta.gz | gzip > /data/projet4/data/data_modified/LongReads_wo_1000/nogap_filtered_YJS7890_1n_correctedLR.fasta.gz

