library(reshape)

AD1.in.AD2 <- read.table("all.AD1.introgression.into.AD2", sep="")
AD2.in.AD1 <- read.table("all.AD2.introgression.into.AD1", sep="")
wildDom <- read.table("Wild.or.Dom.txt", sep="\t", header=T)

AD2.introgression <- unique(AD1.in.AD2[,c(1:4)])
AD2.introgression$length <- AD2.introgression$V4 - AD2.introgression$V3
AD2.introgression <- AD2.introgression[,c(1,2,5)]

table.AD2.introgression <- table(AD2.introgression[,c(1,2)])  
total.AD2.introgression <- cast(AD2.introgression, V1~V2, sum)


AD1.introgression <- unique(AD2.in.AD1[,c(1:4)])
AD1.introgression$length <- AD1.introgression$V4 - AD1.introgression$V3
AD1.introgression <- AD1.introgression[,c(1,2,5)]

table.AD1.introgression <- table(AD1.introgression[,c(1,2)])  
total.AD1.introgression <- cast(AD1.introgression, V1~V2, sum)


wild <- wildDom[wildDom$Category=="Wild",1]
AD2.introgression.genes <- unique(AD1.in.AD2[,c(1,2,8)])
table.AD2.introgression.genes <- table(AD2.introgression.genes[,c(1:2)])
total.AD2.introgression.genes <- table(AD2.introgression.genes[,c(1)])
AD2.introgression.genes.nowild <- AD2.introgression.genes[ ! AD2.introgression.genes$V1 %in% wild, ]

AD1.introgression.genes <- unique(AD2.in.AD1[,c(1,2,8)])
table.AD1.introgression.genes <- table(AD1.introgression.genes[,c(1:2)])
total.AD1.introgression.genes <- table(AD1.introgression.genes[,c(1)])
AD1.introgression.genes.nowild <- AD1.introgression.genes[ ! AD1.introgression.genes$V1 %in% wild, ]







write.table(table.AD2.introgression, file="table.AD2.introgression", quote=F, sep="\t")
write.table(total.AD2.introgression, file="total.AD2.introgression", quote=F, sep="\t")
write.table(table.AD2.introgression.genes, file="table.AD2.introgression.genes", quote=F, sep="\t")
write.table(total.AD2.introgression.genes, file="total.AD2.introgression.genes", quote=F, sep="\t")
write.table(AD2.introgression.genes.nowild, file="AD2.introgression.genes.nowild", quote=F, sep="\t")

write.table(table.AD1.introgression, file="table.AD1.introgression", quote=F, sep="\t")
write.table(total.AD1.introgression, file="total.AD1.introgression", quote=F, sep="\t")
write.table(table.AD1.introgression.genes, file="table.AD1.introgression.genes", quote=F, sep="\t")
write.table(total.AD1.introgression.genes, file="total.AD1.introgression.genes", quote=F, sep="\t")
write.table(AD1.introgression.genes.nowild, file="AD1.introgression.genes.nowild", quote=F, sep="\t")


### find length and region number outliers
total.AD1.introgression <- as.data.frame(total.AD1.introgression)
AD1len <- row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A01)) > 3))]
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A02)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A03)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A04)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A05)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A06)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A07)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A08)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A09)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A10)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A11)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A12)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$A13)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D01)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D02)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D03)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D04)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D05)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D06)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D07)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D08)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D09)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D10)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D11)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D12)) > 3))])
AD1len <- append(AD1len, row.names(total.AD1.introgression)[c(which(abs(scale(total.AD1.introgression$D13)) > 3))])

table.AD1.introgression <- as.data.frame.matrix(table.AD1.introgression)
AD1reg <- row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A01)) > 3))]
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A02)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A03)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A04)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A05)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A06)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A07)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A08)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A09)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A10)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A11)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A12)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$A13)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D01)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D02)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D03)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D04)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D05)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D06)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D07)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D08)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D09)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D10)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D11)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D12)) > 3))])
AD1reg <- append(AD1reg, row.names(table.AD1.introgression)[c(which(abs(scale(table.AD1.introgression$D13)) > 3))])


total.AD2.introgression <- as.data.frame(total.AD2.introgression)
row.names(total.AD2.introgression) <- total.AD2.introgression$V1
AD2len <- row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A01)) > 3))]
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A02)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A03)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A04)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A05)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A06)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A07)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A08)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A09)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A10)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A11)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A12)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$A13)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D01)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D02)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D03)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D04)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D05)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D06)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D07)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D08)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D09)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D10)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D11)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D12)) > 3))])
AD2len <- append(AD2len, row.names(total.AD2.introgression)[c(which(abs(scale(total.AD2.introgression$D13)) > 3))])

table.AD2.introgression <- as.data.frame.matrix(table.AD2.introgression)
AD2reg <- row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A01)) > 3))]
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A02)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A03)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A04)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A05)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A06)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A07)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A08)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A09)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A10)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A11)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A12)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$A13)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D01)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D02)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D03)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D04)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D05)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D06)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D07)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D08)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D09)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D10)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D11)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D12)) > 3))])
AD2reg <- append(AD2reg, row.names(table.AD2.introgression)[c(which(abs(scale(table.AD2.introgression$D13)) > 3))])

as.data.frame(table(AD1len))
as.data.frame(table(AD1reg))
as.data.frame(table(AD2len))
as.data.frame(table(AD2reg))



