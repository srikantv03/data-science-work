rm(list = ls())
options(warn=-1)
library(class)
library(ggvis)
library(gmodels)
library(tidyverse)
library(caret)
library(GGally)
library(gridExtra)

setwd("C:/Users/Srikant/Desktop/Data Science/Week 10")
dataset <- read.csv("./ecoli.csv")
#Names (in header of csv) were taken from the documentation of the dataset and manually entered into the .csv file
summary(dataset)
#There is no missing data within the dataset
head(dataset)
glimpse(dataset)
tail(dataset)

#scatterplots
dataset %>% ggvis(~mcg, ~gvh, fill = ~pls) %>% layer_points()

dataset %>% ggvis(~alm1, ~alm2, fill= ~pls) %>% layer_points()

short <- dataset[, c(2:3, 9)]
short1 <- dataset[, c(6:8, 9)]
ggpairs(short, aes(color=(pls)))
ggpairs(short1, aes(color=(pls)))

#set seed for randomization
set.seed(12345)
#Create new column with values 1-8 which will allow us to numerically identify the values in the "pls" column
dataset <- mutate(dataset, variable_class = as.numeric(dataset$pls))

summary(dataset)

#Split the dataset into 1s and 2s (indexing)
ind <- sample(2, nrow(dataset), replace=TRUE, prob=c(.65, .35))
ind

#We are omitting the intrinsically binary values as well as the factor values (euclidean distance cannot be calculated with such values in place)
dataset.training <- dataset[ind==1, c(2:3, 6:8, 10)]
dataset.test <- dataset[ind==2, c(2:3, 6:8, 10)]

summary(dataset.test)
summary(dataset.training)

dataset.trainLabels <- na.omit(dataset[ind==1, 10])
dataset.testLabels <- na.omit(dataset[ind==2, 10])
#building the model
data_pred <- knn(train = dataset.training, test = dataset.test, cl = dataset.trainLabels, k=1)
data_pred

merge <- data.frame(dataset.testLabels, data_pred)
dim(merge)
names <- colnames(dataset.test)
names
final_data <- cbind(dataset.test, merge)
names(final_data) <- c(names, "Observed Class", "Predicted Class")
head(final_data)
view(final_data)

CrossTable(x = dataset.testLabels, y = data_pred, prop.chisq=FALSE)

