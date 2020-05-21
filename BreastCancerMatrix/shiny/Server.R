library(ggplot2)
library(shinybusy)

server <- function(input, output, session) {


    matrix <- NULL
    log10mtx <- NULL
    output$loaded<-renderText('<h3 style="color:red;">matrix not loaded</h3>')

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
            getGenePositions(log10mtx,input$gene)
        }
    })

    #reactive calculate the dimension of the dots
    dim<-reactive({(session$clientData[["output_expr_width"]])/150 })


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
                show_modal_spinner(text = "Loading matrix...")

                matrix <<- gficfNormalize(loadMatrix(directory))
                #matrix <<- removeUnexpressed(loadMatrix(directory),1)
                log10mtx <<- logMatrix(matrix$rawCounts)

                #update gene selection input
                updateSelectizeInput(session,'gene',choices = rownames(matrix$rawCounts),server = TRUE)

                remove_modal_spinner()
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
                        ggplot(res(),aes(x=val)) + geom_histogram(color="navyblue",fill="steelblue") + labs(x="expression")
                    }
                })

                #update UI
                output$loaded<-renderText('<h3 style="color:green;">matrix loaded</h3>')

            }else{ output$loaded <- renderText('<h3 style="color:red;">some file do not exist</h3>')}
        }
    })


    #run clustering
    observeEvent(input$run_clust,{
        if(!is.null(matrix)){

            clust <- NULL
            fs <- input$feat_sel
            dr <- input$dim_red
            show_modal_spinner(text = "Clustering...")
            if(fs=="PCA") {
               if(dr=="t-SNE"){
                   clust <- cluster_pca_tsne(matrix)
               }else{ #UMAP
                   clust <- cluster_pca_umap(matrix)
               }
            }else{ #LSA
               if(dr=="t-SNE"){
                   clust <- cluster_lsa_tsne(matrix)
               }else{ #UMAP
                   clust <- cluster_lsa_umap(matrix)
               }
            }
            remove_modal_spinner()
            output$clust <- renderPlot({plot_cell_cluster(clust)})
            clust_mat <- get_clust_matrix(clust)
            output$map <- renderPlot({ggplot(data = clust_mat, aes(x= x, y= y,colour=cluster)) + geom_point(size=2) + labs(x="x",y="y",colour="cluster")})
        }
    })
}