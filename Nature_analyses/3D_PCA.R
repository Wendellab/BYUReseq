#PCA plots for 1000 polyploid resequenced genomes
#packages needed: 

library(rgl)
library(scatterplot3d)
library(RColorBrewer)

#read data from file
datain <- read.csv("M10m10.Chr26.eigenstrat.pca.evec.csv", header = TRUE)

#set each Population Code to a different Brewer color
(jColors <- with(datain,
         data.frame(Pop_Code = levels(Pop_Code),
                    color = I(brewer.pal(nlevels(Pop_Code), name = 'Paired')))))      

#link all Population codes to new Brewer Color scheme
data.frame(subset(datain, select = c(EV1, EV2, EV3, Pop_Code)),
           matchRetVal = match(datain$Pop_Code, jColors$Pop_Code))


#make 3D plot using 3 EV and colors generated above. 
plot3d(datain$EV1, datain$EV2, datain$EV3, col = jColors$color[match(datain$Pop_Code, jColors$Pop_Code)], 
       main = "All Data", size = 15)

#add legend to plot
legend3d("topright", legend = levels(datain$Pop_Code), pch = 16, col = jColors$color, cex=3, inset=c(0.2))
