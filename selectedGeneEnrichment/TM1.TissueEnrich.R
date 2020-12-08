library(TissueEnrich)
library(SummarizedExperiment)
library(ggplot2)

expressionData<-read.table(file="/work/LAS/jfw-lab/djyuan/RNASeq/GhTexas.TM1.FPKM.avg.txt",header=TRUE,row.names=1,sep='\t')
se<-SummarizedExperiment(assays = SimpleList(as.matrix(expressionData)),rowData = row.names(expressionData),colData = colnames(expressionData))
output<-teGeneRetrieval(se)
head(assay(output))
write.table(assay(output),file="/work/LAS/jfw-lab/djyuan/RNASeq/GhTexas.TM1.genes.expressionprofile.txt")

###
genes="/work/LAS/jfw-lab/djyuan/RNASeq/Gene.list.txt"
inputGenes<-scan(genes,character())
gs<-GeneSet(geneIds=inputGenes)
output2<-teEnrichmentCustom(gs,output)
enrichmentOutput<-setNames(data.frame(assay(output2[[1]]), row.names = rowData(output2[[1]])[,1]), colData(output2[[1]])[,1])
head (enrichmentOutput)
write.table(enrichmentOutput,file="/work/LAS/jfw-lab/djyuan/RNASeq/GhTexas.TM1.genes.tissueSpecific.txt")

enrichmentOutput$Tissue<-row.names(enrichmentOutput)
png(file="./TM1.enrichmentOutputTissue.png",width = 1600, height = 900, units = "px", pointsize = 12)
ggplot(enrichmentOutput,aes(x=reorder(Tissue,-Log10PValue),y=Log10PValue,label = Tissue.Specific.Genes,fill = Tissue))+
       geom_bar(stat = 'identity')+
       labs(x='', y = '-LOG10(P-Adjusted)')+
       theme_bw()+
       theme(legend.position="none")+
       theme(plot.title = element_text(hjust = 0.5,size = 20),axis.title = element_text(size=15))+
       theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),panel.grid.major= element_blank(),panel.grid.minor = element_blank())
dev.off()

png(file="./TM1.enrichmentOutputTissue.foldchange.png",width = 1600, height = 900, units = "px", pointsize = 12)
ggplot(enrichmentOutput,aes(x=reorder(Tissue,-fold.change),y=fold.change,label = Tissue.Specific.Genes,fill = Tissue))+
       geom_bar(stat = 'identity')+
       labs(x='', y = 'Fold change')+
       theme_bw()+
       theme(legend.position="none")+
       theme(plot.title = element_text(hjust = 0.5,size = 20),axis.title = element_text(size=15))+
       theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),panel.grid.major= element_blank(),panel.grid.minor = element_blank())
dev.off()

###

for (tissue in c("TM1_0DPA","TM1_0h","TM1_10DPA_Fiber","TM1_10DPA_Ovule","TM1_15DPA_Fiber","TM1_15DPA_Ovule","TM1_1DPA","TM1_20DPA_Fiber","TM1_20DPA_Ovule","TM1_25DPA_Fiber","TM1_25DPA_Ovule","TM1_37C_12h","TM1_37C_1h","TM1_37C_24h","TM1_37C_3h","TM1_37C_6h","TM1_3DPA","TM1_Minus3DPA","TM1_4C_12h","TM1_4C_1h","TM1_4C_24h","TM1_4C_3h","TM1_4C_6h","TM1_5DPA","TM1_anther","TM1_bract","TM1_ck_12h","TM1_ck_1h","TM1_ck_24h","TM1_ck_3h","TM1_ck_6h","TM1_filament","TM1_leaf","TM1_NaCl_12h","TM1_NaCl_1h","TM1_NaCl_24h","TM1_NaCl_3h","TM1_NaCl_6h","TM1_PEG_12h","TM1_PEG_1h","TM1_PEG_24h","TM1_PEG_3h","TM1_PEG_6h","TM1_pental","TM1_pistil","TM1_root","TM1_sepal","TM1_stem","TM1_torus")){
	print(tissue);
#	seExp<-output2[[2]][[(paste("",tissue,"",sep=""))]];
	seExp<-output2[[2]][[tissue]];
	exp<-setNames(data.frame(assay(seExp), row.names = rowData(seExp)[,1]), colData(seExp)[,1]);
	write.table(exp,file=paste("/work/LAS/jfw-lab/djyuan/RNASeq/GhTexas.TM1.",tissue,"_Specific.txt",sep=""))
}
