# PlottingTelmatherinaR

#install.packages(c("tidyverse", "ape"))
#install.packages("BiocManager")
library(BiocManager)
BiocManager::install("ggtree")
library(tidyverse)
library(ape)
library(ggtree)

#####################################################

#distance matrix

setwd("/Users/sophiegresham/Desktop/UNHAS/popgen/TelmatherinaPopgen.results")

plink.dist <- read.table(file = "Telmatherina38.pass.snps.biallelic.Chr1.dist",
                         header = FALSE, sep = "\t", dec = ".") #Distance matrix

plink.id <- as.data.frame(read.table(file = "Telmatherina38.pass.snps.biallelic.Chr1.dist.id", 
                                     header = FALSE, sep = "\t", dec = ".")) #Sample IDs

str(plink.dist)


plink.matrix <- as.matrix(plink.dist)

dimnames(plink.matrix) <- list(plink.id[,1], plink.id[,1])

plink.matrix

plink.dist.df<-  as_tibble(plink.matrix, rownames="A") %>%
  pivot_longer(-A,names_to = "B", values_to = "distances") 

view(plink.dist.df)

plink.dist.df %>%
  ggplot(aes(x=A, y=B, fill=distances)) +
  geom_tile()

plink.dist.df %>%
  ggplot(aes(x=A, y=B, fill=distances)) +
  geom_tile()+
  coord_equal()+ #making the tiles into squares
  scale_fill_gradient(low = "#FF0000", high = "#FFFFFF", name=NULL) + #changing the colour scheme
  labs(x="Samples", y="Samples") + #changing axis labels
  theme_classic()+ #gets rid of the grey background of the base ggplot2 theme
  theme(axis.line = element_blank(), #removes axes lines and ticks
        axis.ticks = element_blank(),
        axis.text = element_text(size=8), #changes the font size
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) #rotates x axis labels by 90 degrees to make them readable

#change order - by tree
#make again but without MP3 and MP3

#####################################################

#Making and plotting a neighbour-joining (NJ) tree

NJ.tree <- ape::nj(plink.matrix)

plot(x=NJ.tree)

#remove MP3, root to MP2 and then remove MP2
NJ.tree2 <- drop.tip(NJ.tree, "MP3")
NJ.tree3 <- root(NJ.tree2, outgroup = "MP2")
NJ.tree4 <- drop.tip(NJ.tree3, "MP2")


#Plot the unrooted NJ tree
plot(x=NJ.tree4, type="unrooted", cex=0.5)

#Plot a rooted NJ tree
plot(x=NJ.tree4)

#get tip labels in the the order of the phylogeny
is_tip <- NJ.tree4$edge[,2] <= length(NJ.tree4$tip.label)
ordered_tips <- NJ.tree4$edge[is_tip, 2]
labels_order<- NJ.tree4$tip.label[ordered_tips]


write.tree(NJ.tree4, file = "NJ.tree.nwk", append = FALSE,
           digits = 10, tree.names = FALSE)

tree <- read.tree("NJ.tree.nwk")

ggplot(tree) + geom_tree() + geom_tiplab()
ggtree(tree, layout="roundrect")+ geom_tiplab()
ggtree(tree, layout="slanted")+ geom_tiplab()
ggtree(tree, layout="ellipse")+ geom_tiplab()
ggtree(tree, layout="circular")+ geom_tiplab()
ggtree(tree, layout="fan", open.angle=120)+ geom_tiplab()
ggtree(tree, layout="equal_angle")+ geom_tiplab()
ggtree(tree, layout="daylight")+ geom_tiplab()
ggtree(tree, branch.length='none')+ geom_tiplab()
ggtree(tree, layout="ellipse", branch.length="none")+ geom_tiplab()
ggtree(tree, branch.length='none', layout='circular')+ geom_tiplab()
ggtree(tree, layout="daylight", branch.length = 'none')+ geom_tiplab()

ggplot(tree) + geom_tree() + theme_tree()+ geom_tiplab()

ggtree(tree)+ geom_text(aes(label=node), hjust=-.3) #This shows node labels
#39 (sharpfins), 70 (bonti/river), 62 (roundfins)


ggtree(tree) + 
  geom_tiplab(align = TRUE) + 
  geom_hilight(node=39, fill="blue") +
  geom_hilight(node=70, fill="green") +
  geom_hilight(node=62, fill="red") +
  geom_cladelabel(node=39, label="Sharpfin", 
                  color="blue", offset=180, align=TRUE) +
  geom_cladelabel(node=70, label="Bonti/River", 
                  color="green", offset=180, align=TRUE) +
  geom_cladelabel(node=62, label="Roundfin", 
                  color="red", offset=180, align=TRUE) +
  theme_tree() +
  coord_cartesian(xlim = c(0, 1300))

aligned_tree <- ggtree_object + geom_tiplab(align = TRUE, aes(label= "")) + theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))


#######

#distance matrix with tree

plink.dist <- read.table(file = "Telmatherina38.pass.snps.biallelic.Chr1.dist",
                         header = FALSE, sep = "\t", dec = ".") #Distance matrix

plink.id <- as.data.frame(read.table(file = "Telmatherina38.pass.snps.biallelic.Chr1.dist.id", 
                                     header = FALSE, sep = "\t", dec = ".")) #Sample IDs

str(plink.dist)


plink.matrix <- as.matrix(plink.dist)

dimnames(plink.matrix) <- list(plink.id[,1], plink.id[,1])

plink.matrix

plink.dist.df<-  as_tibble(plink.matrix, rownames="A") %>%
  pivot_longer(-A,names_to = "B", values_to = "distances") 

view(plink.dist.df)

#remove MP2 and MP3 - remove rows where A or B is MP2 or MP3
plink.dist.df2 <- plink.dist.df[plink.dist.df$A != "MP2" & plink.dist.df$A != "MP3" & plink.dist.df$B != "MP2" & plink.dist.df$B != "MP3", ]          

#change the order of the samples according to the phylogeny
plink.dist.df2$A <- factor(plink.dist.df2$A, levels = labels_order)
plink.dist.df2$B <- factor(plink.dist.df2$B, levels = labels_order)


plink.dist.df2 %>%
  ggplot(aes(x=A, y=B, fill=distances)) +
  geom_tile()

plink.dist.df2 %>%
  ggplot(aes(x=A, y=B, fill=distances)) +
  geom_tile()+
  coord_equal()+ #making the tiles into squares
  #scale_fill_gradient(low = "#FF0000", high = "#FFFFFF", name=NULL) + #changing the colour scheme
  scale_fill_distiller(palette = "Spectral", direction = -1) + 
  labs(x="Samples", y="Samples") + #changing axis labels
  theme_classic()+ #gets rid of the grey background of the base ggplot2 theme
  theme(axis.line = element_blank(), #removes axes lines and ticks
        axis.ticks = element_blank(),
        axis.text = element_text(size=8), #changes the font size
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) #rotates x axis labels by 90 degrees to make them readable



