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
TARGET='/media/Data1/jbogoin/ref/cibles/Spatax_CMT_v1_cibles_20210329.bed'


# gatk BedToIntervalList \
#     -I /media/Data1/jbogoin/ref/SNPXPlex/snps.bed \
#     -O /media/Data1/jbogoin/ref/SNPXPlex/snps.interval_list \
#     -SD '/media/Data1/jbogoin/ref/fa_hg19/hg19_std/hg19_std.dict'

for bam_name in *.dedup.bam; \

do SAMPLE=${bam_name%%.dedup.bam} \

echo $SAMPLE; \

# Alignment statistics
samtools flagstat $bam_name; \

# Coverage statistics

## Base coverage
gatk DepthOfCoverage \
-R $REF \
-I $bam_name \
-L $TARGET \
-o $SAMPLE.baseCoverage;

## Region and gene coverage
sort -k1,1 -k2,2n $SAMPLE.baseCoverage \
| groupBy -g 1,2,3,4 -c 6 -o mean > $SAMPLE.coverage;
    
done

echo ""
echo "metrics.sh job done!"
echo ""
