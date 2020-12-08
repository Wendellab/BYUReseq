for i in {2..10};do 
	paste AD1AD4.Perfect755.Sample.Rename.lst K${i}.ClumppIndFile.output >K${i}.ClumppIndFile.output.WithName;
	perl ./Sort.Structure.pl K${i}.ClumppIndFile.output.WithName Tree.Sample.lst | sort -k1n | awk '{printf "%s\t",$2; for (i=8;i<NF;i++) printf "%s\t",$i;print $NF}' >K${i}.ClumppIndFile.output.NameValue;
	Rscript Draw.Structure.R K${i}.ClumppIndFile.output.NameValue;
done
