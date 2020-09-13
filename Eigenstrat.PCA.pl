#!/usr/bin/perl

$ENV{'PATH'} = "../bin:$ENV{'PATH'}"; 
# MUST put smartpca bin directory in path for smartpca.perl to work

$command = "smartpca.perl";
$command .= " -i ADall.Chr28.EIG.geno ";
$command .= " -a ADall.Chr28.EIG.snp ";
$command .= " -b ADall.Chr28.EIG.ind " ;
$command .= " -k 4 ";
$command .= " -o ADall.Chr28.EIG.pca ";
$command .= " -p ADall.Chr28.EIG.plot ";
$command .= " -e ADall.Chr28.EIG.eval ";
$command .= " -l ADall.Chr28.EIG.log ";
$command .= " -m 5 ";
$command .= " -t 2 ";
$command .= " -s 6.0 ";
print("$command\n");
system("$command");

$command = "smarteigenstrat.perl "; 
$command .= " -i ADall.Chr28.EIG.geno ";
$command .= " -a ADall.Chr28.EIG.snp ";
$command .= " -b ADall.Chr28.EIG.ind ";
$command .= " -p ADall.Chr28.EIG.pca ";
$command .= " -k 1 ";
$command .= " -o ADall.Chr28.EIG.chisq ";
$command .= " -l ADall.Chr28.EIG.log ";
print("$command\n");
system("$command");

$command = "gc.perl ADall.Chr28.EIG.chisq ADall.Chr28.EIG.chisq.GC";
print("$command\n");
system("$command");
