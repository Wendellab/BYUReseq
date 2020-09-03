#!/bin/bash

BASE=$1;
reads_path=$2;

echo $BASE;
echo "Begin Time:";date

SOAPnuke filter -f TACACTCTTTCCCTACACGACGCTCTTCCGATCT -r GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT -1 ${reads_path}${BASE}.1.fq.gz -2 ${reads_path}${BASE}.2.fq.gz -l 5 -q 0.5 -n 0.02 -Q 2 -G -o CleanReads_SOAPnuke/${BASE}/ -C ${BASE}_1.fq.gz -D ${BASE}_2.fq.gz 

echo "End Time:";date;

MyTaskSubmit.sh ${BASE}_Mapping 1 20 120 10 s "./02.BWA.mapping.sh ${BASE}" "" cotton_seq
