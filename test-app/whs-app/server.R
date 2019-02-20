#
# This is the server logic of the GPW13 dashboard app 
#

library(shiny)
library(shinydashboard)

whs <- read.csv("data/whs_iso.csv", header = TRUE)
whs$year <- as.factor(whs$year)

# Message dataframe
messageData <- data.frame("from" = c("WHO",
                                     "Admin"),
                          "message" = c("Welcome to the GPW13 dashboard",
                                        "Please send feedback to admin@who.org")
                          )

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  output$countryName <- renderText({
    input$country
  })
  
  country_pop <- reactive({
   round(whs$pop[whs$country == input$country & whs$year == input$year] / 1000, 1)
  })
  
  output$population <- renderInfoBox({
    infoBox(
      tags$p("Population", style = "font-size: 150%; padding-left: 10px;"), 
      tags$p(country_pop(), ifelse(is.na(country_pop()), "\n", " million\n"),
             style = "font-size: 200%; padding-left: 5px;"), icon = icon("users"),
      color = "aqua"
    )
  })
  
  country_hale <- reactive({
    whs$hale[whs$country == input$country & whs$year == input$year]
  })
  
  output$hale <- renderInfoBox({
    infoBox(
      tags$p("Healthy life expectancy", style = "font-size: 150%; padding-left: 10px;"), 
      tags$p(country_hale(), ifelse(is.na(country_hale()), "", " years"),
             style = "font-size: 200%; padding-left: 7px;"), icon = icon("heartbeat"),
      color = "aqua"
    )  
  })
  
  output$data_avail <- renderInfoBox({
    infoBox(
      tags$p("Year of data", style = "font-size: 150%; padding-left: 10px;"), 
      tags$p(input$year, style = "font-size: 200%; padding-left: 7px;"), icon = icon("calendar"),
      color = "aqua"
    )
  })
  
  output$who_region <- renderInfoBox({
    infoBox(
      tags$p("WHO Region", style = "font-size: 150%; padding-left: 10px;"), 
      tags$p(whs$Region[whs$country == input$country & whs$year == input$year], 
             style = "font-size: 200%; padding-left: 7px;"), icon = icon("globe"),
      color = "blue"
    )
  })
  
  output$indicator1 <- renderValueBox({
    valueBox(
      tags$p("63", style = "font-size: 150%;"), "Maternal mortality ratio per 100 000 live births", icon = icon("briefcase-medical"),
      color = "orange"
    )  
  })
  
  output$indicator2 <- renderInfoBox({
    valueBox(
     tags$p("42", style = "font-size: 150%;"), "Under-5 mortality rate per 1 000 live births", icon = icon("briefcase-medical"),
      color = "blue"
    )
  })
  
  output$indicator3 <- renderValueBox({
    valueBox(
      tags$p("25%", style = "font-size: 150%;"), "Childhood stunting under five years of age", icon = icon("briefcase-medical"),
      color = "orange"
    )  
  })
  
  output$indicator4 <- renderInfoBox({
    valueBox(
      tags$p("8%", style = "font-size: 150%;"), "Childhood obesity for 5-19 year olds", icon = icon("briefcase-medical"),
      color = "green"
    )
  })
  
  output$indicator5 <- renderValueBox({
    valueBox(
      tags$p("63", style = "font-size: 150%;"), "Maternal mortality ratio per 100 000 live births", icon = icon("briefcase-medical"),
      color = "orange"
    )  
  })
  
  output$indicator6 <- renderInfoBox({
    valueBox(
      tags$p("42", style = "font-size: 150%;"), "Under-5 mortality rate per 1 000 live births", icon = icon("briefcase-medical"),
      color = "blue"
    )
  })
  
  output$indicator7 <- renderValueBox({
    valueBox(
      tags$p("25%", style = "font-size: 150%;"), "Childhood stunting under five years of age", icon = icon("briefcase-medical"),
      color = "orange"
    )  
  })
  
  output$indicator8 <- renderInfoBox({
    valueBox(
      tags$p("8%", style = "font-size: 150%;"), "Childhood obesity for 5-19 year olds", icon = icon("briefcase-medical"),
      color = "green"
    )
  })
  
  output$indicator9 <- renderValueBox({
    valueBox(
      tags$p("63", style = "font-size: 150%;"), "Maternal mortality ratio per 100 000 live births", icon = icon("briefcase-medical"),
      color = "orange"
    )  
  })
  
  output$indicator10 <- renderInfoBox({
    valueBox(
      tags$p("42", style = "font-size: 150%;"), "Under-5 mortality rate per 1 000 live births", icon = icon("briefcase-medical"),
      color = "blue"
    )
  })
  
  output$indicator11 <- renderValueBox({
    valueBox(
      tags$p("25%", style = "font-size: 150%;"), "Childhood stunting under five years of age", icon = icon("briefcase-medical"),
      color = "orange"
    )  
  })
  
  output$indicator12 <- renderInfoBox({
    valueBox(
      tags$p("8%", style = "font-size: 150%;"), "Childhood obesity for 5-19 year olds", icon = icon("briefcase-medical"),
      color = "green"
    )
  })
  
  output$uhc_plot <- renderPlot({
    set.seed(531)
    a <- rnorm(500)
    hist(a)
  })
  
  output$messageMenu <- renderMenu({
    msgs <- apply(messageData, 1, function(row) {
      messageItem(from = row[["from"]], message = row[["message"]])
    })
    dropdownMenu(type = "messages", .list = msgs)
  })
  
})
