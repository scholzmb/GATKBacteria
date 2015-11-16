#!/bin/bash -l

#test change
PICARD="java -jar /usr/analysis/tools/picard-tools/picard.jar"

for i in *.sam
do 
  READGROUP=`echo $i | awk -F\. '{print $1}'`
  $PICARD SortSam INPUT=$i output=$READGROUP.bam SORT_ORDER=coordinate
  $PICARD AddOrReplaceReadGroups INPUT=$READGROUP.bam OUTPUT=$READGROUP\_sorted.bam RGLB=$READGROUP RGPL=illumina RGPU=Null RGSM=$READGROUP
 
  $PICARD MarkDuplicates INPUT=$READGROUP\_sorted.bam OUTPUT=$READGROUP.s.dedup.bam METRICS_FILE=metrics.$READGROUP.txt
  $PICARD BuildBamIndex INPUT=$READGROUP.s.dedup.bam
done
