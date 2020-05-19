#github library: https://github.com/wleepang/shiny-directory-input
library(shinyDirectoryInput)

ui <- fluidPage(
    add_busy_bar(color = "#FF0000"),
    # Application title
    titlePanel("Single Cell RNA-Seq Plots"),

    #main layout
    sidebarLayout(
        sidebarPanel(

            #status message
            h3( textOutput("loaded") ),
            p("the directory must contain: matrix.mtx, barcode.tsv and features.tsv",style="margin-bottom:30px"),

            #inputs
            directoryInput('directory',label = "Files directory:"),
            actionButton("load","load",style="margin-bottom:30px"),
            selectizeInput("gene","Gene to map:",c(Choose='',NULL))
        ),
        mainPanel(
            #align everytingh to center
            fluidRow(align="center",
                     tabsetPanel(
                         #plot tabs
                         tabPanel("Intensity", plotOutput("inten", width = "40vw", height = "40vw")),
                         tabPanel("Expression", plotOutput("expr", width = "40vw", height = "40vw")),
                         tabPanel("Histogram", plotOutput("hist", width = "40vw", height = "40vw")),

                         #cluster tab
                         tabPanel("Cluster", fluidRow(
                              #params
                              column(3, selectInput(inputId = "feat_sel", label = "feature selection:",choices = c("PCA","LSA"))),
                              column(3, selectInput(inputId = "dim_red", label = "dimensionality reduction:", choices = c("t-SNE","UMAP")))
                            ),fluidRow( align = "left",
                              column(3, actionButton("run_clust","run clustering"))
                            ),fluidRow( align= "center",
                              #plot
                              column(12, plotOutput("clust", width = "35vw", height = "35vw")))
                         )
                     )
                )
            )
        )
    )
