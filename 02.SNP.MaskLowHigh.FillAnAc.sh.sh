#!/bin/bash

BASE=$1
input="SNP"
output="SNP_Filt"

echo ${BASE};

if [ ! -e ${output} ];then
	mkdir ${output};
fi

vcftools --gzvcf ./${input}/${BASE}.gatk.snp.HQ.vcf.gz --minDP 3 --maxDP 1000 --recode --recode-INFO AC --recode-INFO AF --recode-INFO AN --recode-INFO DP --stdout | perl ~/compute/software/bcftools-1.2/vcfutils.pl varFilter -d 1432 -D 143200 | fill-an-ac | bgzip -c >./${output}/${BASE}.flt.01.vcf.gz

vcftools --gzvcf ./${output}/${BASE}.flt.01.vcf.gz --missing-indv --stdout >./${output}/${BASE}.flt.01.imiss.txt

