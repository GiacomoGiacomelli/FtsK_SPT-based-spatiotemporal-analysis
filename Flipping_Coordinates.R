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

####clockwise check function####
#' @title Check whether points for an owin are clockwise
#' @param x a dataframe with x coordinates in the first column and y coordinates in the second. 
#' @details Similarly to owin, the polygon should not be closed
#' @return A logical telling whether the polygon is arranged clockwise.
#' @author The idea has been scavenged from https://stackoverflow.com/a/1165943/1082004

clockwise <- function(x) {
  x.coords <- c(x[[1]], x[[1]][1])
  y.coords <- c(x[[2]], x[[2]][1])
  double.area <- sum(sapply(2:length(x.coords), function(i) {
    (x.coords[i] - x.coords[i-1])*(y.coords[i] + y.coords[i-1])
  }))
  double.area > 0
} 

############################################################################################################################################################################
#Variables, File Inputs, Filtering
############################################################################################################################################################################
#set inputs and outputs (
##UPDATE EVERY STRAIN
output_tab<-"OUTPUT.txt"
strain<-"STRAIN_NAME"
directory_input<-"C:\\LOCATION\\LOCATION\\LOCATION\\CONDITION\\LOCALIZATION_TABLES_FOLDER"

##UPDATE EVERY FOV
directory_cells<-"C:\\LOCATION\\LOCATION\\LOCATION\\CONDITION\\BINARY_FOLDER\\CELLS_NUMBER"
FOV<-"1"

##DO NOT UPDATE
output_area<-"AREALIST.RData"
output_drift<-"CELLS_DRIFTED_FILTERED.txt"
output_IMG<-"CELLS_DRIFTED_FILTERED_IMG.txt"
output_flip<-paste("OUTPUT_ROTATED",FOV,".txt", sep = "")
output_area_cor<-"AREALIST_cor.RData"
output_area_at0<-"AREALIST_At0.RData"

#READ FILE
directory<-gsub("\\", "/", directory_input, fixed=TRUE)                                                   #working on windows so I have to invert \ to /
setwd(directory)                                                                                          #setting working directory
dir()                                                                                                     #show directory content
file1name<-readline("file1 name:")                                                                        #input the name of the PALM localization table file in the console after running this line
                                                                               
file<-read.delim(file1name, header=T)                                                                     #nrow = embedded null line position is -2
fileR<-file
fileR1<-fileR

############################################################################################################################################################################
#Change folder to where the R.Cell*.txt files are
#Verify correct alignment between events and ROIs
############################################################################################################################################################################
directory<-gsub("\\", "/", directory_cells, fixed=TRUE)                                                   #working on windows so I have to invert \ to /
setwd(directory)                                                                                          #setting working directory
dir()                                                                                                     #show directory content

fileNames <- Sys.glob("Cell*.txt")
LISTofAREAS<-c()
fx[14]<-NA
fx[15]<-NA
fx[16]<-NA
colnames(fx)[14]<-"CellName"
colnames(fx)[15]<-"CellDiameter"
colnames(fx)[16]<-"CellArea"

#The plot(realsA) within the cycle shows the position of the events within the used ROIs, shift them accordingly if necessary
for (i in fileNames) {
  c1<-read.table(i, header=TRUE)
  if (clockwise(data.frame(x=c1$X, y=c1$Y))) {
    poli<-list(list(x=rev(c1$X*1000), y=rev(c1$Y*1000)))
    cm1<-owin(poly=poli)
    pp3<-as.ppp(fx[c(5:6)],cm1)
    realsA<-subset(pp3,cm1)
    plot(realsA)                                  
    if (length(realsA$x)>0){
      realsA_DF<-as.data.frame(realsA)
      #plot(fx[which(paste(fx$Position.X..nm.,fx$Position.Y..nm.) %in% paste(realsA_DF$x,realsA_DF$y)),]$Position.Y..nm. ~fx[which(paste(fx$Position.X..nm.,fx$Position.Y..nm.) %in% paste(realsA_DF$x,realsA_DF$y)),]$Position.X..nm.,asp=1)
      fx[which(paste(fx$Position.X..nm.,fx$Position.Y..nm.) %in% paste(realsA_DF$x,realsA_DF$y)),14]<-paste(i,FOV,sep="")
      fx[fx$Position.X..nm.==realsA[1]$x & fx$Position.Y..nm.==realsA[1]$y,15][1]<-diameter(cm1)
      fx[fx$Position.X..nm.==realsA[1]$x & fx$Position.Y..nm.==realsA[1]$y,16][1]<-area.owin(cm1)
      LISTofAREAS<-c(LISTofAREAS,poli)
    }
    
  }  else {
    poli<-list(list(x=c1$X*1000, y=c1$Y*1000))
    cm1<-owin(poly=data.frame(x=c1$X*1000, y=c1$Y*1000))
    pp3<-as.ppp(fx[c(5:6)],cm1)
    realsA<-subset(pp3,cm1)
    plot(realsA)    
    if (length(realsA$x)>0){
      realsA_DF<-as.data.frame(realsA)
      #plot(fx[which(paste(fx$Position.X..nm.,fx$Position.Y..nm.) %in% paste(realsA_DF$x,realsA_DF$y)),]$Position.Y..nm. ~fx[which(paste(fx$Position.X..nm.,fx$Position.Y..nm.) %in% paste(realsA_DF$x,realsA_DF$y)),]$Position.X..nm.,asp=1)
      fx[which(paste(fx$Position.X..nm.,fx$Position.Y..nm.) %in% paste(realsA_DF$x,realsA_DF$y)),14]<-paste(i,FOV,sep="")
      fx[fx$Position.X..nm.==realsA[1]$x & fx$Position.Y..nm.==realsA[1]$y,15][1]<-diameter(cm1)
      fx[fx$Position.X..nm.==realsA[1]$x & fx$Position.Y..nm.==realsA[1]$y,16][1]<-area.owin(cm1)
      LISTofAREAS<-c(LISTofAREAS,poli)
    }
  }
}

############################################################################################################################################################################
#Exclude events lying outside the ROIs
#Update table accordingly
############################################################################################################################################################################
write.table(fx[!is.na(fx$CellName),], file=output_tab,sep="\t",row.names = FALSE, quote=FALSE)
saveRDS(LISTofAREAS, file=output_area)
file_filtered<-fx[!is.na(fx$CellName),]

############################################################################################################################################################################
#Save filtered table
#Add post table parameters to allow for import within the ZenBlack Software
############################################################################################################################################################################
write.table(file_filtered[1:13], file=output_IMG,sep="\t",row.names = FALSE, quote=FALSE) 
line<-"                                                                                                   

VoxelSizeX : 0.0967821

VoxelSizeY : 0.0967821

ResolutionX : 1.0000000000

ResolutionY : 1.0000000000

SizeX : 640

SizeY : 640


ROI List : "

write(line, file=output_IMG, append=TRUE)
############################################################################################################################################################################

############################################################################################################################################################################
#Rotation of the cells
############################################################################################################################################################################
fileR3<-file_filtered
fileNames<-unique(fileR3$CellName)

fileR3[,17]<-0
fileR3[,18]<-0
colnames(fileR3)[17]<-"Rot_X"
colnames(fileR3)[18]<-"Rot_Y"
fileR3[,19]<-0
fileR3[,20]<-0
colnames(fileR3)[19]<-"At0_X"
colnames(fileR3)[20]<-"At0_Y"
LISTofAREAS_cor<-c()
LISTofAREAS_At0<-c()
fileR3[,21]<-0
colnames(fileR3)[21]<-"CellWidth"
fileR3[,22]<-0
fileR3[,23]<-0
colnames(fileR3)[22]<-"Avg_X"
colnames(fileR3)[23]<-"Avg_Y"
fileR3[,24]<-0
fileR3[,25]<-0
fileR3[,26]<-0
fileR3[,27]<-0
fileR3[,28]<-0
fileR3[,29]<-0
fileR3[,30]<-"no"
colnames(fileR3)[24]<-"Midcell"
colnames(fileR3)[25]<-"Midcell_portion"
colnames(fileR3)[26]<-"Pole1"
colnames(fileR3)[27]<-"Pole2"
colnames(fileR3)[28]<-"Polar_portion"
colnames(fileR3)[29]<-"Poles_ratio"
colnames(fileR3)[30]<-"unique_cell"
fileR3[,31]<-strain
fileR3[,32]<-0
fileR3[,33]<-0
fileR3[,34]<-0
fileR3[,35]<-0
colnames(fileR3)[31]<-"Strain"
colnames(fileR3)[32]<-"Max_position"
colnames(fileR3)[33]<-"Rel_Dist_from_center"
colnames(fileR3)[34]<-"Max_Norm_position"
colnames(fileR3)[35]<-"Rel_Norm_Dist_from_center"


for (i in fileNames) {
  if (length(fileR3[fileR3$CellName==i,]$Index)>1){
  c1<-fileR3[fileR3$CellName==i,][c(5,6)]
  fileR3[fileR3$CellName==i,]$CellName<-paste(i,FOV,sep="")
  plot(c1[,1],c1[,2])
  DM= as.matrix(dist(c1))
  points=which(DM == max(rdist(c1)), arr.ind=T)
  M<-rbind(c1[points[1,1],],c1[points[1,2],])
  #plot data
  plot(M[,1],M[,2])#,xlim=c(0,1200),ylim=c(0,1200))
  #calculate rotation angle
  alpha <- -atan((M[1,2]-tail(M,1)[,2])/(M[1,1]-tail(M,1)[,1]))
  #rotation matrix
  rotm <- matrix(c(cos(alpha),sin(alpha),-sin(alpha),cos(alpha)),ncol=2)
  #shift, rotate, shift back
  M2 <- t(rotm %*% (
    t(c1)-c(M[1,1],M[1,2])
  )+c(M[1,1],M[1,2]))
  #plot
  M3 <- t(rotm %*% (
    t(fileR3[fileR3$CellName==paste(i,FOV,sep=""),][c(5,6)])-c(M[1,1],M[1,2])
  )+c(M[1,1],M[1,2]))
  #plot
  
  if (clockwise(data.frame(x=M2[,1], y=M2[,2]))) {
    poli<-list(list(x=rev(M2[,1]), y=rev(M2[,2])))
    poli0<-list(list(x=rev(M2[,1]-min(M2[,1])), y=rev(M2[,2]-min(M2[,2]))))
  } else {  
  poli<-list(list(x=M2[,1], y=M2[,2]))
  poli0<-list(list(x=M2[,1]-min(M2[,1]), y=M2[,2]-min(M2[,2])))
  }
  
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),17]<-M3[,1]
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),18]<-M3[,2]
  
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),19]<-M3[,1]-min(M2[,1])
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),20]<-M3[,2]-min(M2[,2])
  
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$CellDiameter<-max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X)
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$CellWidth<-max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_Y)
  ##cell area approximated as a rod
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$CellArea<-((max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X)-max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_Y))*max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_Y))+(0.5*(max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_Y))^2)
  ##Avg X
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$Avg_X<-fileR3[fileR3$CellName==paste(i,FOV,sep=""),19]*(2000/fileR3[fileR3$CellName==paste(i,FOV,sep=""),][1,]$CellDiameter)
  ##Avg Y
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$Avg_Y<-fileR3[fileR3$CellName==paste(i,FOV,sep=""),20]*(800/fileR3[fileR3$CellName==paste(i,FOV,sep=""),][1,]$CellWidth)
  ##Midcell
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$Midcell<-length(fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$At0_X>=0.4*max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X) & fileR3$At0_X<=0.6*max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X),]$Index)
  ##Midcell%
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$Midcell_portion<-fileR3[fileR3$CellName==paste(i,FOV,sep=""),24][1]/length(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$Index)
  ##Pole1
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$Pole1<-length(fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$At0_X>=0 & fileR3$At0_X<=0.2*max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X),]$Index)
  ##Pole2
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$Pole2<-length(fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$At0_X>=0.8*max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X) & fileR3$At0_X<=max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X),]$Index)
  ##Polar%
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$Polar_portion<-(fileR3[fileR3$CellName==paste(i,FOV,sep=""),26][1]+fileR3[fileR3$CellName==paste(i,FOV,sep=""),27][1])/length(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$Index)
  fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$unique_cell[1]<-"yes"
  ##Pm/PM
  if (fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Pole1<fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Pole2){
    fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Poles_ratio<-fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Pole1/fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Pole2
  } else {
    fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Poles_ratio<-fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Pole2/fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Pole1
  }
  
  H1 <- hist(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X, plot = FALSE, breaks=seq(0,max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X),l=round((max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X)/25)+1, digits=0)))
  fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Max_position<-H1$breaks[which.max(H1$counts)]
  fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Rel_Dist_from_center<-abs((H1$breaks[which.max(H1$counts)]/max(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$At0_X))-0.5)
  
  H <- hist(fileR3[fileR3$CellName==paste(i,FOV,sep=""),]$Avg_X, plot = FALSE, breaks=seq(0,2000,l=81))
  fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Max_Norm_position<-H$breaks[which.max(H$counts)]
  fileR3[fileR3$CellName==paste(i,FOV,sep="") & fileR3$unique_cell=="yes",]$Rel_Norm_Dist_from_center<-abs((H$breaks[which.max(H$counts)]/2000)-0.5)
  }
}

###############
setwd(directory_cells)
write.table(fileR3, file=output_flip,sep="\t",row.names = FALSE, quote=FALSE)
