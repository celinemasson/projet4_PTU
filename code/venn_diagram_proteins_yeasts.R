### Diagramme de Venn : présence des protéines ###

## Installation des packages ## 
#install.packages("VennDiagram")
#install.packages("viridis") 
library(VennDiagram)
library(viridis)
library(tidyverse)

## Lecture des données ##
data.path <- ("~./data/projet4/data/blast/summary_protein.tsv")
df <- read.table(data.path, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

## Enregistrement du diagramme de Venn ##
output.path <- ("~./data/projet4/data/blast/venn_proteins_yeasts.png")
png(output.path, width = 800, height = 800)


## Conversion des valeurs TRUE et FALSE en données de type logical ##
df$YJS7890 <- as.logical(df$YJS7890)
df$YJS7895 <- as.logical(df$YJS7895)
df$YJS8039 <- as.logical(df$YJS8039)


## Extraction des informations par souche ##
set1 <- df$Protein[df$YJS7890 == TRUE]  
set2 <- df$Protein[df$YJS7895 == TRUE]
set3 <- df$Protein[df$YJS8039 == TRUE]


## Génération de couleurs Viridis ##
colors <- viridis(3)  


## Génération du diagramme de Venn ##

venn.plot <- draw.triple.venn(
  area1 = length(set1),
  area2 = length(set2),
  area3 = length(set3),
  n12 = length(intersect(set1, set2)),
  n23 = length(intersect(set2, set3)),
  n13 = length(intersect(set1, set3)),
  n123 = length(intersect(intersect(set1, set2), set3)),
  category = c("YJS7890", "YJS7895", "YJS8039"),
  fill = colors,    
  lty = "solid",
  cex = 2,
  cat.cex = 2,
  cat.col = colors  
)

grid.draw(venn.plot)


dev.off()






