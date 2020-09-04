#!/bin/bash

BASE1=$1
BASE2=$2
BASE=$3
MEM=$4
SID="./Map2Texas/"$3

echo $BASE;
echo "Begin Time:";date

ref_file="$HOME/CottonReSeq/RefGenome/GhTexas.fa"
picard_path="/fslhome/daojuny/compute/software/picard/"
gtk_path="/fslhome/daojuny/compute/software/GenomeAnalysisTK-3.5/GenomeAnalysisTK.jar"
samtool_path="/fslhome/daojuny/bin/samtools"
bcftool_path="/fslhome/daojuny/compute/software/bcftools/bcftools"
java_path="$HOME/compute/software/jre1.8.0_66/bin/java"

samtools merge ${SID}.recal.bam ./Map2Texas/${BASE1}.recal.bam ./Map2Texas/${BASE2}.recal.bam

samtools view -H ${SID}.recal.bam | sed -e "s/SM:${BASE1}/SM:${BASE}/;s/SM:${BASE2}/SM:${BASE}/" >${SID}.NewHeader

samtools reheader ${SID}.NewHeader ${SID}.recal.bam >${SID}.recal.rename.bam 

samtools sort ${SID}.recal.rename.bam -o ${SID}.recal.rename.sort.bam

samtools index ${SID}.recal.rename.sort.bam

${java_path} -Xmx${MEM}g -jar $gtk_path -R $ref_file -T HaplotypeCaller -I ${SID}.recal.rename.sort.bam -o ${SID}.gatk.gvcf.gz --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -stand_call_conf 50.0 -stand_emit_conf 20.0 -rf BadCigar -nct 10 >${SID}.gatk.gvcf.log 2>&1 

echo "End Time:";date

