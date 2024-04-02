#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate snpxplex

TARGET='/media/Data1/jbogoin/ref/cibles_panels_NG/Spatax_CMT_v1_cibles_20210329.bed'

echo ""
echo "depth.sh start!"
echo ""

#Couverture totale a chaque position du bed
for bam_name in *.dedup.bam; \
do SAMPLE=${bam_name%%.dedup.bam}; \

samtools depth \
    -a $bam_name \
    -b $TARGET \
    -o $SAMPLE_depth.txt \
    -q 0;

done

echo ""
echo "depth.sh job done!"
echo ""


