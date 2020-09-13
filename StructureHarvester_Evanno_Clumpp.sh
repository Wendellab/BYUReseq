#!/bin/bash

input=$1;

python ~/compute/software/git_origin/structureHarvester/structureHarvester.py --dir=./${input} --out=./${input} --evanno --clumpp

cd ./${input}

for i in `grep -v '^#' evanno.txt  |grep "^${i}" |awk '{print $1}'`;do
	Rep=`grep -v '^#' evanno.txt  |grep "^${i}" |awk '{print $2}'`;
	Line=`wc -l K${i}.indfile | awk '{print $1}'`;
	Ind1=$(( Line / Rep ));
	Ind=$(( Ind1 -1 ));
	cp ~/compute/software/CLUMPP_Linux64.1.1.2/paramfile_blank paramfile_K${i}; 
	sed -i "s/K3/K${i}/g" paramfile_K${i}; 
	sed -i "7i K $i" paramfile_K${i}; 
	sed -i "10i C ${Ind}" paramfile_K${i}; 
	sed -i "13i R ${Rep}" paramfile_K${i};
	~/compute/software/CLUMPP_Linux64.1.1.2/CLUMPP paramfile_K${i};
	rm -rf paramfile_K${i};
done
