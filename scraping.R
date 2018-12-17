search = function(web, shoe, remDr) {
  remDr$navigate(web)
  wenElem = remDr$findElement(using = "id", "home-search")
  wenElem$sendKeysToElement(list(shoe))
  Sys.sleep(3)
}

direct = function(remDr) {
  target = remDr$findElement(using = "class", "list-item-content")
  target$clickElement() 
  Sys.sleep(3)
}

get_table = function(remDr) {
  table = remDr$findElement(using = "class", "latest-sales-container")
  doc = htmlParse(table$getPageSource()[[1]])
  data.frame(readHTMLTable(doc))
}

get_picture = function(remDr) {
  pic = remDr$findElement(using = "class", "product-media")
  html = pic$getPageSource()[[1]]
  container = read_html(html)
  selector = "div:nth-child(1) > img"
  img_url = container %>%
    html_node(selector) %>%
    html_attr("src")
  download.file(img_url, "shoe.png", mode = "wb")
  return("shoe.png")
}

get_info = function(remDr) {
  table = get_table(remDr)
  image = get_picture(remDr)
  return(list(table = table, 
              image = image))
}