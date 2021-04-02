#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastqc

echo ""
echo "fastqc.sh start"
echo ""

for f in *.fastq.gz; do fastqc $f; done

echo ""
echo "fastqc.sh job done!"
echo ""