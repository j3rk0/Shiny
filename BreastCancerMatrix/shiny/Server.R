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
                path = choose.dir(default = readDirectoryInput(session, 'directory'))
                
                # update the widget value
                updateDirectoryInput(session, 'directory', value = path)
            }
        })
    
    #reactive calculate the gene expression
    res<-reactive({
         if(!is.null(matrix)){
            getGenePositions(matrix,input$gene)
        }    
    })
    
    #reactive calculate the dimension of the dots
    dim<-reactive({(session$clientData[["output_dens_width"]])/150 })
    
    #LOAD THE MATRIX
    observeEvent(input$load,{
        
        if(input$directory>0 )
        {
            #get the files directory
            directory<-readDirectoryInput(session,'directory')
            
            matrixFile<-paste(directory,"matrix.mtx",sep="/")
            rowFile  <- paste(directory,"features.tsv",sep = "/")
            colsFile <- paste(directory,"barcodes.tsv",sep = "/")
            
            #check if files exists
            
            if(file.exists(matrixFile)&&file.exists(rowFile)&&file.exists(colsFile))
            {
                show_modal_spinner()
            
                #function to load matrix and gene positions dataframe
                matrix<<-logMatrix( removeUnexpressed(loadMatrix(directory),1))
                
            
                remove_modal_spinner()
            
                #update gene selection input
                updateSelectizeInput(session,'gene',choices = rownames(matrix),server = TRUE)
            
                #Start to Plot 
                output$conc <- renderPlot({
                    if(input$gene!=""){
                        ggplot(res(),aes(x,y)) + geom_point(aes(col=val),size=dim())
                    }
                    
                })
            
                output$dens <- renderPlot({
                    if(input$gene!=""){
                        ggplot(res(),aes(x,y)) + geom_hex()  
                    }
                })
            
                #update UI
                output$loaded<-renderText("matrix loaded")
            
            }else{ output$loaded <- renderText("some file doesn't exixts")} 
        }
    })
    
}