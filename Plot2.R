## -----------------------
## Author: Marin Grgurev
## Date: August 10, 2014
## -----------------------
## Reconstructing Plot 2 as a requirement for the Course Project 1 from the Coursera 
## course "Exploratory data analysis"
## More details on: https://github.com/MarinGrgurev/ExData_Plotting1

## Note: This code assume that the input file "household_power_consumption.txt" is 
## located in working dir. If not, file can be downloaded from  UC Irvine Machine Learning
## Repository in the "Electric power consumption" dataset which can be downloaded from:
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## The code for downloading the dataset is shown below but is commented.

## Downloading and unzipping file
# URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# download.file(URL, destfile = "exdata_data_household_power_consumption.zip")
# unzip("exdata_data_household_power_consumption.zip")

## Loading required library
library(data.table)

## First I'm loading the whole dataset as fread() loads it in under 3 seconds
suppressWarnings(data <- fread("household_power_consumption.txt", na.strings = "?"))

## Changing the Date column to Date class to easily subset for required dates
data[,Date:=as.Date(data[,Date], "%d/%m/%Y")]
data <- subset(data, Date=="2007-02-01" | Date=="2007-02-02")

## Adjusting other column classes as fread() change it all to character
data[,(colnames(data)[-c(1:2,7:9)]):=lapply(.SD, as.numeric),.SDcols=colnames(data)[-c(1:2,7:9)]]
data[,(colnames(data)[-c(1:6)]):=lapply(.SD, as.integer),.SDcols=colnames(data)[-c(1:6)]]

## Changing and renaming the Time column to be of POSIXct class and removing unused
## Date column 
data[,Time:=as.POSIXct(strptime(paste(data[,Date], data[,Time]), "%Y-%m-%d %H:%M:%S"))]
setnames(data,"Time","DateTime")
data[,Date:=NULL]

## Preparing plot 2
## To be consistent with the plots that we need to reproduce I changed LANGUAGE setting
## to c with command:
Sys.setlocale("LC_TIME", "C")

## Preparing graphic device and dimensions of plot
png("plot2.png",width = 480, height = 480)

## Plotting required plot to graphic device
plot(data$DateTime, data$Global_active_power,
     type="l",
     xlab="",
     ylab="Global Active Power (kilowatts)")

## Shutting down graphic device
dev.off()