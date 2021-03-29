#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate gatk_env

echo ""
echo "metrics.sh start"
echo ""


#REF='/media/jbogoin/Data1/jbogoin/ref/hg19_ref/hg19_std.fa'
REF='/media/Data1/jbogoin/ref/hg19_ref/hg19_ssM/genome_hg19_ssM.fa'
# BAIT='/media/Data1/jbogoin/ref/SNPXPlex/snps.interval_list'
BAIT='/media/Data1/jbogoin/ref/gencode/gencodehg19.ready.target.interval_list'

# gatk BedToIntervalList \
#     -I /media/Data1/jbogoin/ref/SNPXPlex/snps.bed \
#     -O /media/Data1/jbogoin/ref/SNPXPlex/snps.interval_list \
#     -SD '/media/jbogoin/Data1/jbogoin/ref/hg19_ref/hg19_std.fa.gz.dict'

for bam_name in *.dedup.bam; \

do SAMPLE=${bam_name%%.dedup.bam} \

    gatk CollectHsMetrics \
        -I $bam_name \
        -O $SAMPLE.output_hs_metrics.txt \
        -R $REF \
        --BAIT_INTERVALS $BAIT \
        --TARGET_INTERVALS $BAIT \
        # --PER_TARGET_COVERAGE $SAMPLE.per_target_coverage.txt

done

echo ""
echo "metrics.sh job done!"
echo ""