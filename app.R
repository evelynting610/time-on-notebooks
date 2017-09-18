#
# This is a Shiny web app that displays the time on notebooks, by company.
#

library(shiny)
library(ggplot2)
library(civis)


df <- read_civis("civis_platform.notebook_time_org", database = "redshift-general")

# pulls list of all users to select from in dropdown menu
choices = unique(df[[1]])

ui <- fluidPage(
  
  titlePanel("Minutes Spent in Notebooks, by company"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("company", "Select a company", choices)
    ),
    mainPanel(
      plotOutput("plot"),
      textOutput("test")
    )
  )
)

server <- function(input, output) {
  
  output$test <- renderText({
    paste("Shiny app loaded and works!")
  })
  
  output$plot <- renderPlot({
    company_info <- subset(df, organization == input$company, select = c(week_end, mins_spent))
    ggplot(company_info, aes(week_end, mins_spent)) + geom_line()
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
