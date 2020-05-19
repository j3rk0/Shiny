library(ggplot2)
library(shinybusy)

server <- function(input, output, session) {
    
    matrix <- NULL
    
    output$loaded<-renderText("matrix not loaded")
    
    #directory selection:
    observeEvent(ignoreNULL = TRUE, eventExpr = {
            input$directory
        }, handlerExpr = {
            if (input$directory > 0) {
                # condition prevents handler execution on initial app launch
                
                # launch the directory selection dialog with initial path read from the widget
                path <- choose.dir(default = readDirectoryInput(session, 'directory'))
                
                # update the widget value
                updateDirectoryInput(session, 'directory', value = path)
            }
        })
    
    #reactive calculate the gene expression
    res<-reactive({
         if(!is.null(matrix)){
            getGenePositions(logMatrix(matrix),input$gene)
        }    
    })

    #reactive calculate the dimension of the dots
    dim<-reactive({(session$clientData[["output_inten_width"]])/150 })


    #LOAD THE MATRIX
    observeEvent(input$load,{
        
        if(input$directory>0 ){

            #get the files directory
            directory<-readDirectoryInput(session,'directory')
            
            matrixFile<-paste(directory,"matrix.mtx",sep="/")
            rowFile  <- paste(directory,"features.tsv",sep = "/")
            colsFile <- paste(directory,"barcodes.tsv",sep = "/")
            
            #check if files exists
            
            if(file.exists(matrixFile)&&file.exists(rowFile)&&file.exists(colsFile))
            {
            
                #function to load matrix and gene positions dataframe

                matrix <<- removeUnexpressed(loadMatrix(directory),1)


                #update gene selection input
                updateSelectizeInput(session,'gene',choices = rownames(matrix),server = TRUE)
            
                #Start to Plot

                output$expr <- renderPlot({
                    if(input$gene!=""){
                        ggplot(res(),aes(x=x,y=y,colour=val)) + geom_point(size=dim()) + scale_colour_gradient(low = "steelblue",high = "navyblue") + labs(colour = "expression")
                    }
                    
                })
            
                output$inten <- renderPlot({
                    if(input$gene != ""){
                        ggplot(res(),aes(x=x,y=y)) + geom_hex() + scale_fill_gradient(low = "steelblue",high = "navyblue") + labs(fill = "intensity")
                    }
                })
            
                output$hist <- renderPlot({
                    if(input$gene != ""){
                        ggplot(res(),aes(x=val)) + geom_histogram(color="navyblue",fill="steelblue")
                    }
                })

                #update UI
                output$loaded<-renderText("matrix loaded")

            }else{ output$loaded <- renderText("some file doesn't exixts")} 
        }
    })


    #run clustering
    observeEvent(input$run_clust,{
        if(!is.null(matrix)){

            clust <- NULL
            fs <- input$feat_sel
            dr <- input$dim_red

            mtx <- gficfNormalize(matrix)
            if(fs=="PCA") {
               if(dr=="t-SNE"){
                   clust <- cluster_pca_tsne(mtx)
               }else{ #UMAP
                   clust <- cluster_pca_umap(mtx)
               }
            }else{ #LSA
               if(dr=="t-SNE"){
                   clust <- cluster_lsa_tsne(mtx)
               }else{ #UMAP
                   clust <- cluster_lsa_umap(mtx)
               }
            }
            output$clust <- renderPlot({plot_cell_cluster(clust)})
        }
    })
}