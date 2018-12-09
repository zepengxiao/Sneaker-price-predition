#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RSelenium); library(XML); library(rvest)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Sneakerhead Gear"),

    sidebarLayout(
        sidebarPanel(
            textInput("name", label = "Please enter your sneaker"),
            actionButton(inputId = "bt", label = "Apply")
        ),

        mainPanel(
            tabsetPanel(
                tabPanel("Image", imageOutput("image")),
                tabPanel("Table", tableOutput("table"))
            )
        )
    )
)

server <- function(input, output) {

    active_dataset =
        eventReactive(input$bt, {
          rD = rsDriver()
          remDr = rD$client
          search("https://stockx.com", input$name, remDr)
          direct(remDr)
          list = get_info(remDr)
          rD$server$stop()
          return(list)
        })

    output$table <- renderTable({
      active_dataset()$table
    })
    
    output$image <- renderImage({
      list(src = active_dataset()$image)
    }, deleteFile = TRUE)
    
}

# Run the application
shinyApp(ui = ui, server = server)
