#
# This is the user interface for the GPW13 dashboard app
#

library(shiny)
library(shinydashboard)

# Load dataset
setwd("/Users/amitprasad/gpw13-dashboard/test-app/") 
whs <- read.csv("data/whs_iso.csv", header = TRUE)
whs$year <- as.factor(whs$year)

# Header, sidebar and body components
header <- dashboardHeader(title = "GPW13 Dashboard",
                          titleWidth = 250,
                          dropdownMenuOutput("messageMenu"))

sidebar <- dashboardSidebar(sidebarMenu(
                              sidebarSearchForm(textId = "searchText", buttonId = "searchButton", label = "Search..."),
                              id = "tabs",
                              menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"), selected = TRUE),
                              menuItem("Analytics", tabName = "analytics", icon = icon("chart-area")),
                              menuItem("UHC", tabName = "uhc", icon = icon("medkit"), badgeLabel = "new", badgeColor = "green"),
                              menuItem("Data", tabName = "data", icon = icon("database"))
                            ),
                            br(), br(),
                            conditionalPanel(
                              condition = "input.tabs == 'dashboard'",
                              selectInput("country", "Select Country or Region",
                                          choices = levels(whs$country),
                                          selected = "Global",
                                          selectize = TRUE),
                              selectInput("year", "Select Year",
                                          choices = c("Latest", levels(whs$year)),
                                          selected = "2016")
                              ),
                            width = 250
                          )

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  tabItems(
    # First tab content
    tabItem(tabName = "dashboard",
            textOutput("countryName"),
            br(),
            fluidRow(
              infoBoxOutput("population", width = 3),
              infoBoxOutput("hale", width = 3),
              infoBoxOutput("data_avail", width = 3),
              infoBoxOutput("who_region", width = 3)
            ),
            br(),
            fluidRow(
              valueBoxOutput("indicator1", width = 3),
              valueBoxOutput("indicator2", width = 3),
              valueBoxOutput("indicator3", width = 3),
              valueBoxOutput("indicator4", width = 3)
            ),
            fluidRow(
              valueBoxOutput("indicator5", width = 3),
              valueBoxOutput("indicator6", width = 3),
              valueBoxOutput("indicator7", width = 3),
              valueBoxOutput("indicator8", width = 3)
            ),
            fluidRow(
              valueBoxOutput("indicator9", width = 3),
              valueBoxOutput("indicator10", width = 3),
              valueBoxOutput("indicator11", width = 3),
              valueBoxOutput("indicator12", width = 3)
            ),
            br(),
            fluidRow(
              box(title = "Universal Health Coverage", status = "info", solidHeader = TRUE,
                  width = 4, height = "40vh", plotOutput("uhc_plot")),
              box(title = "Health Emergency Preparedness", status = "info", solidHeader = TRUE,
                  width = 4, height = "40vh", plotOutput("hep_plot")),
              box(title = "Healthier Populations", status = "info", solidHeader = TRUE,
                  width = 4, height = "40vh", plotOutput("hp_plot"))
            )
    ),
    tabItem(tabName = "analytics",
            h2("Analytics tab content")),
    tabItem(tabName = "uhc",
            h2("UHC content to go here")),
    tabItem(tabName = "data",
            h2("Data tables to go here"))
  )
)

# Define UI for application that draws a histogram
dashboardPage(skin = "blue",
              header,
              sidebar,
              body
             )
