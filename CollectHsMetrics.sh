#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate gatk_env

echo ""
echo "metrics.sh start"
echo ""


REF='/media/Data1/jbogoin/ref/fa_hg19/hg19_std/hg19_std.fa'
# BAIT='/media/Data1/jbogoin/ref/SNPXPlex/snps.interval_list'
# BAIT='/media/Data1/jbogoin/ref/gencode/gencodehg19.ready.target.interval_list'
BAIT='/media/Data1/jbogoin/ref/cibles/Spatax_CMT_v1_cibles_20210329.interval_list'

# gatk BedToIntervalList \
#     -I /media/Data1/jbogoin/ref/SNPXPlex/snps.bed \
#     -O /media/Data1/jbogoin/ref/SNPXPlex/snps.interval_list \
#     -SD '/media/Data1/jbogoin/ref/fa_hg19/hg19_std/hg19_std.dict'

for bam_name in *.dedup.bam; \

do SAMPLE=${bam_name%%.dedup.bam} \

    echo $SAMPLE; \

    gatk CollectHsMetrics \
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
