#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate gatk_env

echo ""
echo "complexity.sh start"
echo ""

for bam_name in *.bam; \

do SAMPLE=${bam_name%%.bam} \

echo $SAMPLE; \

gatk EstimateLibraryComplexity \
    -I $bam_name \
    -O $SAMPLE_lib_complex_metrics.txt;

done

echo ""
echo "complexity.sh job done!"
echo ""