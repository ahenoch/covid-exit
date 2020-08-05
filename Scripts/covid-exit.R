#Alexander Henoch
#20-08-04

#install.packages("tidyverse")
require(ggplot2, quietly=TRUE) #Package for visualization and plotting of results
require(dplyr, quietly=TRUE, warn.conflicts = FALSE) #Package needed for mutate the date column

args<-commandArgs(TRUE)

total <- read.csv("../../covid-19/data/countries-aggregated.csv", header = T, sep = ",") 

key <- subset(total, Country %in% c("China", "US", "United Kingdom", "Italy", "France", "Germany", "Spain", "Iran"), select = c(Date, Country, Confirmed))
key <- mutate(key, Date = as.Date(Date))

date1 <- key[1,1]
#date2 <- key[nrow(key),1]
date2 <- as.Date(args[1])

key1 <- key[key$Date >= date1 & key$Date <= date2-7,]
key2 <- key[key$Date >= date1+7 & key$Date <= date2,]

from <- key1[,1]
to <- key2[,1]
country <- key1[,2]
entire <- key2[,3]
new <- key2[,3] - key1[,3]

exit1 <- data.frame(from, to, country, new, entire)
exit2 <- exit1[exit1$to == date2,]

new_entire <- ggplot(exit1, aes(x=entire, y=new)) +
  geom_line(aes(colour = factor(country)), size = 0.5) +
  geom_point(data=exit2, aes(x=entire, y=new, colour = factor(country)), size = 2) +
  #geom_points(aes(colour = factor(country)), size = 0.5) +
  scale_x_log10() +
  scale_y_log10() +
  labs(colour = "Country") + 
  ylab("New Confirmed Cases (Last Week)") + 
  xlab("Total Confirmed Cases") +
  ggtitle(paste("Trajectory of Confirmed Cases (", date2 ,")")) +
  theme(plot.title = element_text(hjust=0.5))

suppressWarnings(ggsave(filename = paste("../Plots/trajectory_of_confirmed_cases_", date2, ".png"),
       plot = new_entire,
       height = 7 , width = 12))

#entire_date <- ggplot(exit1, aes(x=to, y=entire)) +
#  geom_line(aes(colour = factor(country)), size = 0.5) +
#  labs(colour = "Country") + 
#  ylab("Total Confirmed Cases") + 
#  xlab("Days") +
#  ggtitle(paste("Confirmed Cases (", date2 ,")")) +
#  theme(plot.title = element_text(hjust=0.5)) +
#  scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m")

#suppressWarnings(ggsave(filename = paste("../Plots/course_of_confirmed_cases_", date2, ".pdf"),
#       plot = entire_date,
#       height = 7 , width = 12))

#new_date <- ggplot(exit1, aes(x=to, y=new)) +
#  geom_line(aes(colour = factor(country)), size = 0.5) +
#  labs(colour = "Country") + 
#  ylab("New Confirmed Cases (Last Week)") + 
#  xlab("Days") +
#  ggtitle(paste("New Confirmed Cases (", date2 ,")")) +
#  theme(plot.title = element_text(hjust=0.5)) +
#  scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m")

#suppressWarnings(ggsave(filename = paste("../Plots/course_of_new_cases_", date2, ".pdf"),
#       plot = new_date,
#       height = 7 , width = 12))
