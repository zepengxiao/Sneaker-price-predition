library(RSelenium); library(XML); library(rvest)
library(stringr); library(ggplot2)
library(tidyr)

rD = rsDriver()
remDr = rD$client
remDr$navigate("https://stockx.com/air-jordan-1-retro-high-alternate-black-royal")

button = remDr$findElement(using = "xpath", "//button[contains(text(),'Load More')]")

replicate(100, {
  button$clickElement()
  Sys.sleep(3)
})

get_table = function(remDr) {
  table = remDr$findElement(using = "class", "latest-sales-container")
  doc = htmlParse(table$getPageSource()[[1]])
  readHTMLTable(doc)
}

table_blackroyal<-get_table(remDr)

rD$server$stop()

table_blackroyal_after<-handle_table(table$`latest-sales-table`)

nrow(table)
