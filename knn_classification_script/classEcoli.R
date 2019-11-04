rm(list = ls())
options(warn=-1)

#load libraries
library(class)
library(ggvis)
library(gmodels)
library(tidyverse)
library(caret)
library(GGally)
library(gridExtra)

#basic setup
setwd("C:/Users/Srikant/Desktop/Data Science/Week 10")
dataset <- read.csv("./ecoli.csv")

#Names (in header of csv) were taken from the documentation of the dataset and manually entered into the .csv file
summary(dataset)

#There is no missing data within the dataset
head(dataset)
glimpse(dataset)
tail(dataset)

#scatterplots
dataset %>% ggvis(~mcg, ~gvh, fill = ~unknown) %>% layer_points()
dataset %>% ggvis(~alm1, ~alm2, fill= ~unknown) %>% layer_points()

#split the dataset into shorter datasets (easier to visualize)
short <- dataset[, c(2:3, 9)]
short1 <- dataset[, c(6:8, 9)]

#Aesthetic pairwise functions to look at the classes in a visually informative manner
ggpairs(short, aes(color=(unknown)))
ggpairs(short1, aes(color=(unknown)))

#set seed for randomization
set.seed(12345)
#Create new column with values 1-8 which will allow us to numerically identify the values in the "unknown" column
dataset <- mutate(dataset, variable_class = as.numeric(dataset$unknown))

summary(dataset)

#Split the dataset into 1s and 2s (indexing)
ind <- sample(2, nrow(dataset), replace=TRUE, prob=c(.65, .35))
ind

#We are omitting the intrinsically binary values as well as the factor values (euclidean distance cannot be calculated with such values in place)
dataset.training <- dataset[ind==1, c(2:3, 6:8, 10)]
dataset.test <- dataset[ind==2, c(2:3, 6:8, 10)]

#look at the summary for both these datasets
summary(dataset.test)
summary(dataset.training)

dataset.trainLabels <- na.omit(dataset[ind==1, 10])
dataset.testLabels <- na.omit(dataset[ind==2, 10])

#building the model
data_pred <- knn(train = dataset.training, test = dataset.test, cl = dataset.trainLabels, k=1)
data_pred

#merge the test labels and the predictions into one dataset so we can compare these values

merge <- data.frame(dataset.testLabels, data_pred)
dim(merge)

#create the names for the final dataset
names <- colnames(dataset.test)
names

#Create the final dataset that will be used in the cross table and munge it (column names)
final_data <- cbind(dataset.test, merge)
names(final_data) <- c(names, "Observed Class", "Predicted Class")
head(final_data)

#view the data
view(final_data)

#Create a cross table to view and evaluate probabilities
CrossTable(x = dataset.testLabels, y = data_pred, prop.chisq=FALSE)
