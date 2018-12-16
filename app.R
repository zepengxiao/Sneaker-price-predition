#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

packages <- c("shiny", "RSelenium", "XML", "rvest", "stringr", "tidyr", "ggplot2")
loaded <- lapply(packages, require, character.only = TRUE)

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
                #change names later
                tabPanel("Image", imageOutput("image")),
                tabPanel("Table", tableOutput("table")),
                tabPanel("plot1", plotOutput("plot1"))
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
          #return(list)
          list2 = handle_table(list$table)
          result = list(table = list2$table, image = list$image, graph1 = list2$graph1)
          return(result)
        })

    output$table <- renderTable({
      active_dataset()$table
    })
    
    output$image <- renderImage({
      list(src = active_dataset()$image)
    }, deleteFile = TRUE)
    
    output$plot1 <- renderPlot({
      active_dataset()$graph1
    })
    
}

# Run the application
shinyApp(ui = ui, server = server)
