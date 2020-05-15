
# colonne: barcode 33 mila matrix[,x]
# righe: geni 3 mila matrix[x,]
cells_indexes <- read.csv("library/cells_indexes.csv")


getColnames <- function(path)
{
  #get filename
  colsFile <- paste(path,"barcodes.tsv",sep = "/")
  #read file
  cols<-read.csv(colsFile,header = FALSE)
  #select column
  cols<-c(cols$V1)
  #return
  cols
}

getRowNames <- function(path)
{
  #get filename
  rowFile  <- paste(path,"features.tsv",sep = "/")
  #read file
  rows <- read.csv(rowFile,sep = "\t",header = FALSE)
  #select column
  rows<-c(rows$V2)
  #return
  rows
}

loadMatrix <- function(path)
{
  rows <- getRowNames(path)
  cols <- getColnames(path)
  
  library(Matrix)
  
  matrixFile<-paste(path,"matrix.mtx",sep="/")
  
  #read matrix file
  matrix <- readMM(matrixFile)
  
  #set rows and cols names
  rownames(matrix)<-rows
  colnames(matrix)<-cols
  
  #return
  matrix
}




getGenePositions <- function(matrix,gene)
{
  #order and sort positions
  cols <- colnames(matrix)

  positions <- cells_indexes
  positions<-subset(positions,barcode %in% cols)
  positions<- positions[match(cols,positions$barcode),]
  
  #initialize variables
  x<-c(NULL)
  y<-c(NULL)
  val<-c(NULL)
  #extract gene expression vector
  gene_expr<-matrix[gene,]
  
  #for each row take gene expression
  for (i in 1:length(gene_expr)) {
    if(gene_expr[i] > 0)
    {
      val<-append(val,gene_expr[i])
      x<-append(x,positions$array_col[i])
      y<-append(y,positions$array_row[i])
    }
  }
  
  as.data.frame(cbind(x,y,val))
}

