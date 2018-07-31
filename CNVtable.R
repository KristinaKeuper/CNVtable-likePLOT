library(reshape2)
library(ggplot2)
library(gtools)

setwd("D:/DIRECTORY")

#Get proper sample names from the files
nameFromPath <- function(path)
{
    name.list <- unlist(strsplit(path, '/'))
    name.tmp <- name.list[length(name.list)]
    name.tmp <- unlist(strsplit(name.tmp, '\\.'))[1]
    name <- unlist(strsplit(name.tmp, '_dedup'))[1]
    name
}

CNV_DIR="D:/DIRECTORY"
cnv_files <- list.files(path=CNV_DIR, pattern = "*_CNVs", full.names = T)

#get sample names
cnv_names <- lapply(cnv_files, nameFromPath)
columns <- c("chr", "start", 'end', 'number', 'type', 'name')

#read all files at once
cnv.list <- lapply(cnv_files, read.table, header=FALSE, sep='\t', stringsAsFactors = FALSE, col.names = columns)
names(cnv.list) <- cnv_names

#combine all files to one data frame
cnv.df <- melt(cnv.list, id.vars=c('chr','start', 'end', 'number', 'type', 'name'))
cnv.df[is.na(cnv.df)] <- 0
colnames(cnv.df) <- c("chr", "start", "end", "number", "type", 'name', "rawsample")

#filtering CNV smaller the given threshold
cnv.filtered <- cnv.df
cnv.filtered[((cnv.filtered$end - cnv.filtered$start) <= 500),"number"] <- 2
cnv.filtered[((cnv.filtered$end - cnv.filtered$start) <= 500),"type"] <- "normal"
cnv.plot <- cnv.filtered

#sorting of samples
sortedNames <- c("","")
sortedopposite <- rev(sortedNames)
cnv.plot$rawsample <- factor(cnv.plot$rawsample, levels = sortedopposite)

#limit the CN to 4
cnv.plot$number[cnv.plot$number > 4] <- 4
cnv.plot$number <- factor(cnv.plot$number, levels=c(0,1,2,3,4))

#set up chromosome levels
chromosomes <- mixedsort(as.character(unique((cnv.plot$chr))))
cnv.plot$chr <- factor(cnv.plot$chr, levels=chromosomes)

#legend 
g_legend<-function(a.gplot){ 
    tmp <- ggplot_gtable(ggplot_build(a.gplot)) 
    leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
    legend <- tmp$grobs[[leg]] 
    return(legend)} 

#plot
p <- ggplot(cnv.plot)
pdf(file="outputname.pdf", width=8, height=5, pointsize=6, useDingbats=FALSE)
cnv_number <- p + geom_segment(data = subset(cnv.plot, number != 2), aes(x=start, xend=end, y=rawsample, yend=rawsample, color=number), size = 5) +
    scale_color_manual(name="Copy Number\n",values=c ("midnightblue","dodgerblue","white","hotpink", "darkred"),
                       labels=c(0, 1, "2 or unknown", 3, "4 or more"), limits=c(0, 1, 2, 3, 4)) +
    facet_grid(. ~ chr, scales = "free", space = "free_y") +
    theme(
          panel.border = element_rect(color = "black", fill = NA, size = .1),
          strip.background = element_rect(color = "black", size =.3),
          axis.line.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          panel.grid.minor=element_blank(),
          panel.grid.major.x=element_blank(),
          panel.grid.major.y=element_blank(),
          legend.position="top",
          legend.title = element_text(face="bold"),
          panel.background= element_blank(),
          plot.background=element_blank(),
          legend.key = element_rect(fill = "grey", size = 0.05)
    ) +
    labs(title="",x = "", y="")
cnv_number
dev.off()
