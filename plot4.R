library(downloader)
#Initially we check whether the file exists in the working directory.
#If not, then we download it and unzip it for processing and plotting.

if (!file.exists("./data/household_power_consumption.txt")) {
  download("http://j.mp/TbC79E", dest="./data/power_dataset.zip", mode="wb") 
  unzip ("./data/power_dataset.zip", exdir = "./data")
}

#Dataset contains around 2 million records which will consume about 137 MB.
#2M x 9 columns x 8 bytes = 144,000,000 bytes = 140,625 KB = 137.33 MB
#To save some space we'll load the data that will be used for plotting.
#This run in Git Bash as it is unix=based code (it won't run in RStudio).

#copy first row with headers.
###head -1 ./data/household_power_consumption.txt > ./data/plot_data.txt

#extract rows for 1st and 2nd of February 2007.
###cat ./data/household_power_consumption.txt | grep '^0\{0,1\}[12]/0\{0,1\}2/2007' >> ./data/plot_data.txt

#now loading only plot_data.txt into R.
source_data <- read.table("./data/plot_data.txt", 
                          header=TRUE, sep=";", 
                          stringsAsFactors=FALSE, na.strings="?")

#Joining Date and Time columns together.
source_data$DateTime <- paste(source_data$Date, source_data$Time, sep=" ")

source_data$DateTime <- strptime(source_data$DateTime, format="%d/%m/%Y %H:%M:%S")

#Plotting chart 4.
png('plot4.png', width = 480, height = 480)
par(mfrow = c(2, 2))

# plot 1 on the upper left side
plot(source_data$DateTime, source_data$Global_active_power, type = "l", ylab = "Global Active Power", 
     xlab = "")

# plot 2 on the upper right side
plot(source_data$DateTime, source_data$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")

# plot 3 on the lower left side
plot(source_data$DateTime, source_data$Sub_metering_1, type = "l", ylab = "Energy sub metering", 
     xlab = "", col = "black")
points(source_data$DateTime, source_data$Sub_metering_2, type = "l", xlab = "", ylab = "Sub_metering_2", 
       col = "red")
points(source_data$DateTime, source_data$Sub_metering_3, type = "l", xlab = "", ylab = "Sub_metering_3", 
       col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", 
                                                                        "Sub_metering_2", "Sub_metering_3"), bty = "n", )

# plot 4 on the lower right side
plot(source_data$DateTime, source_data$Global_reactive_power, type = "l", xlab = "datetime", 
     ylab = "Global_reactive_power", ylim = c(0, 0.5))

dev.off()