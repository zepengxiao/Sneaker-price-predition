library(RSelenium); library(XML); library(rvest)
library(stringr); library(ggplot2)
library(tidyr)

rD = rsDriver()
remDr = rD$client
remDr$navigate("https://stockx.com/nike-court-flare-aj1-serena-williams-hyper-pink-w")

button = remDr$findElement(using = "xpath", "//button[contains(text(),'Load More')]")

replicate(500, {
  button$clickElement()
  Sys.sleep(3)
})

get_table = function(remDr) {
  table = remDr$findElement(using = "class", "latest-sales-container")
  doc = htmlParse(table$getPageSource()[[1]])
  readHTMLTable(doc)
}

table_Serena<-get_table(remDr)

rD$server$stop()

table_Serena_after<-handle_table(table$`latest-sales-table`)

nrow(table)
