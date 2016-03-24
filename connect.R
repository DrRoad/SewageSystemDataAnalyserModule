library(RMySQL)
library(ggplot2)

drv = dbDriver("MySQL")
con <- dbConnect(drv, user = 'naveen', password = 'magicalmessi', host = 'smartsewagedb.c5ac9golfql6.us-west-2.rds.amazonaws.com',port =3306, dbname = 'smartsewageprototype')
dbListTables(con)
#print("Enters")
command_log <- dbReadTable(con, "command_log", row.names = "seqnum")
#print(command_log)
sensor_log <- dbReadTable(con, "sensor_log", row.names = "seqnum")

sensor_log_pump1 <- sensor_log[sensor_log$PsID == 1,]
#print(sensor_log_pump1)
sensor_log_pump2 <- sensor_log[sensor_log$PsID == 2,]
#print(sensor_log_pump2)
sensor_log_pump3 <- sensor_log[sensor_log$PsID == 3,]
#print(sensor_log_pump3)
sensor_log_pump4 <- sensor_log[sensor_log$PsID == 4,]
#print(sensor_log_pump4)
sensor_log_pump5 <- sensor_log[sensor_log$PsID == 5,]
#print(sensor_log_pump5)
sensor_log$time <- as.POSIXlt(sensor_log$time)
sensor_log$interval <- cut(sensor_log$time,breaks="hour")

# To identify when more than two PS have level above 3
critical <- sensor_log[sensor_log$level3 == 1,]   #This data frame stores all instances where in the level3 of any PS has been breached
#critical <- critical[critical$Freq>0,]

intervalDF <- table(critical$interval)# This is a data frame which stores all the different intervals available in the database
intervalDF <- data.frame(intervalDF)
intervalDF <-intervalDF[intervalDF$Freq>0,]
copyIntervalCritical <- intervalDF
intervalDF <- intervalDF[[1]]
intervalDF <- data.frame(intervalDF)
intervalDF <- as.POSIXlt(unlist(intervalDF))
intervalDF <- cut(intervalDF,breaks='hour')

#loop
n <- length(intervalDF)
cr_in <- critical[critical$interval == intervalDF[1],]
#cr_in <- data.frame(PsID = numeric(n), level1 = numeric(n), level2= numeric(n), level3 = integer(n), level4 = integer(n),time = character(n), interval = integer(n), stringsAsFactors = FALSE)
for(i in 2:n){
        temp <- critical[critical$interval == intervalDF[i],]
        cr_in <- rbind(cr_in,temp)
        #cr_in will store all rows having same interval as interval[i]
        cr_in_id <- table(cr_in["PsID"])
        if(nrow(cr_in_id)>1){
                print( cr_in_id)
        }
}

pdf('plot1.pdf')
barplot(copyIntervalCritical$Freq,names = copyIntervalCritical$Var1, xlab= "Time intervals", ylab = "Number of ON commands", main ="Crtical Operarional intervals") 
dev.off()


