ui <- fluidPage(
    
    # Application title
    titlePanel("Single Cell Plots"),
    
    sidebarLayout(
        sidebarPanel(
            h3( textOutput("loaded") ),
            p("the directory must contain: matrix.mtx, barcode.tsv and features.tsv",style="margin-bottom:30px"),
            directoryInput('directory',label = "Files directory:"),
            actionButton("load","load",style="margin-bottom:30px"),
            selectizeInput("gene","Gene to map:",c(Choose='',NULL))
        ),
        mainPanel(
            fluidRow(align="center",
                     div(
                         h3("Expression"),
                         plotOutput("conc",width = "40vw",height = "40vw"),
                         
                     ),
                     div(
                         h3("Intensity"),
                         plotOutput("dens",width = "40vw",height = "40vw")
                     )
            )
        )
    )
)