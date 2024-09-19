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
library("reshape")

############################################################################################################################################################################
#Import Files
############################################################################################################################################################################
setwd("LOCATION/EXPERIMENT/COMPARISON")
C:\\LOCATION\\LOCATION\\LOCATION\\CONDITION\\LOCALIZATION_TABLES_FOLDER
file1<-read.table("C:/LOCATION/LOCATION/LOCATION/CONDITION1/BINARY_FOLDER/Cells1/OUTPUT_ROTATED1.txt", header=T, sep="\t")   
file2<-read.table("C:/LOCATION/LOCATION/LOCATION/CONDITION1/BINARY_FOLDER/Cells2/OUTPUT_ROTATED2.txt", header=T, sep="\t") 
file3<-read.table("C:/LOCATION/LOCATION/LOCATION/CONDITION1/BINARY_FOLDER/Cells3/OUTPUT_ROTATED3.txt", header=T, sep="\t")   
file4<-read.table("C:/LOCATION/LOCATION/LOCATION/CONDITION1/BINARY_FOLDER/Cells4/OUTPUT_ROTATED4.txt", header=T, sep="\t") 
file5<-read.table("C:/LOCATION/LOCATION/LOCATION/CONDITION1/BINARY_FOLDER/Cells5/OUTPUT_ROTATED5.txt", header=T, sep="\t")   
fileW<-rbind(file1,file2,file3,file4,file5)

file1<-read.table("C:/LOCATION/LOCATION/LOCATION/CONDITION2/BINARY_FOLDER/Cells1/OUTPUT_ROTATED1.txt", header=T, sep="\t")   
file2<-read.table("C:/LOCATION/LOCATION/LOCATION/CONDITION2/BINARY_FOLDER/Cells2/OUTPUT_ROTATED2.txt", header=T, sep="\t") 
file3<-read.table("C:/LOCATION/LOCATION/LOCATION/CONDITION2/BINARY_FOLDER/Cells3/OUTPUT_ROTATED3.txt", header=T, sep="\t")   
file4<-read.table("C:/LOCATION/LOCATION/LOCATION/CONDITION2/BINARY_FOLDER/Cells4/OUTPUT_ROTATED4.txt", header=T, sep="\t") 
file5<-read.table("C:/LOCATION/LOCATION/LOCATION/CONDITION2/BINARY_FOLDER/Cells5/OUTPUT_ROTATED5.txt", header=T, sep="\t")   
fileD<-rbind(file1,file2,file3,file4,file5)

fileComparison<-rbind(fileW,fileD)
write.table(fileComparison, file="Comparison_DATA.txt",sep="\t",row.names = FALSE, quote=FALSE)

############################################################################################################################################################################
#Calculate Differential_Density_MAP
############################################################################################################################################################################
####fileW/fileD (red colour means more aboundant in fileW, blue in fileD)

interval<-25
AVG_Cell1<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_Cell1[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_Cell1)[1]<-"Length"
AVG_Cell2<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_Cell2[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_Cell2)[1]<-"Length"
AVG_CellT<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_CellT[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_CellT)[1]<-"Length"

AVG_Cell1A<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_Cell1A[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_Cell1A)[1]<-"Length"
AVG_Cell2A<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_Cell2A[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_Cell2A)[1]<-"Length"
AVG_CellTA<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_CellTA[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_CellTA)[1]<-"Length"

AVG_Cell1B<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_Cell1B[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_Cell1B)[1]<-"Length"
AVG_Cell2B<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_Cell2B[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_Cell2B)[1]<-"Length"
AVG_CellTB<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_CellTB[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_CellTB)[1]<-"Length"

AVG_Cell1C<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_Cell1C[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_Cell1C)[1]<-"Length"
AVG_Cell2C<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_Cell2C[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_Cell2C)[1]<-"Length"
AVG_CellTC<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_CellTC[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_CellTC)[1]<-"Length"

AVG_Cell1D<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_Cell1D[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_Cell1D)[1]<-"Length"
AVG_Cell2D<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_Cell2D[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_Cell2D)[1]<-"Length"
AVG_CellTD<-data.frame(matrix(NA, nrow = 80, ncol = 33))
AVG_CellTD[1]<-as.character(seq(from=interval/2,to=2000,by=interval))
colnames(AVG_CellTD)[1]<-"Length"

for (k in 1:((800/interval))) {
  for (i in 1:((2000/interval))) {
    AVG_Cell1[i,k+1]<-length(fileW[fileW$Avg_X>=(0+(interval*(i-1))) & fileW$Avg_X<(0+(interval*(i))) & fileW$Avg_Y>=(0+(interval*(k-1))) & fileW$Avg_Y<(0+(interval*(k))),]$Index)/length(fileW$Index)
    AVG_Cell2[i,k+1]<-length(fileD[fileD$Avg_X>=(0+(interval*(i-1))) & fileD$Avg_X<(0+(interval*(i))) & fileD$Avg_Y>=(0+(interval*(k-1))) & fileD$Avg_Y<(0+(interval*(k))),]$Index)/length(fileD$Index)
    AVG_CellT[i,k+1]<-AVG_Cell1[i,k+1]-AVG_Cell2[i,k+1]
    
    AVG_Cell1A[i,k+1]<-length(fileW[fileW$CellDiameter<2000 & fileW$Avg_X>=(0+(interval*(i-1))) & fileW$Avg_X<(0+(interval*(i))) & fileW$Avg_Y>=(0+(interval*(k-1))) & fileW$Avg_Y<(0+(interval*(k))),]$Index)/length(fileW[fileW$CellDiameter<2000,]$Index)
    AVG_Cell2A[i,k+1]<-length(fileD[fileD$CellDiameter<2000 & fileD$Avg_X>=(0+(interval*(i-1))) & fileD$Avg_X<(0+(interval*(i))) & fileD$Avg_Y>=(0+(interval*(k-1))) & fileD$Avg_Y<(0+(interval*(k))),]$Index)/length(fileD[fileD$CellDiameter<2000,]$Index)
    AVG_CellTA[i,k+1]<-AVG_Cell1A[i,k+1]-AVG_Cell2A[i,k+1]
    
    AVG_Cell1B[i,k+1]<-length(fileW[fileW$CellDiameter>=2000 & fileW$CellDiameter<2500 & fileW$Avg_X>=(0+(interval*(i-1))) & fileW$Avg_X<(0+(interval*(i))) & fileW$Avg_Y>=(0+(interval*(k-1))) & fileW$Avg_Y<(0+(interval*(k))),]$Index)/length(fileW[fileW$CellDiameter>=2000 & fileW$CellDiameter<2500,]$Index)
    AVG_Cell2B[i,k+1]<-length(fileD[fileD$CellDiameter>=2000 & fileD$CellDiameter<2500 & fileD$Avg_X>=(0+(interval*(i-1))) & fileD$Avg_X<(0+(interval*(i))) & fileD$Avg_Y>=(0+(interval*(k-1))) & fileD$Avg_Y<(0+(interval*(k))),]$Index)/length(fileD[fileD$CellDiameter>=2000 & fileD$CellDiameter<2500,]$Index)
    AVG_CellTB[i,k+1]<-AVG_Cell1B[i,k+1]-AVG_Cell2B[i,k+1]
    
    AVG_Cell1C[i,k+1]<-length(fileW[fileW$CellDiameter>=2500 & fileW$CellDiameter<3000 & fileW$Avg_X>=(0+(interval*(i-1))) & fileW$Avg_X<(0+(interval*(i))) & fileW$Avg_Y>=(0+(interval*(k-1))) & fileW$Avg_Y<(0+(interval*(k))),]$Index)/length(fileW[fileW$CellDiameter>=2500 & fileW$CellDiameter<3000,]$Index)
    AVG_Cell2C[i,k+1]<-length(fileD[fileD$CellDiameter>=2500 & fileD$CellDiameter<3000 & fileD$Avg_X>=(0+(interval*(i-1))) & fileD$Avg_X<(0+(interval*(i))) & fileD$Avg_Y>=(0+(interval*(k-1))) & fileD$Avg_Y<(0+(interval*(k))),]$Index)/length(fileD[fileD$CellDiameter>=2500 & fileD$CellDiameter<3000,]$Index)
    AVG_CellTC[i,k+1]<-AVG_Cell1C[i,k+1]-AVG_Cell2C[i,k+1]
    
    AVG_Cell1D[i,k+1]<-length(fileW[fileW$CellDiameter>=3000 & fileW$Avg_X>=(0+(interval*(i-1))) & fileW$Avg_X<(0+(interval*(i))) & fileW$Avg_Y>=(0+(interval*(k-1))) & fileW$Avg_Y<(0+(interval*(k))),]$Index)/length(fileW[fileW$CellDiameter>=3000,]$Index)
    AVG_Cell2D[i,k+1]<-length(fileD[fileD$CellDiameter>=3000 & fileD$Avg_X>=(0+(interval*(i-1))) & fileD$Avg_X<(0+(interval*(i))) & fileD$Avg_Y>=(0+(interval*(k-1))) & fileD$Avg_Y<(0+(interval*(k))),]$Index)/length(fileD[fileD$CellDiameter>=3000,]$Index)
    AVG_CellTD[i,k+1]<-AVG_Cell1D[i,k+1]-AVG_Cell2D[i,k+1]
  }
  colnames(AVG_Cell1)[k+1]<-as.character(seq(from=interval/2,to=800,by=interval)[k])
  colnames(AVG_Cell2)[k+1]<-as.character(seq(from=interval/2,to=2000,by=interval)[k])
  colnames(AVG_CellT)[k+1]<-as.character(seq(from=interval/2,to=2000,by=interval)[k])
  
  colnames(AVG_Cell1A)[k+1]<-as.character(seq(from=interval/2,to=800,by=interval)[k])
  colnames(AVG_Cell2A)[k+1]<-as.character(seq(from=interval/2,to=2000,by=interval)[k])
  colnames(AVG_CellTA)[k+1]<-as.character(seq(from=interval/2,to=2000,by=interval)[k])
  
  colnames(AVG_Cell1B)[k+1]<-as.character(seq(from=interval/2,to=800,by=interval)[k])
  colnames(AVG_Cell2B)[k+1]<-as.character(seq(from=interval/2,to=2000,by=interval)[k])
  colnames(AVG_CellTB)[k+1]<-as.character(seq(from=interval/2,to=2000,by=interval)[k])
  
  colnames(AVG_Cell1C)[k+1]<-as.character(seq(from=interval/2,to=800,by=interval)[k])
  colnames(AVG_Cell2C)[k+1]<-as.character(seq(from=interval/2,to=2000,by=interval)[k])
  colnames(AVG_CellTC)[k+1]<-as.character(seq(from=interval/2,to=2000,by=interval)[k])
  
  colnames(AVG_Cell1D)[k+1]<-as.character(seq(from=interval/2,to=800,by=interval)[k])
  colnames(AVG_Cell2D)[k+1]<-as.character(seq(from=interval/2,to=2000,by=interval)[k])
  colnames(AVG_CellTD)[k+1]<-as.character(seq(from=interval/2,to=2000,by=interval)[k])
}

write.table(AVG_CellT, file="Comparison_MAP.txt",sep="\t",row.names = FALSE, quote=FALSE)
write.table(AVG_Cell1D, file="Strain1_MAP.txt",sep="\t",row.names = FALSE, quote=FALSE)
write.table(AVG_Cell2D, file="Strain2_MAP.txt",sep="\t",row.names = FALSE, quote=FALSE)

############################################################################################################################################################################
#Plot differential density maps
############################################################################################################################################################################
AVGT<-melt(AVG_CellT)
head(AVGT)
str(AVGT)
AVGT$variable<-as.numeric(AVGT$variable)*interval
AVGT$Length<-as.numeric(AVGT$Length)

pw1<-ggplot(data=AVGT, aes(variable,Length, fill=value))+
  geom_tile()+
  scale_fill_gradient2(low="blue",mid="white",high="red", midpoint=0)+
  coord_fixed()+
  xlab("Total")+
  ylab("FtsK Enrichment differential")+
  theme_bw()+
  theme(axis.text = element_blank(), legend.position = "none")

AVGTA<-melt(AVG_CellTA)
head(AVGTA)
str(AVGTA)
AVGTA$variable<-as.numeric(AVGTA$variable)*interval
AVGTA$Length<-as.numeric(AVGTA$Length)

pw2<-ggplot(data=AVGTA, aes(variable,Length, fill=value))+
  geom_tile()+
  scale_fill_gradient2(low="blue",mid="white",high="red", midpoint=0)+
  coord_fixed()+
  xlab("L < 2.0 [µm]")+
  theme_bw()+
  theme(axis.text = element_blank(),axis.title.y = element_blank(), legend.position = "none")

AVGTB<-melt(AVG_CellTB)
head(AVGTB)
str(AVGTB)
AVGTB$variable<-as.numeric(AVGTB$variable)*interval
AVGTB$Length<-as.numeric(AVGTB$Length)

pw3<-ggplot(data=AVGTB, aes(variable,Length, fill=value))+
  geom_tile()+
  scale_fill_gradient2(low="blue",mid="white",high="red", midpoint=0)+
  coord_fixed()+
  xlab("2.0 <= L < 2.5 [µm]")+
  theme_bw()+
  theme(axis.text = element_blank(),axis.title.y = element_blank(), legend.position = "none")

AVGTC<-melt(AVG_CellTC)
head(AVGTC)
str(AVGTC)
AVGTC$variable<-as.numeric(AVGTC$variable)*interval
AVGTC$Length<-as.numeric(AVGTC$Length)

pw4<-ggplot(data=AVGTC, aes(variable,Length, fill=value))+
  geom_tile()+
  scale_fill_gradient2(low="blue",mid="white",high="red", midpoint=0)+
  coord_fixed()+
  xlab("2.5 <= L < 3.0 [µm]")+
  theme_bw()+
  theme(axis.text = element_blank(),axis.title.y = element_blank(), legend.position = "none")

AVGTD<-melt(AVG_CellTD)
head(AVGTD)
str(AVGTD)
AVGTD$variable<-as.numeric(AVGTD$variable)*interval
AVGTD$Length<-as.numeric(AVGTD$Length)

pw5<-ggplot(data=AVGTD, aes(variable,Length, fill=value))+
  geom_tile()+
  scale_fill_gradient2(low="blue",mid="white",high="red", midpoint=0)+
  coord_fixed()+
  xlab("3.0 <= L [µm]")+
  theme_bw()+
  theme(axis.text = element_blank(),axis.title.y = element_blank(), legend.position = "none")

pdf(file="Density_Map_Average_PointBased_At_Different_Lengths_Comparison.pdf",width=16, height=4)
(pw1|pw2|pw3|pw4|pw5)
dev.off()

