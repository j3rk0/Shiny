#github library: https://github.com/wleepang/shiny-directory-input
library(shinyDirectoryInput)
library(shinydashboard)

#sidebar definition
sidebar <- dashboardSidebar(
  sidebarMenu(
    #coloured status message
    fluidRow(align= "center",htmlOutput("loaded")),
    #tabs
    menuItem("Load Data",icon = icon("file"),tabName = "load_tab"),
    menuItem("Clustering", icon= icon("project-diagram"),tabName = "clust_tab"),
    menuItem("Charts", icon = icon("bar-chart-o"), startExpanded = TRUE,
   menuSubItem("Expression","expr_tab"),
      menuSubItem("Density","dens_tab"),
      menuSubItem("Histogram","histo_tab"))),
  #gene selection
  selectizeInput("gene","Gene to map:",c(Choose='',NULL))
)

#tab to load data
LoadDataTab <- tabItem(tabName = "load_tab",box( status = "warning",solidHeader = TRUE,title = "Input Matrix",
            h2("Select sample's file directory"),
            h4("directory must contain: matrix.mtx, features.tsv and barcodes.tsv"),
            directoryInput('directory',label = "Files directory:"),
            actionButton("load","load",style="margin-bottom:30px")
     ))

#clustering tab
ClusteringTab <- tabItem(tabName = "clust_tab",
                         #column layout
                         fluidRow(
                            column(6,
                                   box( title = "clustering params", width = NULL, status = "warning",solidHeader = TRUE,
                                        selectInput(inputId = "feat_sel", label = "feature selection:",choices = c("PCA","LSA")),
                                        selectInput(inputId = "dim_red", label = "dimensionality reduction:", choices = c("t-SNE","UMAP")),
                                        actionButton("run_clust","run clustering")
                                   ),
                                   box(title = "dim-reduction chart", width = NULL, status = "primary",solidHeader = TRUE,
                                       column(12,align="center", plotOutput("clust", width = "24vw", height = "24vw")))
                            ),
                            column(6,
                                   box(title = "popolations", width = NULL, status = "primary",solidHeader = TRUE,
                                       column(12,align="center",plotOutput("map",width = "37vw",height = "37vw")))
                            )
                         )
)

#chart tabs
ExpressionTab <- tabItem(tabName = "expr_tab",box(status = "primary",title = "Selected Gene Expression Chart",
  column(12,align="center",plotOutput("expr", width = "40vw", height = "40vw"))
))
densityTab <- tabItem(tabName = "dens_tab",box(status = "primary", title = "Selected Gene Density Chart",
  column(12,align="center",plotOutput("inten", width = "40vw", height = "40vw"))
))
HistoTab <- tabItem(tabName = "histo_tab",box(status = "primary", title = "Selected Gene Expression Histogram",
  column(12,align="center",plotOutput("hist", width = "40vw", height = "40vw"))
))

#body definition
body <- dashboardBody(
  tabItems(LoadDataTab,ClusteringTab,densityTab,HistoTab,ExpressionTab)
)

#ui definition
ui <- dashboardPage(
  dashboardHeader(title = "Single Cell RNA-Seq"),
  sidebar,
  body
)
