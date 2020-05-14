source("SaveAndLoadMatrix.R")

#carica matrice
#cell <- loadMatrix("~/dataset")

#matrix==0 return a matrix of boolean 
removeUnexpressed <- function(matrix,percentage){
  
  percentage <- (ncol(matrix)/100)*(100-percentage)
  matrix[rowSums(matrix==0)<=percentage,]  
}

#apply log10 to matrix
logMatrix <- function(matrix){
  log10(matrix+1.0)
}

 #resut <- logMatrix( removeUnexpressed(cell,1) )



