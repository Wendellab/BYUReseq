require("RColorBrewer")

setwd("~/Documents/Dropbox/ReSeq_Project/Results/Structure/Gh.Perfect.structure/Consensus/")
 
pdf(file="K3.ClumppIndFile.output.NameValue.MyColors.pdf",width=100,height=6)
tbl=read.table(file = "./K3.ClumppIndFile.output.NameValue")
tblV=tbl[c(-1)]
tblN=tbl[c(1)]
 
mycolors=(c("#1a9850","#f46d43", "#d73027"))
barplot(t(as.matrix(tblV)),col=mycolors,names.arg=as.matrix(tblN),las=2,cex.names=0.75,border=NA)
dev.off()

pdf(file="K3.ClumppIndFile.output.NameValue.MyColors.NoLable.pdf",width=100,height=6)
barplot(t(as.matrix(tblV)),col=mycolors,las=2,cex.names=0.75,border=NA,space=0)
dev.off()

par(mar=c(1,3,1,1))
png(file="K3.ClumppIndFile.output.NameValue.MyColors.NoLable.png",width=4000,height=300,units = "px")
barplot(t(as.matrix(tblV)),col=mycolors,las=2,cex.names=0.75,border=NA,space=0)
dev.off()
