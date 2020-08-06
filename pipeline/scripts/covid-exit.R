#Alexander Henoch
#20-08-04

#install.packages("tidyverse")
require(ggplot2, quietly=TRUE) #Package for visualization and plotting of results
require(dplyr, quietly=TRUE, warn.conflicts = FALSE) #Package needed for mutate the date column

args<-commandArgs(TRUE)

total <- read.csv("../../../covid-19/data/countries-aggregated.csv", header = T, sep = ",") 

key <- subset(total, Country %in% c("China", "US", "United Kingdom", "Italy", "France", "Germany", "Spain", "Iran"), select = c(Date, Country, Confirmed))
key <- mutate(key, Date = as.Date(Date))

first <- key[1,1]
last <- key[nrow(key),1]

date1 <- as.Date(args[1])
if (! ( (date1 >= first+7) & (date1 <= last) ) ) {
  date1 <- first+7
}

if ( is.na(args[2]) ) {
  range<-c(date1)
} else {
  date2 <- as.Date(args[2])
  if (! ( (date2 >= first) & (date2 <= last) ) ) {
    date2 <- last
  }
  
  step <- as.numeric(args[3])
  range<-seq(date1, date2, step) 
  if (max(range) != last) {
    range<-c(range, date2)
  }
}

key1 <- key[key$Date >= first & key$Date <= last-7,]
key2 <- key[key$Date >= first+7 & key$Date <= last,]

from <- key1[,1]
to <- key2[,1]
country <- key1[,2]
entire <- key2[,3]
new <- key2[,3] - key1[,3]

exit1 <- data.frame(from, to, country, new, entire)

write.csv(exit1, file="../data/key_countries_aggregated_new_total.csv", row.names=FALSE)

for(day in as.list(range)) {
  
  exit2 <- exit1[exit1$to <= day,]
  exit3 <- exit2[exit2$to == day,]
  
  traj <- ggplot(exit2, aes(x=entire, y=new)) +
    geom_abline(slope = 1, intercept = 0, linetype="dashed") +
    geom_line(aes(colour = factor(country)), size = 0.5) +
    geom_point(data=exit3, aes(x=entire, y=new, colour = factor(country)), size = 2) +
    scale_x_log10(limits = c(1,1e8), 
                  breaks = scales::trans_breaks("log10", function(x) 10^x),
                  labels = scales::trans_format("log10", scales::math_format(10^.x))) +
    scale_y_log10(limits = c(1,1e8),
                  breaks = scales::trans_breaks("log10", function(x) 10^x),
                  labels = scales::trans_format("log10", scales::math_format(10^.x))) +
    labs(colour = "Country") + 
    ylab("New Confirmed Cases (Last Week)") + 
    xlab("Total Confirmed Cases") +
    ggtitle(paste("Trajectory of Confirmed Cases (", day ,")")) +
    theme(plot.title = element_text(hjust=0.5))
  
  suppressWarnings(ggsave(filename = paste("../plots/trajectory_of_confirmed_cases_", day, ".pdf"),
                          plot = traj,
                          height = 7 , 
                          width = 12))
}