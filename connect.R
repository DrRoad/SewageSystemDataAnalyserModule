library(RMySQL)
drv = dbDriver("MySQL")

con <- dbConnect(drv, user = 'naveen', password = 'magicalmessi', host = 'smartsewagedb.c5ac9golfql6.us-west-2.rds.amazonaws.com',port =3306, dbname = 'smartsewage')

dbListTables(con)
print("Enters")

command_log <- dbReadTable(con, "command_log", row.names = "seqnum")

print(command_log)

sensor_log <- dbReadTable(con, "sensor_log", row.names = "seqnum")
print(sensor_log)
