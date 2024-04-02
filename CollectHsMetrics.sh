#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate gatk4

echo ""
echo "metrics.sh start"
echo ""

# hg19
# REF='/media/jbogoin/Data1/References/fa_hg19/hg19_std_M-rCRS_Y-PAR-mask.fa'
# BAIT='/media/jbogoin/Data1/References/cibles_panels_NG/cibles_neuro_01032022.interval_list'

#hg38
REF='/media/jbogoin/Data1/References/fa_hg38/hg38-rnaseq/GRCh38.primary_assembly.genome.fa'
BAIT='/media/jbogoin/Data1/References/cibles_panels_NG/cibles_neuro_liftoverhg38_17052022.interval_list'

# gatk BedToIntervalList \
#     -I /media/Data1/jbogoin/ref/SNPXPlex/snps.bed \
#     -O /media/Data1/jbogoin/ref/SNPXPlex/snps.interval_list \
#     -SD '/media/Data1/jbogoin/ref/fa_hg19/hg19_std/hg19_std.dict'

for bam_name in *.bam; \

do SAMPLE=${bam_name%%.bam}; \

    gatk CollectHsMetrics \
    --java-options "-Xmx4G" \
    -I $bam_name \
    -O $SAMPLE.output_hs_metrics.txt \
    -R $REF \
    --BAIT_INTERVALS $BAIT \
    --TARGET_INTERVALS $BAIT \
    --PER_TARGET_COVERAGE $SAMPLE.per_target_coverage.txt; \

done

echo ""
echo "metrics.sh job done!"
echo ""
