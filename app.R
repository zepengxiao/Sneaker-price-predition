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

shoe.name <- c("Adidas NMD",
               "Adidas Yeezy 700",
               "Adidas Yeezy Wave Runner",
               "Nike Air Force 1",
               "Nike Air Jordan 12 Master",
               "Nike Air Jordan 4 Travis", 
               "Nike Air Jordan 4 Royalty")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Sneakerhead Gear"),
    tabsetPanel(
      tabPanel("Prediction",
               sidebarLayout(
                 sidebarPanel(
                   selectizeInput("shoe",
                     "Please choose your sneakers:",
                     choices = shoe.name,
                     options = list(
                       placeholder = 'Please select an option below',
                       onInitialize = I('function() { this.setValue(""); }')
                     )
                   ),
                   sliderInput("size",
                               "Please specify a size:",
                               value = 9,
                               min = 4, max = 14, step = 0.5),
                   actionButton(inputId = "bt", label = "Apply")
                 ),
                 mainPanel(imageOutput("image"),
                           plotOutput("pred"),
                           verbatimTextOutput("info"))
               )),
      tabPanel("Comparision", 
               sidebarLayout(
                 sidebarPanel(
                   selectizeInput("pair",
                                  "Please select sneakers to compare:",
                                  choices = shoe.name,
                                  multiple = TRUE, options = list(maxItems = 2)
                   ),
                   actionButton(inputId = "bt2", label = "Apply")
                 ),
                 mainPanel(plotOutput("comp"))
               )),
      tabPanel("Search Live", 
               sidebarLayout(
                 sidebarPanel(
                   textInput("name", 
                             label = "Please enter your sneaker"),
                   actionButton(inputId = "bt3", label = "Apply")
                 ),
                 
                 mainPanel(imageOutput("liveimg"),
                           tableOutput("table"))
               ))
    )
)

server <- function(input, output) {

    active_dataset =
        eventReactive(input$bt3, {
          rD = rsDriver()
          remDr = rD$client
          search("https://stockx.com", input$name, remDr)
          direct(remDr)
          list = get_info(remDr)
          rD$server$stop()
          return(list)
        })
    
    active_sneakername = 
      eventReactive(input$bt, {
        input$shoe
      })
    
    active_sneakername2 = 
      eventReactive(input$bt2, {
        input$pair
      })
    
    active_size =  
      eventReactive(input$bt, {
        input$size
      })
    
    output$image <- renderImage({
      list(src = paste0(active_sneakername(), '.png'),
           wisth = 385,
           height = 385)
    }, deleteFile = FALSE)
    
    output$pred <- renderPlot({
      table = handle_rawdata(active_sneakername())
      table = data_for_prediction(table, active_size())
      table$g1
    })
    
    output$info <- renderPrint({
      table = handle_rawdata(active_sneakername())
      table = data_for_prediction(table, active_size())
      list("For buyers" = table$minMessage,
           "For sellers" = table$maxMessage)
    })
    
    output$comp <- renderPlot({
      temp = data_for_visualization2(active_sneakername2()[1],
                                     active_sneakername2()[2])
      temp$g1
    })

    output$table <- renderTable({
      table = active_dataset()$table
      colnames(table) = c("Size", "Price", "Date", "Time")
      table
    })
    
    output$liveimg <- renderImage({
      list(src = active_dataset()$image,
           wisth = 385,
           height = 385)
    }, deleteFile = TRUE)
    
}

# Run the application
shinyApp(ui = ui, server = server)
