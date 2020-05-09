#github library: https://github.com/wleepang/shiny-directory-input
library(shinyDirectoryInput)
library(shinybusy)
library(shiny)
library(ggplot2)
source("SaveAndLoadMatrix.R")

ui <- fluidPage(
    
    # Application title
    titlePanel("Plot breast cancer gene"),
    
    sidebarLayout(
        sidebarPanel(
            h3( textOutput("loaded") ),
            p("the directory must contain: matrix.mtx, barcode.tsv, features.tsv and tissue_positions_list.csv ",style="margin-bottom:30px"),
            directoryInput('directory',label = "Files directory:"),
            actionButton("load","load",style="margin-bottom:30px"),
            selectInput("gene","Gene to map:",c("PGR","ERBB2","MKI67","ESR1")),
            actionButton("plot","plot")
            
        ),
        mainPanel(
            fluidRow(align="center",
                     div(
                         h3("Concentrazione"),
                         plotOutput("conc",width = "40vw",height = "40vw"),
                         
                     ),
                     div(
                         h3("Densità"),
                         plotOutput("dens",width = "40vw",height = "40vw")
                     )
            )
        )
    )
)


server <- function(input, output, session) {
    
    matrix <- NULL
    positions<- NULL
    
    output$loaded<-renderText("matrix not loaded")
    
    #directory selection:
    observeEvent(
        ignoreNULL = TRUE,
        eventExpr = {
            input$directory
        },
        handlerExpr = {
            if (input$directory > 0) {
                # condition prevents handler execution on initial app launch
                
                # launch the directory selection dialog with initial path read from the widget
                path = choose.dir(default = readDirectoryInput(session, 'directory'))
                
                # update the widget value
                updateDirectoryInput(session, 'directory', value = path)
            }
        }
    )
    
    #LOAD THE MATRIX
    observeEvent(input$load,{
        if(input$directory>0)
        {
            #get the files directory
            directory<-readDirectoryInput(session,'directory')
            
            show_modal_spinner()
            
            #function to load matrix and gene positions dataframe
            matrix<<-loadMatrix(directory)
            positions<<-loadPositions(directory)
            
            remove_modal_spinner()
            
            #update UI
            output$loaded<-renderText("matrix loaded")
            
        }
    })
    
    #PLOT THE GRAPHICS
    observeEvent(input$plot,{
        #matrix is loaded
        if(!is.null(matrix))
        {
            #function to get gene positions
            res<-getGenePosition(matrix,positions,input$gene)
            
            #calculate the dimension of point based on graphs actual dimension
            dim<-(session$clientData[["output_dens_width"]])/150
            #plot the graphics
            output$conc <- renderPlot(ggplot(res,aes(x,y)) + geom_point(aes(col=val),size=dim))
            output$dens <- renderPlot(ggplot(res,aes(x,y)) + geom_hex())
            
        }else{
            #no matrix is loaded
            output$loaded<-renderText("need to load a matrix to plot")
        }
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
