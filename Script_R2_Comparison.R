############################################################################################################################################################################
#Activate necessary packages
############################################################################################################################################################################

library("spatstat")
library("fields")  

library("ggplot2")
library("ggbeeswarm")
library("patchwork")
library("plotrix")
library("pgirmess")
library("RColorBrewer")

############################################################################################################################################################################
#Import Files
############################################################################################################################################################################
setwd("LOCATION/EXPERIMENT/COMPARISON")
file1<-read.table("X:/Giacomo Giacomelli/Collaborations/FtsK/Pen_SPT_tables/FtsK_PAM/output_rotated1.txt", header=T, sep="\t")   
file2<-read.table("X:/Giacomo Giacomelli/Collaborations/FtsK/Pen_SPT_tables/FtsK_PAM/output_rotated2.txt", header=T, sep="\t")   
file3<-read.table("X:/Giacomo Giacomelli/Collaborations/FtsK/Pen_SPT_tables/FtsK_PAM/output_rotated3.txt", header=T, sep="\t")   
file4<-read.table("X:/Giacomo Giacomelli/Collaborations/FtsK/Pen_SPT_tables/FtsK_PAM/output_rotated4.txt", header=T, sep="\t")   
file5<-read.table("X:/Giacomo Giacomelli/Collaborations/FtsK/Pen_SPT_tables/FtsK_PAM/output_rotated5.txt", header=T, sep="\t")   
fileW<-rbind(file1,file2,file3,file4,file5)
