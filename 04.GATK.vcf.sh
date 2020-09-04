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

${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T HaplotypeCaller --pcr_indel_model NONE -I ${SID}.realn.bam -o ${SID}.gatk.vcf --variant_index_type LINEAR --variant_index_parameter 128000 -stand_call_conf 50.0 -stand_emit_conf 20.0 -rf BadCigar -nct 16 >${SID}.gatk.vcf.log 2>&1

${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T VariantFiltration --filterExpression "QD < 2.0 || FS > 60.0 || MQ <40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0"  --filterName LowQualFilter --variant ${SID}.gatk.vcf --logging_level ERROR -o ${SID}.gatk.flt.vcf

echo "End Time:";date

MyTaskSubmit.sh ${BASE}_Recali 1 10 120 20 s "./05.BaseRecalibrator.sh ${BASE}"  ""  cotton_seq
