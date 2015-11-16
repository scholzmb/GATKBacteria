#!/bin/bash -l

REF=/gluster/scholzmb/S_aureus/ref/NC_009641.fna
GBK=/gluster/scholzmb/S_aureus/ref/NC_009641.gbk
KNOWN=/gluster/scholzmb/S_aureus/ref/NC_009641.vcf
GATK="java -jar /usr/analysis/tools/gatk/GenomeAnalysisTK.jar"
PICARD="java -jar /usr/analysis/tools/picard-tools/picard.jar"
VCF2TRAMS="/home/scholzmb/GATK_PIPELINE/contrib/vcf2trams.pl"
TRAMS="/usr/analysis/tools/TRAMS/Scripts/TRAMS.py"


#after dereplication
for i in *.s.dedup.bam 
do 
  $PICARD BuildBamIndex INPUT=$i 
  ${GATK} -T RealignerTargetCreator -R $REF -I $i -o $i.intervals
  $GATK -T IndelRealigner -R $REF -I $i -targetIntervals $i.intervals -o realigned.$i.bam
  $GATK -T BaseRecalibrator -R $REF -I realigned.$i.bam -knownSites $KNOWN -o $i.prelim.table
  $GATK -T BaseRecalibrator -R $REF -I realigned.$i.bam -knownSites $KNOWN -BQSR $i.prelim.table -o $i.post_proc.table
  $GATK -T PrintReads -R $REF -I realigned.$i.bam -BQSR $i.prelim.table -o recal.$i.bam 
   $PICARD BuildBamIndex INPUT=recal.$i.bam
  $GATK -T HaplotypeCaller -R $REF -I recal.$i.bam --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -L $i.intervals -o output.raw.$i.g.vcf --sample_ploidy 1 
  SAMPLE="$SAMPLE --variant output.raw.$i.g.vcf"
done

$GATK -T CombineGVCFs $SAMPLE -R $REF -o jointVCF.g.vcf
$GATK -T GenotypeGVCFs --variant jointVCF.g.vcf -R $REF -o jointGenotype.g.vcf

$GATK -T VariantAnnotator -R $REF -V jointGenotype.g.vcf -o jointAnnotated.g.vcf
#$GATK -T VariantEval -R $REF -o jointEval.g.Eval --eval jointAnnotated.g.vcf
$GATK -T VariantsToTable -R $REF -o jointEval.varTable -V jointAnnotated.g.vcf  -F CHROM  -F POS  -F REF  -F ALT  -F VariantType -F Samples

$VCF2TRAMS jointAnnotated.g.vcf

for i in *.trams
do
  $TRAMS -s $i -r $GBK
done
