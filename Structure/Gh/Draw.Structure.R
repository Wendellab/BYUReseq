require("RColorBrewer")

args<-commandArgs(T)

pdf(paste(args[1],".pdf",sep=""),width=100,height=6)
tbl=read.table(args[1])
tblV=tbl[c(-1)]
tblN=tbl[c(1)]

barplot(t(as.matrix(tblV)),col=brewer.pal(8, "Set2"),names.arg=as.matrix(tblN),las=2,cex.names=0.75,border=NA)

dev.off()
