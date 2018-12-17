library(sqldf);library(ggplot2);library(forecast)

#This is the visualization of the original data
data_for_visualization = function(table) {
  g1 = ggplot(table) + aes(x = Date, y = Price) + facet_wrap(~Size) + geom_line() + theme(panel.grid =element_blank()) + ggtitle("Date versus Price")
  result = list(g1 = g1)
  return (result)
}

#This is the visualization of comparing sales of two kind of shoes
data_for_visualization2 = function(name1, name2) {
  table1 = read.csv(paste0(name1, "_after.csv"))
  table2 = read.csv(paste0(name2, "_after.csv"))
  table_all = rbind(table1, table2)
  g1 = ggplot(table_all) + geom_bar() + aes(x = Month, fill = Name) + facet_wrap(~Size) + theme(panel.grid =element_blank())
  result = list(g1 = g1)
  return (result)
}

#This function is for making predictions and plotting the predictions 
#given by the table after calculating mean value of shoes in the same day and same size.
#Result will consists of three parts, first one is plot
#second and third one are strings indicating the result of maximum value and minimum value separately
data_for_prediction = function(table1, size) {
  if (!size %in% table1$Size) {
    stop("This size is not available in this sneaker!")
  }
 
  table = table1[table1$Size == size,]
  amount = nrow(table)
  table$Size <- as.factor(table$Size)
  table$Date <- as.Date(table$Date)
  interval = as.numeric(table$Date[nrow(table)] - table$Date[1]) / (nrow(table) - 1)
  fit1 <- auto.arima(ts(data = table$Price, frequency = 24))
  predict1 <- forecast(fit1)$fitted
  len = length(predict1)
  table_predict = data.frame(Date = table$Date[len] + (1:len)*interval,
                             Size = rep(table$Size[1], len), Price = predict1, condition = "Predict Price")
  table$condition = rep("Real Data", amount)
  table_combined = rbind(table, table_predict)
  max = max(table_predict$Price)
  min = min(table_predict$Price)
  maxDate = table_predict$Date[table_predict$Price == max]
  maxDate = maxDate[1]
  minDate = table_predict$Date[table_predict$Price == min]
  minDate = minDate[length(minDate)]
  if (min == max) {
    minMessage = "There is no maximum price and minimum price in our prediction since sources prices are too few to make the prediction."
    g1 = ggplot(table_combined) + geom_line(aes(x = Date, y = Price)) + geom_line(aes(x = Date, y = Price, color = condition)) + theme(panel.grid =element_blank()) + ggtitle("Predicted Result") 
    maxMessage = "There is no maximum price and minimum price in our prediction since sources prices are too few to make the prediction."
  } else {
    minMessage = paste0("The minimum price of our prediction is ", round(min,2), ", which will be in ", minDate, ".")
    maxMessage = paste0("The maximum price of our prediction is ", round(max,2), ", which will be in ", maxDate, ".")
    g1 = ggplot(table_combined) + geom_line(aes(x = Date, y = Price)) + geom_line(aes(x = Date, y = Price, color = condition)) + theme(panel.grid =element_blank()) + ggtitle("Predicted Result") + annotate("text", x = maxDate, y = max, label = "Max Price") + annotate("text", x = minDate, y = min, label = "Min Price")
  }
  result = list(g1 = g1, minMessage = minMessage, maxMessage = maxMessage)
  return (result)
}