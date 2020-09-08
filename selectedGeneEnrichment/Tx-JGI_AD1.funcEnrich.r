#########################
## clusterProfile prep ##
#########################
# plots: http://bioconductor.org/packages/devel/bioc/vignettes/enrichplot/inst/doc/enrichplot.html

# prep reference database
library(clusterProfiler)
library(tidyr)
library(ggthemes)

# Download gene annotation file ""Tx-JGI_G.hirsutum_v1.1.gene.gff3"" from Gossypium hirsutum (AD1) 'TM-1' genome UTX-JGI-Interim-release _v1.1
# https://www.cottongen.org/species/Gossypium_hirsutum/jgi-AD1_genome_v1.1

# Universe LOC genes exclude scaffold genes
library(rtracklayer)
a <- import("Tx-JGI_G.hirsutum_v1.1.gene.gff3",format="gff3")
b=a[a$type=="gene",]
length(b) # 66577
length(grep("A",seqnames(b))) # A 32295
length(grep("D",seqnames(b))) # D 33341
length(grep("scaffold",seqnames(b))) # Z 941
universe = b$Name[as.numeric(grep("scaffold",seqnames(b),invert=T))]
universeA = b$Name[as.numeric(grep("A",seqnames(b)))]
universeD = b$Name[as.numeric(grep("D",seqnames(b)))]

# GO annoation
#system("cat G.hirsutum_Tx-JGI_v1.1.annotation_info.txt |cut -f2,10 >gene2go.txt")
desc = read.table("gene2go.txt",header=T,sep="\t")
gomap=desc[desc$GO!="",c("GO","locusName")]
separate_rows(gomap, GO,sep=",")
gomap<-unique(gomap)
godb<-buildGOmap(gomap)
ont=go2ont(godb$GO)
godb$ont = ont$Ontology[match(godb$GO,ont$go_id)]

# prep GO term2name
library(GO.db)
goterms <- Term(GOTERM)
goterm2name = data.frame(term=names(goterms),name=goterms)

# KEGG pathway
pa = read.table("G.hirsutum_Tx-JGI_v1.1_KEGG-pathways.txt",sep="\t")
pa$V1 =gsub("[.][1-9];$","",pa$V1)
pa$V1 =gsub("[.][1-9][1-9];$","",pa$V1)
names(pa)=c("gene","ko","pathway")
dim(pa <-unique(pa) )# 58681
dim( koterm2name <- unique(data.frame(term=pa$ko,name=pa$pathway)) )# 1037


#########
## FUN ##
#########

# prep GO enrichment function, plot top 10 enriched each for MF, CC and BP and save table
GOenrich = function(geneL, refL, filename="GOenrich"){
    if(!is.null(filename)){pdf(paste0(filename,".pdf"))}
    for(o in c("MF","BP","CC")){
        en <- enricher(geneL, pvalueCutoff = 0.05, pAdjustMethod = "BH", universe=refL, minGSSize = 10, maxGSSize = 500, qvalueCutoff = 0.05, TERM2GENE = godb[godb$ont==o,1:2], TERM2NAME = goterm2name)
        # print(en)
        print( dotplot(en, showCategory=10,font.size = 6, title=o) )
        if(nrow(en)>0){
            print( emapplot(en, showCategory=30,font.size = 6, title=o) )
            df=as.data.frame(en)
            df$ont=o
            df$level2 = df$ID %in% getGOLevel(o, 2)
            df$level3 = df$ID %in% getGOLevel(o, 3)
            df$level4 = df$ID %in% getGOLevel(o, 4)
            if(o=="MF"){dfL=df}
            else if(!exists("dfL")){dfL=df}
            else{dfL=rbind(dfL,df)}
        }
    }
    if(!is.null(filename)){
        dev.off()
        write.csv(dfL,file=paste0(filename,".csv"))}
    print(table(dfL$ont))
    return(dfL)
}
GOcompare = function(geneL, refL, filename="GOcompare"){
    if(!is.null(filename)){pdf(paste0(filename,".pdf"))}
    for(o in c("MF","BP","CC")){
        print(o);
        en=tryCatch(compareCluster(geneL, fun = "enricher", pvalueCutoff = 0.05, pAdjustMethod = "BH", universe=refL, minGSSize = 10, maxGSSize = 500, qvalueCutoff = 0.05, TERM2GENE = godb[godb$ont==o,1:2], TERM2NAME = goterm2name), error=function(e){cat("ERROR :",conditionMessage(e), "\n")}, finally={en=NULL})
        if(!is.null(en)){
            print( dotplot(en, showCategory=10,font.size = 6, title=o) )
            df=as.data.frame(en)
            df$ont=o
            df$level2 = df$ID %in% getGOLevel(o, 2)
            df$level3 = df$ID %in% getGOLevel(o, 3)
            df$level4 = df$ID %in% getGOLevel(o, 4)
            if(!exists("dfL")){dfL=df}else{dfL=rbind(dfL,df)}
        }
    }
    if(!exists("dfL")){dfL=NULL}
    if(!is.null(filename)){
        dev.off()
        write.csv(dfL,file=paste0(filename,".csv"))}
    print(table(dfL[,c("ont","Cluster")]))
    return(dfL)
}
GOcompare.formula = function(formula, data, filename="GOcompare"){
    if(!is.null(filename)){pdf(paste0(filename,".pdf"))}
    for(o in c("MF","BP","CC")){
        en <- compareCluster(formula, data, fun = "enricher", pvalueCutoff = 0.05, pAdjustMethod = "BH", minGSSize = 10, maxGSSize = 500, qvalueCutoff = 0.05, TERM2GENE = godb[godb$ont==o,1:2], TERM2NAME = goterm2name)
        print( dotplot(en, showCategory=10,font.size = 6, title=o) )
        df=as.data.frame(en)
        df$ont=o
        df$level2 = df$ID %in% getGOLevel(o, 2)
        df$level3 = df$ID %in% getGOLevel(o, 3)
        df$level4 = df$ID %in% getGOLevel(o, 4)
        if(o=="MF"){dfL=df}else{dfL=rbind(dfL,df)}
    }
    if(!is.null(filename)){
        dev.off()
        write.csv(dfL,file=paste0(filename,".csv"))}
    print(table(dfL[,c("ont","Cluster")]))
    return(dfL)
}

#result=GOcompare.formula(ID~rd,data=rd,filename="GOcompare.RD")

# enrich kegg pathway
KOcompare = function(geneL, refL, filename="KOcompare"){
    if(!is.null(filename)){pdf(paste0(filename,".pdf"))}
    en=tryCatch(compareCluster(geneL, fun = "enricher", pvalueCutoff = 0.05, pAdjustMethod = "BH", universe=refL, minGSSize = 5, maxGSSize = 2500, qvalueCutoff = 0.05, TERM2GENE = pa[,c("ko","gene")], TERM2NAME = koterm2name), error=function(e){cat("ERROR :",conditionMessage(e), "\n")}, finally={en=NULL})
    dfL=as.data.frame(en)
    if(!exists("dfL")){dfL=NULL}
    if(!is.null(filename)){
        dev.off()
        write.csv(dfL,file=paste0(filename,".csv"))}
    print(paste0(length(unique(dfL$ID))," pathways enriched"))
    return(dfL)
}
#geneL=list(A=c(pa$gene[pa$ko=="ko00010"]),B=c(pa$gene[pa$ko=="ko01522"]))
#result=KOcompare(geneL,universe,filename="KOcompare.test.txt")


# dependent functions
getGOLevel <- function(ont, level) {
    switch(ont,
    MF = {
        topNode <- "GO:0003674"
        Children <- GOMFCHILDREN
    },
    BP = {
        topNode <- "GO:0008150"
        Children <- GOBPCHILDREN
    },
    CC = {
        topNode <- "GO:0005575"
        Children <- GOCCCHILDREN
    }
    )

    max_level <- max(level)
    if (any(level == 1)) {
        all_nodes <- topNode
    } else {
        all_nodes <- c()
    }

    Node <- topNode
    for (i in seq_len(max_level-1)) {
        Node <- mget(Node, Children, ifnotfound=NA)
        Node <- unique(unlist(Node))
        Node <- as.vector(Node)
        Node <- Node[!is.na(Node)]
        if ((i+1) %in% level) {
            all_nodes <- c(all_nodes, Node)
        }
    }
    return(all_nodes)
}
dotplot.df=function(result, title="", cex=6)
{
    library(DOSE) # theme_dose
    parse_ratio <- function(ratio) {
        gsize <- as.numeric(sub("/\\d+$", "", as.character(ratio)))
        gcsize <- as.numeric(sub("^\\d+/", "", as.character(ratio)))
        return(gsize/gcsize)
    }
    ratio=parse_ratio(result$GeneRatio)
    # give color to ont
    require(ggthemes)
    cols=few_pal("Dark")(3)
    result$Description2=paste0(result$ont,": ",result$Description)
    a <- gsub(":.*","",sort(unique(result$Description2)))
    ab <- ifelse(a == "MF", cols[1], ifelse(a == "BP",cols[2],cols[3]))
    ggplot(result, aes_string(x="Cluster", y="Description2", size=ratio, color="p.adjust")) +
         geom_point() +
         scale_color_continuous(low="red", high="blue", name = "p.adjust", guide=guide_colorbar(reverse=TRUE)) +
        #scale_color_gradientn(name = "p.adjust", colors=sig_palette, guide=guide_colorbar(reverse=TRUE)) +
         ylab(NULL) + ggtitle(title) + theme_dose(font.size=cex) + scale_size(range=c(3, 8)) +
         theme(axis.text.y = element_text(colour = ab))
        #+ facet_grid(ont~.)
}


# save into rdata
save(universe, universeA, universeD, desc, godb, goterm2name,GOenrich, GOcompare, getGOLevel, dotplot.df, file="Tx-JGI_AD1.funcEnrich.rdata")

#########################################
## Functional enrichment for gene sets ##
#########################################
library(clusterProfiler)
library(ggplot2)
library(tidyr)
library(GO.db)
library(ggthemes)
load("Tx-JGI_AD1.funcEnrich.rdata")
load("sweeps.rdata")->l;l
# "pops_df" - summary of soft sweeps and selected genes"
# "gl.AD1A" "gl.AD1D" "gl.AD2A" "gl.AD2D" - selected gene lists
# "sw.AD1"  "sw.AD2" - soft sweeps

# selected genes AD1 vs AD2
geneL=list(AD1=c(gl.AD1A,gl.AD1D),AD2=c(gl.AD2A,gl.AD2D))
result=GOcompare(geneL,universe,filename="GOcompare.AD1vsAD2.txt")
png("GOcompare.AD1vsAD2.png",  width = 480*2, height = 480*2)
dotplot.df(result,cex=12)+ theme(axis.text.x = element_text(angle = 90, hjust = 1))
dev.off()


# selected genes AD1 vs AD2, by At and Dt
geneL=list(AD1=c(gl.AD1A),AD2=c(gl.AD2A))
resultA=GOcompare(geneL,universeA,filename="GOcompareAt.AD1vsAD2.txt")
resultA$Cluster = paste0(resultA$Cluster,"-At")
geneL=list(AD1=c(gl.AD1D),AD2=c(gl.AD2D))
resultD=GOcompare(geneL,universeD,filename="GOcompareDt.AD1vsAD2.txt")
resultD$Cluster = paste0(resultD$Cluster,"-Dt")
png("GOcompareSub.AD1vsAD2.png",  width = 480*2, height = 480*2)
res=rbind(resultD)
res$Cluster=factor(res$Cluster, levels=c("AD1-At","AD2-At","AD1-Dt","AD2-Dt"))
dotplot.df(res,cex=12)+ theme(axis.text.x = element_text(angle = 90, hjust = 1))
dev.off()

# no pathway enriched, regardless of q value
geneL=list(AD1=c(gl.AD1A,gl.AD1D),AD2=c(gl.AD2A,gl.AD2D))
result=KOcompare(geneL,universe,filename="KOcompare.AD1vsAD2.txt")
geneL=list(AD1=c(gl.AD1A),AD2=c(gl.AD2A))
KOcompare(geneL,universeA,filename="KOcompareAt.AD1vsAD2.txt")
geneL=list(AD1=c(gl.AD1D),AD2=c(gl.AD2D))
KOcompare(geneL,universeD,filename="KOcompareAt.AD1vsAD2.txt")

