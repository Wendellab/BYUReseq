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

FB_OK=0;

while [ ${FB_OK} == 0 ]

	do

	if [ -e ./${SID}.FreeBayes.OK ]; then

		FB_OK=1

		java -Xmx120g -jar $gtk_path -T SelectVariants -R $ref_file -V ${SID}.gatk.flt.vcf --concordance ${SID}.freebayes.flt.vcf -o ${SID}.consensus.vcf >${SID}.consensus.vcf.log 2>&1

		sed -i '/LowQualFilter/d' ${SID}.consensus.vcf

		java -Xmx120g -jar $gtk_path -T SelectVariants -R $ref_file -V ${SID}.gatk.flt.vcf --concordance ${SID}.freebayes.flt.vcf -o ${SID}.consensus.vcf -nt 10 >${SID}.consensus.vcf.log 2>&1

		sed -i '/LowQual/d' ${SID}.consensus.vcf

		${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T BaseRecalibrator -I ${SID}.realn.bam -knownSites ${SID}.consensus.vcf -o ${SID}.recal.table -nct 10 >${SID}.recal.table.log 2>&1

		${java_path} -Xmx120g -jar $gtk_path -R $ref_file -T PrintReads --bam_compression 9 -I ${SID}.realn.bam -BQSR ${SID}.recal.table -o ${SID}.recal.bam -nct 10 >${SID}.recal.bam.log 2>&1

		samtools index ${SID}.recal.bam
		
		rm -rf ./${SID}.FreeBayes.OK

		echo "End Time:";date

		MyTaskSubmit.sh ${BASE}_SNP_Indel 1 10 120 40 s "./06.Calling.SNP.sh ${BASE}"  ""  cotton_seq
		
		break

	else
	
		continue
		
	fi
	
done