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

TARGET='/media/Data1/jbogoin/ref/cibles_panels_NG/Spatax_CMT_v1_cibles_20210329.bed'

# gatk BedToIntervalList \
#     -I /media/Data1/jbogoin/ref/SNPXPlex/snps.bed \
#     -O /media/Data1/jbogoin/ref/SNPXPlex/snps.interval_list \
#     -SD '/media/Data1/jbogoin/ref/fa_hg19/hg19_std/hg19_std.dict'

ls *.dedup.bam > input_bams.list

for bam_name in *.dedup.bam; \

do SAMPLE=${bam_name%%.dedup.bam} \

echo $SAMPLE; \

# Alignment statistics
samtools flagstat $bam_name > $SAMPLE.flagstat.txt; \

# Coverage statistics

## Base coverage
#1 file
# gatk DepthOfCoverage \
# 	-R $REF \
# 	-I input_bams.list \
# 	-L $TARGET \
# 	-O file_name_base;

#per sample
gatk DepthOfCoverage \
 	-R $REF \
 	-I $bam_name \
 	-L $TARGET \
 	-O $SAMPLE.baseCoverage;

#remplacer les virgules par des tabulations
sed 's/','/\t/g' $SAMPLE.baseCoverage > $SAMPLE.tab.baseCoverage;

## Region and gene coverage
sort -k1,1 -k2,n $SAMPLE.tab.baseCoverage \
 | groupBy -g 1,2,3 -c 4 -o mean > $SAMPLE.coverage;

##  Coverage below 30x
samtools view -b -f 0x2 -F 0x400 $bam_name \
	| genomeCoverageBed -ibam - -bga \
	| awk '$4<30' | intersectBed -a $TARGET -b - \
	| sort -k1,1 -k2,2n - \
	| mergeBed -c 4 -o distinct -i - > $SAMPLE.not_covered_coordinates.txt;



done

echo ""
echo "metrics.sh job done!"
echo ""
