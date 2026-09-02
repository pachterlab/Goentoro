# Goentoro

This repository contains code used for the single-nucleus RNA-sequencing analysis presented in the manuscript **“Early injury responses to nutrient treatment in adult Drosophila limb.”**

Raw sequencing data are available through NCBI BioProject **PRJNA1521539**.

## Analysis workflow

### 1. Alignment and quantification

`kb_ref_nac.sh` generates the kallisto reference index using kb-python (v0.29.5) with the *Drosophila melanogaster* BDGP6.54 genome FASTA and corresponding GTF annotation.

`kb_align.slurm` performs alignment and quantification using kallisto (v0.51.1) with the 10x Genomics v4 chemistry configuration. FASTQ files from two sequencing lanes are processed together for each sample.

## 2. Quality control, clustering, and pseudobulk preparation

`QCplots.ipynb` contains quality-control visualization of the single-nucleus RNA-seq datasets, including distributions of UMI counts, detected genes, mitochondrial content, rRNA content.

`filter_clustering.ipynb` contains the main downstream analysis performed in Scanpy (v1.10.3), including:

* quality-control filtering
* Scrublet doublet removal
* normalization and highly variable gene selection
* PCA and neighborhood construction
* UMAP visualization
* Leiden clustering
* cluster marker identification
* preparation of sample-level pseudobulk count matrices

Cells were required to have at least 500 UMIs, at least 200 detected genes, and <5% mitochondrial content. Genes detected in fewer than three cells were excluded. Cells with a Scrublet doublet score >0.3 were removed.

### 3. Differential expression analysis

`DESeq2_analysis.R`

Differential gene expression analysis of pseudobulk count matrices was performed using DESeq2 (v1.34.0).

### 4. Gene Ontology analysis

`GO_analysis.R`

GO enrichment analysis was performed using clusterProfiler (v4.2.2), with the background defined as all genes expressed in the analyzed cells. GO-term similarity clustering was performed using rrvgo (v1.6.0).
