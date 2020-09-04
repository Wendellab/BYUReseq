#!/bin/bash

BASE=$1
SID="./Map2TM1/"$1

echo $BASE;
echo "Begin Time:";date

ref_file="$HOME/CottonReSeq/RefGenome/TM1.NAU.chr.fa"
picard_path="/fslhome/daojuny/compute/software/picard-tools-1.123/"
gtk_path="/fslhome/daojuny/compute/software/GenomeAnalysisTK-3.5/GenomeAnalysisTK.jar"
samtool_path="/fslhome/daojuny/bin/samtools"
bcftool_path="/fslhome/daojuny/compute/software/bcftools/bcftools"
java_path="$HOME/compute/software/jre1.8.0_66/bin/java"

freebayes-parallel <(fasta_generate_regions.py ../RefGenome/TM1.NAU.chr.fa.fai 100000) 4 -f $ref_file -p 2 -m 30 -q 20 --min-coverage 10 -C 3 -i -X -u ${SID}.realn.bam >${SID}.freebayes.vcf

perl ~/compute/software/bcftools-1.2/vcfutils.pl varFilter -Q 30 -d 10 -D 2000 -a 3 ${SID}.freebayes.vcf >${SID}.freebayes.flt.vcf

echo "FreeBayesOK" >>./${SID}.FreeBayes.OK

echo "End Time:";date
