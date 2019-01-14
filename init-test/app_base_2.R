
setwd("C:/Users/dyou/Desktop/document/R_shiny") 

library(shiny)
library(ggplot2)  # for the diamonds dataset
library(DT)
#install.packages("readxl")
library("readxl")
#install.packages("tidyverse")
library(tidyverse) 
#install.packages("dplyr")
library(dplyr)

mydataset <- read_excel("whs2018_AnnexB.xls", sheet = "Annex B-3",  skip = 1)
mydataset <- mydataset[-c(1,2), ]  # delete row showing 'data type'
mydataset <- mydataset %>% select(-contains("X__"))
mydataset <- dplyr::select(mydataset, -c('Member State__1'))


ui <- fluidPage(
  title = "Examples of DataTables",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "mydataset"',
        checkboxGroupInput("show_vars", "Columns in data to show:",
                           names(mydataset), selected = names(mydataset))
                      )
                ),

    
        mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("Annex B-3", DT::dataTableOutput("mytable2"))
      )
    )
  )
)

server <- function(input, output) {
  mydataset2 = mydataset
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(mydataset2[, input$show_vars, drop = FALSE], options = list(orderClasses = TRUE,lengthMenu = c(10, 30, 50, 100,200), pageLength = 10))
  })
  
 
  
}

shinyApp(ui, server)
