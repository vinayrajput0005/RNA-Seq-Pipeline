#!/bin/bash

SECONDS=0

# Set working directory
WORKDIR="/Users/vr/Desktop/RNA_Seq"
cd "$WORKDIR" || { echo "Directory not found! Exiting."; exit 1; }

# Define file paths
RAW_FASTQ="data/demo.fastq"
TRIMMED_FASTQ="data/demo_trimmed.fastq"
OUT_DIR="data"
HISAT2_INDEX="HISAT2/grch38/genome"
GTF_FILE="../hg38/Homo_sapiens.GRCh38.106.gtf"
BAM_FILE="HISAT2/demo_trimmed.bam"
COUNT_FILE="quants/demo_featurecounts.txt"

# Step 1: Run FastQC
echo "Running FastQC on raw data..."
fastqc "$RAW_FASTQ" -o "$OUT_DIR" || { echo "FastQC failed!"; exit 1; }

# Step 2: Run Trimmomatic
echo "Running Trimmomatic..."
trimmomatic SE -threads 4 "$RAW_FASTQ" "$TRIMMED_FASTQ" TRAILING:10 -phred33 || { echo "Trimmomatic failed!"; exit 1; }
echo "Trimmomatic finished!"

# Run FastQC again on trimmed data
fastqc "$TRIMMED_FASTQ" -o "$OUT_DIR" || { echo "FastQC failed!"; exit 1; }

# Step 3: Run HISAT2 alignment
echo "Running HISAT2..."
hisat2 -q --rna-strandness R -x "$HISAT2_INDEX" -U "$TRIMMED_FASTQ" | samtools sort -o "$BAM_FILE" || { echo "HISAT2 failed!"; exit 1; }
echo "HISAT2 finished!"

# Step 4: Run featureCounts
echo "Running featureCounts..."
featureCounts -S 2 -a "$GTF_FILE" -o "$COUNT_FILE" "$BAM_FILE" || { echo "featureCounts failed!"; exit 1; }
echo "featureCounts finished!"

# Display elapsed time
duration=$SECONDS
echo "Pipeline completed in $(($duration / 60)) minutes and $(($duration % 60)) seconds."
