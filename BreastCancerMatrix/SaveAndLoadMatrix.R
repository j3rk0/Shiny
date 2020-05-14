
# colonne: barcode 33 mila matrix[,x]
# righe: geni 3 mila matrix[x,]

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

loadPositions <- function(path)
{
  #filename
  posixFile <- paste(path,"tissue_positions_list.csv",sep = "/")
  
  #read file
  posix <- read.csv(posixFile,header = FALSE)
  
  posix <- posix[1:4]
  posix <- posix[-2]
  colnames(posix)<-c("barcode","array_col","array_row")
  
  #return
  posix
}

getGenePosition <- function(matrix,positions,gene)
{
  #order and sort positions
  cols <- colnames(matrix)

  
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

