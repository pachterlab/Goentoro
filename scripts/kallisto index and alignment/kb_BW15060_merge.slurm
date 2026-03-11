#!/bin/bash
#SBATCH --job-name=kb_v4_BW15060_laneMerge
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --partition=gpu
#SBATCH --gres=gpu:p100:1
#SBATCH --array=0-3%1
#SBATCH --output=kb_v4_BW15060_laneMerge_%A_%a.log
#SBATCH --error=kb_v4_BW15060_laneMerge_%A_%a.err

set -euo pipefail

FASTQ_DIR="/resnick/groups/GoentoroLab/LiY/illumina/20251219_LH00416_0351_A235NNKLT4/BW15060"
IDX="/resnick/groups/GoentoroLab/LiY/dmel_r6_115/kallisto_nac_index/dmel_r6_115.idx"
T2G="/resnick/groups/GoentoroLab/LiY/dmel_r6_115/kallisto_nac_index/t2g.txt"
OUT_BASE="/resnick/groups/GoentoroLab/LiY/illumina/kb_out_v4"

SAMPLES=( \
  "Goentoro_Nov6FTC_S1" \
  "Goentoro_Nov6PAT_S2" \
  "Goentoro_Nov24FTC_S3" \
  "Goentoro_Nov24PAT_S4" \
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
