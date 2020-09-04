#!/bin/bash

BASE=$1
input="VCF"
output="SNP_Filt"

if [ ! -e ${output} ];then
	mkdir ${output};
fi

vcftools --gzvcf ./${output}/${BASE}.flt.01.vcf.gz --remove ./HighMissingRate.list --recode --recode-INFO AC --recode-INFO AN --recode-INFO DP --stdout | fill-an-ac | bgzip -c >./${output}/${BASE}.flt.02.vcf.gz

vcftools --gzvcf ./${output}/${BASE}.flt.02.vcf.gz --maf 0.01 --max-maf 0.99 --max-missing 0.75 --recode --recode-INFO-all --stdout | gzip -c  >./${output}/${BASE}.flt.03.vcf.gz

