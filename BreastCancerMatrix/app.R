#github library: https://github.com/wleepang/shiny-directory-input
library(shinyDirectoryInput)
library(shinybusy)
library(shiny)
library(ggplot2)

source("library/SaveAndLoadMatrix.R")
source("library/Normalization.R")
source("shiny/UI.R")
source("shiny/Server.R")


options(browser='false')
shinyApp(ui = ui, server = server)