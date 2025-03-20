# Load necessary libraries
suppressPackageStartupMessages({
  library(DESeq2)
  library(tidyverse)
})

# Define data directory
data_dir <- "~/Desktop/demo/DESeq2_tutorial/data"

# Read in counts data
counts_file <- file.path(data_dir, "counts_data.csv")
sample_info_file <- file.path(data_dir, "sample_info.csv")

# Check if files exist before proceeding
if (!file.exists(counts_file) | !file.exists(sample_info_file)) {
  stop("Error: One or both data files are missing!")
}

# Load data
counts_data <- read.csv(counts_file, row.names = 1)  # Ensure gene names are row names
colData <- read.csv(sample_info_file, row.names = 1)  # Ensure sample names are row names

# Check column names match row names in colData
if (!all(colnames(counts_data) %in% rownames(colData))) {
  stop("Error: Mismatch between column names in counts data and row names in sample info.")
}

# Ensure same order
colData <- colData[colnames(counts_data), , drop = FALSE]

# Create DESeq2 dataset
dds <- DESeqDataSetFromMatrix(countData = counts_data,
                              colData = colData,
                              design = ~ dexamethasone)

# Pre-filtering (remove low count genes)
dds <- dds[rowSums(counts(dds)) >= 10, ]

# Set factor levels
dds$dexamethasone <- relevel(dds$dexamethasone, ref = "untreated")

# Run DESeq
dds <- DESeq(dds)

# Get results
res <- results(dds)
res0.01 <- results(dds, alpha = 0.01)

# Summarize results
summary(res)
summary(res0.01)

# Check available result names
resultsNames(dds)

# Contrast Example
res_contrast <- results(dds, contrast = c("dexamethasone", "treated_4hrs", "untreated"))

# MA Plot
plotMA(res, main = "MA Plot of Differential Expression", ylim = c(-5, 5))
