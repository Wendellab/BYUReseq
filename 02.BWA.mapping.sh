#!/bin/bash

ref_file="/fslgroup/cotton_seq/compute/ReSeq_Project/RefGenome/GhTexas.At.fa"

BASE=$1
SID=$1

echo $BASE;
echo "Begin Time:";date

bwa mem -t 20 -M -R "@RG\tID:${SID}\tPL:Illumina\tPU:lane\tLB:lib\tSM:${SID}\t"  ${ref_file} ./${BASE}/*_1.fq.gz ./${BASE}/*_2.fq.gz | gzip -3 >./Map2TM1/${SID}.sam.gz

echo "End Time:";date

# MyTaskSubmit.sh ${BASE}_Realign 1 1 120 18 s "./03.Realign.sh ${BASE}"  ""  cotton_seq
