
#loading the dataset
setwd('C:/Users/pocha/Documents/sunderland/shiny/sensor-heroku')
df_first <- read.table("datatest.txt", header=TRUE, sep = ',')
df_second <- read.table("datatest2.txt", header=TRUE, sep = ',')
df_third <- read.table("datatraining.txt", header=TRUE, sep = ',')

#combining all the dataset
set.seed(03)
df_combined <- rbind(df_first, df_second, df_third)

head(df_combined)


library(lubridate)
dates <- as.POSIXlt(df_combined$date)
date.hour <- hour(dates)
#obtaining a time Period from the date
Period <- vector()
for(i in 1:nrow(data.frame(date.hour))){
  if(date.hour[i] >= 3 && date.hour[i] < 9){
    Period[i] = "earlydaytime"
  } else if(date.hour[i] >= 9 && date.hour[i] < 15){
    Period[i] = "daytime"
  } else if(date.hour[i] >= 15 && date.hour[i] < 21){
    Period[i] = "eveningtime"
  } else {
    Period[i] = "lateevening"
  }
}
#removing the date and adding a time Period gotten from the date
df_combined$date <- NULL
set.seed(009)
df_combined$Period <- Period
occupancy <- df_combined$Occupancy 
df_combined$Occupancy  <- NULL
df_combined$Occupancy <- occupancy
library(caret)



library(caret)
set.seed(99)
preProcValuesN <- preProcess(df, method = c("range"))
df <- predict(preProcValuesN, df)


#changing to factors
df_combined$Occupancy <- as.factor(df_combined$Occupancy)
set.seed(42)

index <- createDataPartition(df_combined$Occupancy, p = 0.7, list=FALSE)


train_set <- df_combined[index,] # train set created
test_set <- df_combined[-index,] # test set creates
set.seed(43)

#setting seed for reproducibility
write.table(train_set,"./train_set.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = TRUE)


set.seed(44)
ctrl <- trainControl(method="repeatedcv",repeats = 5, number = 10) #setting parameters
set.seed(45)
knnModel <- train(
  Occupancy  ~ .,
  method = "knn",
  data = train_set,
  tuneGrid = expand.grid(k = 1:10),
  trControl = ctrl,
  metric = "Accuracy"
)
print(knnModel)

df <- data.frame(
  Name = c("Temperature",
           "Humidity",
           "Light",
           "CO2",
           "HumidityRatio",
           "Period"),
  Value = as.character(c(21.10000, 23.50000, 0.000, 545.2500, 0.003631695, 'eveningtime')),
  stringsAsFactors = FALSE)

Occupancy  <- 1
df <- rbind(df, Species)
input <- transpose(df)
write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)

test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
test$Period <- factor(test$Period, levels = c("earlydaytime", "daytime", "eveningtime", "lateevening"))

Output <- data.frame(Prediction=predict(knnModel,test), round(predict(knnModel,test,type="prob"), 3))
print(Output)


saveRDS(knnModel, "knnmodel.rds")



library(stringr)
library(dplyr)

df_combined %>%
  filter(str_detect(Occupancy, "0"))
