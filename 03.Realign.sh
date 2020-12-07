#!/bin/bash

BASE=$1
SID="./Map2TM1/"$1

ref_file="$HOME/CottonReSeq/RefGenome/TM1.NAU.chr.fa"
picard_path="/fslhome/daojuny/compute/software/picard-tools-1.123/"
gtk_path="/fslhome/daojuny/compute/software/GenomeAnalysisTK-3.5/GenomeAnalysisTK.jar"
samtool_path="/fslhome/daojuny/bin/samtools"
bcftool_path="/fslhome/daojuny/compute/software/bcftools/bcftools"
java_path="$HOME/compute/software/jre1.8.0_66/bin/java"

echo $BASE;
echo "Begin Time:";date

samstat ${SID}.sam.gz

samtools view -bS -F 4 -q 30 ${SID}.sam.gz -T ${ref_file} -o ${SID}.bam 

samtools sort ${SID}.bam ${SID}.sort

samtools index ${SID}.sort.bam

${java_path} -Xmx120g -jar $picard_path MarkDuplicates I=${SID}.sort.bam O=${SID}.sort.rm_duplicates.bam M=${SID}.sort.rm_dup_metrics.txt VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=true

samtools index ${SID}.sort.rm_duplicates.bam

${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T RealignerTargetCreator -o ${SID}.realn.intervals -I ${SID}.sort.rm_duplicates.bam >${SID}.realn.intervals.log 2>&1

${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T IndelRealigner -targetIntervals ${SID}.realn.intervals -o ${SID}.realn.bam -I ${SID}.sort.rm_duplicates.bam >${SID}.realn.bam.log 2>&1

echo "End Time:";date

MyTaskSubmit.sh ${BASE}_GATK 1 15 120 28 s "./04.GATK.vcf.sh ${BASE}"  ""  cotton_seq
MyTaskSubmit.sh ${BASE}_FreeBayes 1 4 120 12 s "./04.FreeBayes.vcf.sh ${BASE}"  ""  cotton_seq
