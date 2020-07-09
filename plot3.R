## Unzip the data
zipfile <- "exdata_data_household_power_consumption.zip"
txtfile <- "household_power_consumption.txt"

if(!file.exists(txtfile)){
    unzip(zipfile)
}

## Read the text file into a data frame
pwr <- read.table(txtfile, sep = ";", header = TRUE)

## Replace "?" with NA in Global_active_power and make it numeric
pwr[pwr == "?"] <- NA
pwr[,-(1:2)] <- apply(pwr[,-(1:2)], MARGIN = 2, 
                      FUN = function(x) as.numeric(as.character(x)))

## Convert the Date variable to a Date class
pwr$Date <- as.Date(pwr$Date, format = "%e/%m/%Y")

## Get the range of indicies that fall in the target date range
idx <- range(which(pwr$Date >= as.Date("2007-02-01") & 
                       pwr$Date <= as.Date("2007-02-02")))

## Index the data frame to the target date range
pwr = pwr[idx[1]:idx[2], ]


## Since this plot is a time-history, convert Date and Time to a datetime
DT <- as.POSIXlt(paste(pwr$Date, pwr$Time))

## Make Plot 3
png(filename = "plot3.png", width = 480, height = 480, units = "px")
plot(DT, pwr$Sub_metering_1, 
     xlab = "", ylab = "Energy sub metering", 
     type = "l", col = "black")
lines(DT, pwr$Sub_metering_2, col = "red")
lines(DT, pwr$Sub_metering_3, col = "blue")
legend("topright", legend = names(pwr)[7:9], lty = c(1, 1, 1), 
       col = c("black", "red", "blue"))
dev.off()