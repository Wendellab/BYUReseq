#!/bin/bash

PGD_path="~/software/PGDSpider_2.0.9.0/"
STR_path="~/software/structure/"

vcf=$1;

IDV=`less -S ${vcf} |grep -v '^#' |wc -l`
SNP=`head -n 2000 ${vcf} | grep '^#CHR' |awk '{print NF-9}'`

java -Xmx10240m -Xms5120M -jar ${PGD_path}PGDSpider2-cli.jar -inputfile ${vcf} -inputformat VCF -outputfile ${vcf}2structure -outputformat STRUCTURE -spid ${PGD_path}
VCF2STRUCTURE.spid

perl ~/script/adjust.pop.pl -i ${vcf}2structure | sed -e '1d' >${vcf}2structure.adjustpop

if [ ! -e structure ];then
	mkdir structure;
fi

for j in {1..10}; do
  for i in {2..8};do
  runtime=$(( 10*i + 88 ))
	file=./structure/${vcf/vcf}K${i}.R${j}"_f"; 
	if [ ! -f "$file" ]; then 
		MTS.sh RunStrucK${i}R${j}_${vcf} 1 1 48 ${runtime} "${STR_path}structure -m ${STR_path}mainparams_LargeData -e ${STR_path}extraparams -K $i -L ${IDV} 
-N ${SNP} -i ${vcf}2structure.adjustpop -o ${file}";
	fi;
  done;
done
