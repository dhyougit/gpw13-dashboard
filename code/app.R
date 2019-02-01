# load the required packages
library(shiny)
require(shinydashboard)
library(ggplot2)
library(dplyr)

#install.packages("shinydashboard")

#install.packages("tidyverse")
#install.packages("dplyr")

setwd("C:/Users/dyou/OneDrive - World Health Organization/0_OneDrive_Main/5_OneDrive_R_shiny/git_repo/test-app/data")

recommendation <- read.csv('whs.csv',stringsAsFactors = F,header=T)

#head(recommendation)


#Dashboard header carrying the title of the dashboard
header <- dashboardHeader(title = "WHS Dashboard")  

#Sidebar content of the dashboard
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("WHS Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Visit-us", icon = icon("send",lib='glyphicon'), 
             href = "https://www.who.int")
  )
)


frow1 <- fluidRow(
  valueBoxOutput("value1")
  ,valueBoxOutput("value2")

)

frow2 <- fluidRow(
  
box(
    title = "Population per year"
    ,status = "primary"
    ,solidHeader = TRUE 
    ,collapsible = TRUE 
    ,plotOutput("popbyyear", height = "500px")
  ) 
  
)



# combine the two fluid rows to make the body
body <- dashboardBody(frow1, frow2)

#completing the ui part with dashboardPage
ui <- dashboardPage(title = 'This is my Page title', header, sidebar, body, skin='red')

# create the server functions for the dashboard  
server <- function(input, output) { 
  
  #some data manipulation to derive the values of KPI boxes
  totalpop <- sum(recommendation$pop, na.rm=T)
  maxyear <- max(recommendation$year, na.rm=T)
  
  #creating the valueBoxOutput content
  output$value1 <- renderValueBox({
    valueBox(
      formatC(maxyear,  big.mark='')
      ,'Max year:'
      ,icon = icon("stats",lib='glyphicon')
      ,color = "purple")
  })
  
  output$value2 <- renderValueBox({
    
    valueBox(
      formatC(totalpop, , format="d", big.mark=',')
      ,'Total population'
      ,icon = icon("stats",lib='glyphicon')
      ,color = "green")
  })
  
 

  
  #creating the plotOutput content
  

  
  
  output$popbyyear <- renderPlot({
    ggplot(data = recommendation, 
           aes(x=country, y=pop, fill=factor(year))) + 
      geom_bar(position = "dodge", stat = "identity") + ylab("population") + 
      xlab("country") + theme(legend.position="bottom" 
                              ,axis.text.x = element_text(angle = 90, hjust = 1)
                              ,plot.title = element_text(size=15, face="bold")) + 
      ggtitle("population by year") + labs(fill = ".")
  })
  
  
  
}


shinyApp(ui, server)