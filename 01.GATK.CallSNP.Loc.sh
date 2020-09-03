#!/bin/bash

ref_file="/fslgroup/cotton_seq/compute/ReSeq_Project/RefGenome/GhTexas.fa"
gtk_path="/fslhome/daojuny/compute/software/GenomeAnalysisTK-3.5/GenomeAnalysisTK.jar"

outpath="VCF";
if [ ! -e ${outpath} ];then
	mkdir ${outpath};
fi

snppath="SNP";
if [ ! -e ${snppath} ];then
	mkdir ${snppath};
fi

indelpath="INDEL";
if [ ! -e ${indelpath} ];then
	mkdir ${indelpath};
fi

gvcf_file=$1;
chr=$2;
mem=75;

Gvcf_Tab="";
for str in `less ${gvcf_file}`;do Gvcf_Tab=${Gvcf_Tab}" -V "${str};done;

echo ${chr};

java -Xmx${mem}g -jar $gtk_path -R $ref_file -T GenotypeGVCFs --max_alternate_alleles 1 ${Gvcf_Tab} -o ./${outpath}/${chr}.gatk.vcf -nt 2 -L ${chr} >./${outpath}/${chr}.gatk.vcf.log 2>&1;

java -Xmx${mem}g -jar $gtk_path -R $ref_file -T SelectVariants -V ./${outpath}/${chr}.gatk.vcf -selectType SNP --excludeNonVariants -o ./${snppath}/${chr}.gatk.snp.vcf -nt 2

java -Xmx${mem}g -jar $gtk_path -R $ref_file -T VariantFiltration -V ./${snppath}/${chr}.gatk.snp.vcf --filterExpression "QD < 2.0 || FS > 60.0 || MQ <40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filterName "LowQual" -o ./${snppath}/${chr}.gatk.snp.HQ.vcf

java -Xmx${mem}g -jar $gtk_path -R $ref_file -T SelectVariants -V ./${outpath}/${chr}.gatk.vcf -selectType INDEL --excludeNonVariants -o ./${indelpath}/${chr}.gatk.indel.vcf -nt 2

java -Xmx${mem}g -jar $gtk_path -R $ref_file -T VariantFiltration -V ./${indelpath}/${chr}.gatk.indel.vcf --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" --filterName "LowQual" -o ./${indelpath}/${chr}.gatk.indel.HQ.vcf

sed -i '/LowQual/d' ./${snppath}/${chr}.gatk.snp.HQ.vcf;
sed -i '/LowQual/d' ./${indelpath}/${chr}.gatk.indel.HQ.vcf;

gzip -f ./${outpath}/${chr}.gatk.vcf;
gzip -f ./${snppath}/${chr}.gatk.snp.HQ.vcf;
gzip -f ./${indelpath}/${chr}.gatk.indel.HQ.vcf;

rm -rf ./${outpath}/${chr}.gatk.vcf.log;
rm -rf ./${snppath}/${chr}.gatk.snp.vcf ./${snppath}/${chr}.gatk.snp.vcf.idx;
rm -rf ./${indelpath}/${chr}.gatk.indel.vcf ./${indelpath}/${chr}.gatk.indel.vcf.idx;

if [ ! -e ./${outpath}/IDX ];then
	mkdir ./${outpath}/IDX;
fi 
if [ ! -e ./${snppath}/IDX ];then
	mkdir ./${snppath}/IDX;
fi 
if [ ! -e ./${indelpath}/IDX ];then
	mkdir ./${indelpath}/IDX;
fi

mv ./${outpath}/${chr}.gatk.vcf.idx ./${outpath}/IDX/;
mv ./${snppath}/${chr}.gatk.snp.HQ.vcf.idx ./${snppath}/IDX/;
mv ./${indelpath}/${chr}.gatk.indel.HQ.vcf.idx ./${indelpath}/IDX/;
