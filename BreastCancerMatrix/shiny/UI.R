ui <- fluidPage(
    
    # Application title
    titlePanel("Single Cell RNA-Seq Plots"),
    
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
                     tabsetPanel(
                         tabPanel("Intensity",plotOutput("dens",width = "45vw",height = "45vw")),
                         tabPanel("Expression",plotOutput("conc",width = "45vw",height = "45vw")),
                         tabPanel("Histogram",plotOutput("hist",width = "45vw",height = "45vw"))
                )
            )
        )
    )
)