library(sqldf);library(ggplot2);library(forecast)
blackroyal_data <- table_blackroyal_after$table

sqry <- "
SELECT Date, Size, AVG(Number_Price) as AVG_Price
FROM blackroyal_data
GROUP BY Date, Size;"
blackroyal_data<-sqldf::sqldf(sqry)

data_for_visualization = function(table){
  sqry <- "
  SELECT Date, Size, AVG(Number_Price) as AVG_Price
  FROM table
  GROUP BY Date, Size;"
  result<-sqldf::sqldf(sqry)
  return (result)
}



AirPresto = AirPresto[,-1]
AirPresto$Date = str_extract(AirPresto$Date, "[0-9]{4}-[0-9]{2}-[0-9]{2}")

sqry <- "
SELECT Date, Size, AVG(Price)
FROM AirPresto
GROUP BY Date, Size;"
AirPresto = sqldf::sqldf(sqry)
write.csv(AirPresto, "AirPresto.csv")

write.csv(AirPresto, "AirPresto.csv")
AirPresto <- read.csv("AirPresto.csv")
