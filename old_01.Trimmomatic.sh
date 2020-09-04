#!/bin/bash

trim_path="$HOME/compute/software/Trimmomatic-0.33/trimmomatic-0.33.jar";

BASE=$1;
reads_path=$2;
CPU=$3;

echo $BASE;
echo "Begin Time:";date

java  -Xmx72g -jar $trim_path PE -threads $CPU -phred33 ${reads_path}${BASE}.1.fq.gz ${reads_path}${BASE}.2.fq.gz ./CleanReads/${BASE}.1.fq.gz ./CleanReads/${BASE}.1.S.fq.gz ./CleanReads/${BASE}.2.fq.gz ./CleanReads/${BASE}.2.S.fq.gz ILLUMINACLIP:/fslgroup/cotton_seq/compute/ReSeq_Project/script/TruSeq3-PE.fa:2:30:10 LEADING:10 TRAILING:10 SLIDINGWINDOW:4:15 MINLEN:50 >./CleanReads/${BASE}.P.log 2>&1

cat ./CleanReads/${BASE}.1.S.fq.gz ./CleanReads/${BASE}.2.S.fq.gz >./CleanReads/${BASE}.S.fq.gz

rm -rf ./CleanReads/${BASE}.1.S.fq.gz ./CleanReads/${BASE}.2.S.fq.gz

echo "End Time:";date

MyTaskSubmit.sh ${BASE}_Mapping 1 20 110 10 s "./02.BWA.mapping.sh ${BASE}" "" cotton_seq
