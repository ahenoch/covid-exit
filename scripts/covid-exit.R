#Alexander Henoch
#20-08-04

#install.packages("plyr")
#install.packages("tidyverse")
require(ggplot2, quietly=TRUE) #Package for visualization and plotting of results
require(plyr)
require(dplyr, quietly=TRUE, warn.conflicts = FALSE) #Package needed for mutate the date column

total <- read.csv("../data/countries-aggregated.csv", header = T, sep = ",") 

key <- subset(total, Country %in% c("China", "US", "United Kingdom", "Italy", "France", "Germany", "Spain", "Iran"), select = c(Date, Country, Confirmed))
key <- mutate(key, Date = as.Date(Date))

first <- key[1,1]
last <- key[nrow(key),1]

range<-seq(first+7, last, 1)

key1 <- key[key$Date >= first & key$Date <= last-7,]
key2 <- key[key$Date >= first+7 & key$Date <= last,]

from <- key1[,1]
to <- key2[,1]
country <- key1[,2]
entire <- key2[,3]
new <- key2[,3] - key1[,3]

exit1 <- data.frame(from, to, country, new, entire)

write.csv(exit1, file="../data/key_countries_aggregated_new_total.csv", row.names=FALSE)

traj_list <- list()
cont_us_list <- list()
cont_de_list <- list()

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
 
  cont_us <- ggplot(subset(exit2,country %in% c("US")), aes(x=entire, y=new)) +
    geom_line(aes(colour = factor(country)), size = 0.5) +
    geom_point(data=subset(exit3,country %in% c("US")), aes(x=entire, y=new, colour = factor(country)), size = 2) +
    scale_x_continuous(limits = c(0,5e6), 
                  #breaks = scales::trans_breaks("log10", function(x) 10^x),
                  labels = scales::comma) +
    scale_y_continuous(limits = c(0,5e5),
                  #breaks = scales::trans_breaks("log10", function(x) 10^x),
                  labels = scales::comma) +
    labs(colour = "Country") + 
    ylab("New Confirmed Cases (Last Week)") + 
    xlab("Total Confirmed Cases") +
    ggtitle(paste("Confirmed Cases of United States (", day ,")")) +
    theme(plot.title = element_text(hjust=0.5)) +
    scale_color_manual(breaks = c("US"),
                       values=c("#00BFC4"))

  cont_de <- ggplot(subset(exit2,country %in% c("Germany")), aes(x=entire, y=new)) +
    geom_line(aes(colour = factor(country)), size = 0.5) +
    geom_point(data=subset(exit3,country %in% c("Germany")), aes(x=entire, y=new, colour = factor(country)), size = 2) +
    scale_x_continuous(limits = c(0,2.5e5), 
                       #breaks = scales::trans_breaks("log10", function(x) 10^x),
                       labels = scales::comma) +
    scale_y_continuous(limits = c(0,5e4),
                       #breaks = scales::trans_breaks("log10", function(x) 10^x),
                       labels = scales::comma) +
    labs(colour = "Country") + 
    ylab("New Confirmed Cases (Last Week)") + 
    xlab("Total Confirmed Cases") +
    ggtitle(paste("Confirmed Cases of Germany (", day ,")")) +
    theme(plot.title = element_text(hjust=0.5))
  
  traj_list[[day]] <- traj
  cont_us_list[[day]] <- cont_us
  cont_de_list[[day]] <- cont_de
  
}

traj_pdf = structure(traj_list, class = c("gglist", "ggplot"))
cont_us_pdf = structure(cont_us_list, class = c("gglist", "ggplot"))
cont_de_pdf = structure(cont_de_list, class = c("gglist", "ggplot"))

print.gglist = function(x, ...) l_ply(x, print, ...)

ggsave(traj_pdf, file = "../plots/trajectory_of_confirmed_cases_.pdf", height = 7, width = 12)
ggsave(cont_us_pdf, file = "../plots/confirmed_cases_of_united_states.pdf", height = 7, width = 12)
ggsave(cont_de_pdf, file = "../plots/confirmed_cases_of_germany.pdf", height = 7, width = 12)
