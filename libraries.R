pkgs <- c("ggplot2", "sqldf", "stringr", "tidyr", "httr", "forecast",
          "RSelenium", "XML", "rvest")
loaded <- lapply(pkgs, require, character.only = TRUE)