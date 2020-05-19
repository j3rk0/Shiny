#github library: https://github.com/wleepang/shiny-directory-input
library(shinyDirectoryInput)
library(shinydashboard)

#sidebar definition
sidebar <- dashboardSidebar(
  sidebarMenu(
    fluidRow(align= "center",htmlOutput("loaded")),
    menuItem("Load Data",icon = icon("file"),tabName = "load_tab"),
    menuItem("Clustering", icon= icon("project-diagram"),tabName = "clust_tab"),
    menuItem("Charts", icon = icon("bar-chart-o"), startExpanded = TRUE,
   menuSubItem("Expression","expr_tab"),
      menuSubItem("Density","dens_tab"),
      menuSubItem("Histogram","histo_tab"))),
  selectizeInput("gene","Gene to map:",c(Choose='',NULL))
)

#tab body definition
LoadDataTab <- tabItem(tabName = "load_tab",box(
            h2("Select sample's file directory"),
            h4("directory must contain: matrix.mtx, features.tsv and barcodes.tsv"),
            directoryInput('directory',label = "Files directory:"),
            actionButton("load","load",style="margin-bottom:30px")
     ))

ClusteringTab <- tabItem(tabName = "clust_tab",
        box( title = "clustering params",
             selectInput(inputId = "feat_sel", label = "feature selection:",choices = c("PCA","LSA")),
             selectInput(inputId = "dim_red", label = "dimensionality reduction:", choices = c("t-SNE","UMAP")),
             actionButton("run_clust","run clustering")
        ),box(title = "Chart",plotOutput("clust", width = "35vw", height = "35vw"))
      )

ExpressionTab <- tabItem(tabName = "expr_tab",box(
  plotOutput("expr", width = "40vw", height = "40vw")
))
densityTab <- tabItem(tabName = "dens_tab",box(
  plotOutput("inten", width = "40vw", height = "40vw")
))
HistoTab <- tabItem(tabName = "histo_tab",box(
  plotOutput("hist", width = "40vw", height = "40vw")
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
