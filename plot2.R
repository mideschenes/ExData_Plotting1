###############################################################################
## This script first load data from the UC Irvine Machine Learning           ##
## Repository and use the Individual household electric power consumption    ##
## Data Set. We only keep the data from 2-day period in February, 2007, to   ##
## make a plot of Global Active Power. The plot is save into a PNG file with ##
## a width of 480 pixels and a height of 480 pixels.                         ##
###############################################################################

###############################################################################
##  Loading data (download, unzip, load, clean, subset)                      ##
###############################################################################

## load library
library(data.table)

## download data
download.file(
  "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
  "household_power_consumption.zip", 
  method = "curl")
unzip("household_power_consumption.zip")

## load data
alldata <- read.table(
  "household_power_consumption.txt",
   header = TRUE, 
   sep = ";", 
   colClasses = "character")

## clean data (suppressWarnings to remove the warning about NA values)
alldata$Date <- as.Date(alldata$Date, format="%d/%m/%Y")
alldata$Global_active_power <- suppressWarnings(
  as.numeric(as.character(alldata$Global_active_power)))

## subset data to keep only data from 2-day period in February, 2007
data <- subset(alldata, Date >= "2007-02-01" & Date <= "2007-02-02")

## create a new column DateTime
data$DateTime <- paste(data$Date, data$Time)
data$DateTime <- strptime(data$DateTime, format="%Y-%m-%d %H:%M:%S")

###############################################################################
##  Making plot (save in plot2.png - 480 X 480 pixel)                        ##
###############################################################################

## to translate the value of X axis in english
Sys.setlocale("LC_TIME", "en_US.UTF-8") 

## create plot2.png
png(
  filename = "figure/plot2.png", 
  width = 480, 
  height = 480, 
  units = "px", 
  bg = "white")

## create the plot
plot(
  data$DateTime, 
  data$Global_active_power, 
  xaxt=NULL, 
  xlab = "", 
  ylab = "Global Active Power (kilowatts)", 
  type="n")

## add the line
lines(
  data$DateTime, 
  data$Global_active_power, 
  type="S")

## explicitly close graphics device
dev.off()
