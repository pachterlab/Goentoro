#!/bin/bash

#SBATCH --array=0-3%3
#SBATCH --output=kb_v4_laneMerge_%A_%a.log
#SBATCH --error=kb_v4_laneMerge_%A_%a.err

set -euo pipefail

FASTQ_DIR="/your/path/fastq"
IDX="/your/path/kb_ref_nac/dmel_r6_115.idx"
T2G="/your/path/kb_ref_nac/t2g.txt"
OUT_BASE="/your/path/kb_out_v4"

SAMPLES=( \
  "Goentoro_Dec15FTC_S1" \
  "Goentoro_Dec15PAT_S2" \
  "Goentoro_Dec22FTC_S3" \
  "Goentoro_Dec22PAT_S4" \
)

SAMPLE="${SAMPLES[$SLURM_ARRAY_TASK_ID]}"

R1_L1="${FASTQ_DIR}/${SAMPLE}_L001_R1_001.fastq.gz"
R2_L1="${FASTQ_DIR}/${SAMPLE}_L001_R2_001.fastq.gz"
R1_L2="${FASTQ_DIR}/${SAMPLE}_L002_R1_001.fastq.gz"
R2_L2="${FASTQ_DIR}/${SAMPLE}_L002_R2_001.fastq.gz"

for f in "$R1_L1" "$R2_L1" "$R1_L2" "$R2_L2"; do
  [[ -s "$f" ]] || { echo "Missing file: $f"; exit 2; }
done

export PATH="$HOME/.local/bin:$PATH"

OUTDIR="${OUT_BASE}/${SAMPLE}_laneMerged"
mkdir -p "${OUTDIR}"

kb count \
  -i "${IDX}" \
  -g "${T2G}" \
  -x 10xv4 \
  -o "${OUTDIR}" \
  --h5ad \
  --filter bustools \
  --overwrite \
  "${R1_L1}" "${R2_L1}" \
  "${R1_L2}" "${R2_L2}"
