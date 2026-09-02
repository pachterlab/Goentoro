#!/bin/bash

set -euo pipefail

echo "[$(date)] Start kb ref (nac)"

export PATH=$HOME/.local/bin:$PATH

BASE="/your/path"

GENOME="${BASE}/Drosophila_melanogaster.BDGP6.54.dna.toplevel.fa"
GTF="${BASE}/Drosophila_melanogaster.BDGP6.54.115.gtf"

OUTDIR="${BASE}/kb_ref_nac"

mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

echo "BASE=${BASE}"
echo "GENOME=${GENOME}"
echo "GTF=${GTF}"
echo "OUTDIR=${OUTDIR}"

echo "[$(date)] Versions"
kb --version || true
kallisto version || true
bustools version || true

echo "[$(date)] Running kb ref --workflow nac"

kb ref \
  --workflow nac \
  -i dmel_r6_115.idx \
  -g t2g.txt \
  -c1 cdna.txt \
  -c2 nascent.txt \
  -f1 cdna.fasta \
  -f2 nascent.fasta \
  "${GENOME}" \
  "${GTF}"

echo "[$(date)] Sanity check outputs"
ls -lah dmel_r6_115.idx t2g.txt cdna.fasta nascent.fasta

echo "[$(date)] Done kb ref (nac)"
