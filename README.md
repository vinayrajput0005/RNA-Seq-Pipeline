# RNA-Seq Pipeline

This repository contains scripts for RNA-Seq analysis, including preprocessing and differential expression analysis using DESeq2.

## Pipeline Overview

The RNA-Seq pipeline is designed to process transcriptomic data from raw sequencing reads to identifying differentially expressed genes (DEGs). It automates key steps, ensuring accuracy, reproducibility, and efficiency in gene expression analysis. The pipeline consists of two main steps:

### **Step 1: Preprocessing**
Preprocessing ensures high-quality input data by performing quality control, trimming, alignment, and quantification. The pipeline starts with `FastQC` for quality assessment, detecting adapter contamination and sequencing artifacts. `Trimmomatic` is then used to trim low-quality bases and adapters, improving read quality.

The processed reads are aligned to a reference genome using `HISAT2`, a splice-aware aligner optimized for RNA-Seq data. The resulting BAM files store mapped sequencing reads, which are further processed using `featureCounts` to generate a count matrix representing gene expression levels across samples.

### **Step 2: Differential Expression Analysis**
Once count data is available, `DESeq2` in R is used to identify DEGs. The pipeline first loads the count matrix and sample metadata, ensuring proper condition annotation. Low-expression genes are filtered out to improve statistical power and reduce noise.

`DESeq2` normalizes the data and applies a negative binomial model to detect significant changes in gene expression between experimental conditions. The output includes fold-change values, p-values, and adjusted p-values to account for multiple testing.

To aid result interpretation, the pipeline generates visualizations such as MA plots, highlighting differentially expressed genes. These insights help researchers identify key biological pathways and regulatory mechanisms underlying observed conditions.

### **Why Use This Pipeline?**
This RNA-Seq pipeline integrates quality control, alignment, quantification, and statistical analysis into a structured workflow, ensuring reliable and reproducible results. Whether analyzing disease progression, drug responses, or environmental impacts on gene expression, this pipeline provides a robust framework for transcriptomic research.

## Requirements

- **Preprocessing:** Requires `fastqc`, `trimmomatic`, `hisat2`, and `featureCounts`.
- **Differential Expression:** Requires `R` with `DESeq2` and `tidyverse` libraries.

## Usage

### Preprocessing
Run the following command to execute the preprocessing script:
```bash
bash 1_preprocessing.sh
```

### Differential Expression Analysis
Run the R script using:
```r
Rscript 2_differential_expression.R
```

Ensure `counts_data.csv` and `sample_info.csv` are present in the specified directory before running the script.

## Outputs

- **Preprocessing:**
  - Trimmed FASTQ files.
  - BAM alignment files.
  - Read count matrix.
- **Differential Expression:**
  - DESeq2 results.
  - MA plot for visualization.

## Citation
If you use this pipeline, please cite the appropriate tools and references for RNA-Seq analysis.

## License
This project is open-source under the MIT License.

