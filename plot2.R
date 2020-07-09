## Unzip the data
zipfile <- "exdata_data_household_power_consumption.zip"
txtfile <- "household_power_consumption.txt"

if(!file.exists(txtfile)){
    unzip(zipfile)
}

## Read the text file into a data frame
pwr <- read.table(txtfile, sep = ";", header = TRUE)

## Convert the Date variable to a Date class
pwr$Date <- as.Date(pwr$Date, format = "%e/%m/%Y")

## Get the range of indicies that fall in the target date range
idx <- range(which(pwr$Date >= as.Date("2007-02-01") & 
                       pwr$Date <= as.Date("2007-02-02")))

## Index the data frame to the target date range
pwr = pwr[idx[1]:idx[2], ]

## Replace "?" with NA in Global_active_power and make it numeric
QI <- which(pwr$Global_active_power == "?")
pwr$Global_active_power[QI] <- NA
pwr$Global_active_power <- as.numeric(as.character(pwr$Global_active_power))

## Since this plot is a time-history, convert Date and Time to a datetime
DT <- as.POSIXlt(paste(pwr$Date, pwr$Time))

## Make Plot 2
png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(DT, pwr$Global_active_power, 
     xlab = "", ylab = "Global Active Power (kilowatts)", 
     type = "l")
dev.off()