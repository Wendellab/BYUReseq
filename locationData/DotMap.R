setwd("...")

install.packages("RColorBrewer")
install.packages("ggplot2")
install.packages("ggmap")
install.packages("maps")

library("ggmap")
library("maps")
library("ggplot2")
library("RColorBrewer")

# Cultivar : "#1a9850"
# Landrace1: "#f46d43"
# Landrace2: "#fdae61"
# Wild:      "#d73027"
# AD4:			 "#8c510a"

################ 2018.08.24################

############## AD1.PerfectTree.Wild (Only Carribeen and Central America region)###

mytable <- read.csv(file="./AD1.Perfect.TreeWild.csv",header = T)
mp <- NULL
world_map <- borders("world", colour="gray50", fill="gray80")
mp <- ggplot(mytable, aes(x=mytable$Longitude, y=mytable$Latitude)) + world_map
mp
mp <- mp +scale_size_area("Count")+ geom_count(aes(colour=Type))+scale_color_manual(values=alpha(c("#f46d43", "#fdae61", "#d73027"),0.8)) + labs(y="Latitude",x="Longitude") + xlim(c(-120, -55)) + ylim(c(-5, 35))
mp

############# Gh.All.WithPublic ###############

mytable <- read.csv(file="./Gh.All.WithPublic.csv",header = T)
mp <- NULL
world_map <- borders("world", colour="gray50", fill="gray80")
mp <- ggplot(mytable, aes(x=mytable$Longitude, y=mytable$Latitude)) + world_map
mp
mp <- mp +scale_size_area("Count")+ geom_count(aes(colour=Type))+scale_color_manual(values=alpha(c("#1a9850","#f46d43", "#fdae61", "#d73027"),0.8)) + labs(y="Latitude",x="Longitude") + xlim(c(-170,191))+ylim(c(-54, 78))
mp

########### Gb.All.WithPublic ###### Wild and Cultivar #######

mytable <- read.csv(file="./Gb.All.WithPublic.csv",header = T)
mp <- NULL
world_map <- borders("world", colour="gray50", fill="gray80")
mp <- ggplot(mytable, aes(x=mytable$Lon2,y=mytable$Lat2)) + world_map
mp
mp <- mp + geom_count(aes(colour=Type1))+scale_size_area("Count")+scale_color_manual(values=alpha(c("#1a9850","#f46d43"),0.7)) + labs(y="Latitude",x="Longitude") + xlim(c(-170,191))+ylim(c(-54, 78))
mp

########### Gb.All.WithPublic ###### Wild , Landrace1, Landrace2 and Cultivar #######

mytable <- read.csv(file="./Gb.All.WithPublic.csv",header = T)
mp <- NULL
world_map <- borders("world", colour="gray50", fill="gray80")
mp <- ggplot(mytable, aes(x=mytable$Lon2,y=mytable$Lat2)) + world_map
mp
mp <- mp + geom_count(aes(colour=Type))+scale_size_area("Count")+scale_color_manual(values=alpha(c("#1a9850","#f46d43", "#fdae61", "#d73027"),0.8)) + labs(y="Latitude",x="Longitude") + xlim(c(-170,191))+ylim(c(-54, 78))
mp


############## Public data (364 Samples) ###########

mytable2 <- read.csv(file="./PublicData.OneSheet.Filtered.csv",header = T)
mp <- NULL
world_map <- borders("world", colour="gray50", fill="gray80")
mp <- ggplot(mytable2, aes(x=Longitude, y=Latitude)) + world_map
mp
mp <- mp +scale_size_area("Count")+ geom_count(aes(colour=Type,shape=Species,alpha=0.8))+ scale_shape_manual(values=c(16, 9)) + scale_color_manual(values=c("#1b9e77", "#d95f02")) + labs(y="Latitude",x="Longitude") + xlim(c(-180, 180)) + ylim(c(-55, 85))
mp
