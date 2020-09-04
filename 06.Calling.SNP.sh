#!/bin/bash

BASE=$1
SID="./Map2TM1/"$1

echo $BASE;
echo "Begin Time:";date

ref_file="$HOME/CottonReSeq/RefGenome/TM1.NAU.chr.fa"
picard_path="/fslhome/daojuny/compute/software/picard/"
gtk_path="/fslhome/daojuny/compute/software/GenomeAnalysisTK-3.5/GenomeAnalysisTK.jar"
samtool_path="/fslhome/daojuny/bin/samtools"
bcftool_path="/fslhome/daojuny/compute/software/bcftools/bcftools"
java_path="$HOME/compute/software/jre1.8.0_66/bin/java"

${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T HaplotypeCaller -I ${SID}.recal.bam --pcr_indel_model NONE -o ${SID}.gatk.gvcf.gz --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -stand_call_conf 50.0 -stand_emit_conf 20.0 -rf BadCigar -nct 10 >${SID}.gatk.gvcf.log 2>&1 

${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T GenotypeGVCFs --variant ${SID}.gatk.gvcf.gz -o ${SID}.Recali.gatk.vcf -nt 10 >${SID}.Recali.gatk.vcf.log 2>&1

${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T SelectVariants -V ${SID}.Recali.gatk.vcf -selectType SNP --excludeNonVariants -o ${SID}.Recali.gatk.vcf.snp -nt 10

${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T VariantFiltration -V ${SID}.Recali.gatk.vcf.snp --filterExpression "QD < 2.0 || FS > 60.0 || MQ <40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filterName "LowQualFilter" -o ${SID}.Recali.gatk.vcf.snp.HQ

${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T SelectVariants -V ${SID}.Recali.gatk.vcf -selectType INDEL --excludeNonVariants -o ${SID}.Recali.gatk.vcf.indel -nt 10

${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T VariantFiltration -V ${SID}.Recali.gatk.vcf.indel --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" --filterName "LowQualFilter" -o ${SID}.Recali.gatk.vcf.indel.HQ

sed -i '/LowQualFilter/d' ${SID}.Recali.gatk.vcf.snp.HQ
sed -i '/LowQualFilter/d' ${SID}.Recali.gatk.vcf.indel.HQ

echo "End Time:";date

if [ ! -d "./Map2TM1/temp/" ]; then
	mkdir ./Map2TM1/temp/
fi

rm -rf ${SID}.sam.gz ${SID}.bam ${SID}.sort.bam* ${SID}.realn.bam* ${SID}.realn.bai 
#mv ${SID}.sam.samstat.html ./Map2TM1/temp/
mv ${SID}.realn.intervals ./Map2TM1/temp/
mv ${SID}.realn.intervals.log ./Map2TM1/temp/
mv ${SID}.freebayes.vcf ./Map2TM1/temp/
mv ${SID}.freebayes.flt.vcf ./Map2TM1/temp/
mv ${SID}.gatk.vcf ./Map2TM1/temp/
mv ${SID}.gatk.vcf.idx ./Map2TM1/temp/
mv ${SID}.gatk.vcf.log ./Map2TM1/temp/
mv ${SID}.gatk.flt.vcf ./Map2TM1/temp/
mv ${SID}.gatk.flt.vcf.idx ./Map2TM1/temp/
mv ${SID}.freebayes.flt.vcf.idx ./Map2TM1/temp/
mv ${SID}.consensus.vcf.log ./Map2TM1/temp/
#mv ${SID}.consensus.vcf ./Map2TM1/temp/
mv ${SID}.consensus.vcf.idx ./Map2TM1/temp/
mv ${SID}.recal.table ./Map2TM1/temp/
mv ${SID}.recal.table.log ./Map2TM1/temp/
#mv ${SID}.recal.bam ./Map2TM1/temp/
#mv ${SID}.recal.bai ./Map2TM1/temp/
mv ${SID}.recal.bam.log ./Map2TM1/temp/
mv ${SID}.recal.bam.bai ./Map2TM1/temp/
#mv ${SID}.gatk.gvcf.gz ./Map2TM1/temp/
mv ${SID}.gatk.gvcf.tbi ./Map2TM1/temp/
mv ${SID}.gatk.gvcf.log ./Map2TM1/temp/
mv ${SID}.Recali.gatk.vcf.snp ./Map2TM1/temp/
mv ${SID}.Recali.gatk.vcf.indel ./Map2TM1/temp/
mv ${SID}.Recali.gatk.vcf.log ./Map2TM1/temp/
#mv ${SID}.gatk.vcf.Recali.snp.HQ ./Map2TM1/temp/
#mv ${SID}.gatk.vcf.Recali.indel.HQ ./Map2TM1/temp/
mv ${SID}*.tbi ${SID}*idx ./Map2TM1/temp/
