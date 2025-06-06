####Load packages####
library(ggtree)
library(ggplot2)
library(tidyverse)
library(ape)

x <- as_tibble(Tree1)
x <-as.phylo(x)
View(x)
####Load data & set directory Tree 1####
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/VipTree/Tree1")
Tree1 <- read.tree("Tree1.newick")

ggtree(x)+
  geom_tree(size = 0.5, linetype=1)+
  geom_nodepoint(color="#ADD8E6", alpha=1/2, size=6)+
  geom_tippoint(color="#FDAC4F", shape=16, size=2)+
  geom_tiplab(size = 3)+
  geom_hilight(node =64, fill = "blue", align = "both", xmin = 0.446)+
  geom_hilight(node =60, fill = "purple", align = "both", xmin = 0.437)+
  geom_hilight(node =111, fill = "cornflowerblue", align = "both", xmin = 0.24)+
  theme_classic()+
  theme_tree()+
  geom_treescale(fontsize=4, linesize=1, offset=0.5, y = -1)
ggsave("Tree1.png", width = 15, height =25)

#####Load data & set directory Tree 2#### 
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/VipTree/Tree2")
Tree2 <- read.tree("Tree2.newick")

ggtree(Tree2)+
  geom_tree(size = 0.5, linetype=1)+
  geom_nodepoint(color="#ADD8E6", alpha=1/2, size=6)+
  geom_tippoint(color="#FDAC4F", shape=16, size=2)+
  geom_tiplab(size = 4)+
  theme_classic()+
  theme_tree()+
  geom_treescale(fontsize=4, linesize=1, offset=0.5, y = -1)
ggsave("Tree2.png", width = 15, height =25)

#####Load data & set directory Tree 3####
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/VipTree/Tree3")
Tree3 <- read.tree("Tree3.newick")

ggtree(Tree3)+
  geom_tree(size = 0.5, linetype=1)+
  geom_nodepoint(color="#ADD8E6", alpha=1/2, size=6)+
  geom_tippoint(color="#FDAC4F", shape=16, size=2)+
  geom_tiplab(size = 5)+
  geom_hilight(node =3, fill = "gold")+
  geom_cladelabel(node=1, label="Some random clade", 
                  color="gold", offset =0.08, align = TRUE)+
  theme_classic()+
  theme_tree()+
  geom_treescale(fontsize=4, linesize=1, offset=0.5, y = -1)

ggsave(Tree3, "Tree3.png", width = 8, height =6)

#####Load data & set directory Tree 4#### 
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/VipTree/Tree4")
Tree4 <- read.tree("Tree4.newick")

ggtree(Tree4)+
  geom_tree(size = 0.5, linetype=1)+
  geom_nodepoint(color="#ADD8E6", alpha=1/2, size=6)+
  geom_tippoint(color="#FDAC4F", shape=16, size=2)+
  geom_tiplab(size = 5)+
  geom_hilight(node =3, fill = "gold")+
  geom_cladelabel(node=1, label="Some random clade", 
                  color="gold", offset =0.08, align = TRUE)+
  theme_classic()+
  theme_tree()+
  geom_treescale(fontsize=4, linesize=1, offset=0.5, y = -1)

ggsave(Tree4, "Tree1.png", width = 8, height =6)

#####Load data & set directory Tree 5#### 
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/VipTree/Tree5")
Tree5 <- read.tree("Tree5.newick")

ggtree(Tree5)+
  geom_tree(size = 0.5, linetype=1)+
  geom_nodepoint(color="#ADD8E6", alpha=1/2, size=6)+
  geom_tippoint(color="#FDAC4F", shape=16, size=2)+
  geom_tiplab(size = 5)+
  geom_hilight(node =3, fill = "gold")+
  geom_cladelabel(node=1, label="Some random clade", 
                  color="gold", offset =0.08, align = TRUE)+
  theme_classic()+
  theme_tree()+
  geom_treescale(fontsize=4, linesize=1, offset=0.5, y = -1)
ggsave(Tree5, "Tree1.png", width = 8, height =6)

setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/VipTree/Tree6")

#####Load data & set directory Tree 6#### 
Tree6 <- read.tree("Tree6.newick")

ggtree(Tree6)+
  geom_tree(size = 0.5, linetype=1)+
  geom_nodepoint(color="#ADD8E6", alpha=1/2, size=6)+
  geom_tippoint(color="#FDAC4F", shape=16, size=2)+
  geom_tiplab(size = 5)+
  geom_hilight(node =3, fill = "gold")+
  geom_cladelabel(node=1, label="Some random clade", 
                  color="gold", offset =0.08, align = TRUE)+
  theme_classic()+
  theme_tree()+
  geom_treescale(fontsize=4, linesize=1, offset=0.5, y = -1)
ggsave(Tree6, "Tree6.png", width = 8, height =6)

msaplot(p=ggtree(Tree6), fasta="/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/VipTree/Tree3/Tree3.fasta", window=c(150, 175))


