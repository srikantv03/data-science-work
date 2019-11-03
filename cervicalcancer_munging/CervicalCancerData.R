#Srikant Vasudevan
#September 27th
#CervicalCancerData.R
#This script will clean up the cervical cancer data

#Basic setup
setwd("C:/Users/Srikant/Desktop/Data Science/Week 5/Case Study 1")
library(tidyverse)
library(stringr)
source("./myfunctionsaug.R")
cervical <- read.csv("./cervicalCA.csv", na.strings=c("?"))

#Basic descriptive statistics
summary(cervical)
dim(cervical)
str(cervical)
glimpse(cervical)
names(cervical)
head(cervical)

#All the variable names are standard, but we will take all the periods out and change them for underscores

names(cervical) <- str_replace_all(names(cervical), "\\.+", "_")
#Check if it worked
names(cervical)
#Change all the name strings to lower case
names(cervical) <- str_to_lower(names(cervical))
#Check if it worked
names(cervical)

#See which values are boolean, real and int (or look at case study)
summary(cervical)

#Let's sort all the boolean, real and int values out

booleans <- cervical[, c(5, 8, 10, 12, 14:25, 29:36)]

reals <- cervical[, c(6, 7)]

ints <- cervical[, c(1:4, 9, 11, 13, 26:28)]

#make sure we have covered all 36 columns
dim(booleans)
dim(reals)
dim(ints)

#Replacing the boolean values with either 0 or 1 

booleans[is.na(booleans)] <- sample(0:1, 1, replace=TRUE)
#Check if it worked
summary(booleans)
#Change the boolean to logical
booleans <- lapply(booleans, as.logical)
#Display results
summary(booleans)

#Now we look at the int and real values 
summary(ints)
summary(reals)
#Both of these datasets contain columns with missing values, so we will replace those values with the mean
for(i in 1:ncol(ints)){
  ints[is.na(ints[,i]), i] <- mean(ints[,i], na.rm = TRUE)
}
summary(ints)

for(i in 1:ncol(reals)){
  reals[is.na(reals[,i]), i] <- mean(reals[,i], na.rm = TRUE)
}
summary(reals)
#We have replaced all missing data in all of our data classes, time to merge all the data to create one dataset
cervicalNEW <- cbind(reals, ints, booleans)
summary(cervicalNEW)

#The final manipulation we have to perform before writing to a new csv file is to normalize the numerical data
names(cervicalNEW)
#The first 12 columns are numerical data, so we will be *approximately* normalizing those data
#First we need to see which data need normalization=
for(i in 1:12){
  hist(cervicalNEW[, i], main = i)
}
#I am only looking for severly skewed data, approximately normal and approximately skewed data will not be transformed
#Columns needing to be transformed: 1, 2, 4, 6, 7, 8, 9, 10
rz.transform(cervicalNEW[, 1])
rz.transform(cervicalNEW[, 2])
rz.transform(cervicalNEW[, 4])
rz.transform(cervicalNEW[, 6])
rz.transform(cervicalNEW[, 7])
rz.transform(cervicalNEW[, 8])
rz.transform(cervicalNEW[, 9])
rz.transform(cervicalNEW[, 10])

#Now that we have changed the names, replaced missing data with corresponding data and transformed data to make it approximately normal, it is time to write to a new csv file

write.csv(cervicalNEW, file = "ccdataMod.csv")

