#Alexander Henoch
#20-08-09
#https://github.com/ahenoch/covid-exit

#install.packages("plyr")
#install.packages("tidyverse")
require(ggplot2, quietly=TRUE) #Package for visualization and plotting of results
require(plyr) #Package required for saving multiple Plots in one PDF
require(dplyr, quietly=TRUE, warn.conflicts = FALSE) #Package needed for mutate the date column

total <- read.csv("../data/countries-aggregated.csv", header = T, sep = ",") #read in the covid 19 data table

key <- subset(total, Country %in% c("China", "US", "United Kingdom", "Italy", "France", "Germany", "Spain", "Iran"), select = c(Date, Country, Confirmed)) #select only the desired countrys
key <- mutate(key, Date = as.Date(Date)) #transform Date column to dates in R

first <- key[1,1] #find the first date in the table (sorted so first date is first row)
last <- key[nrow(key),1] #find the last date in the table (sorted so last date is last row)

range<-seq(first+7, last, 1) #save the sequence from the 7th day to the last day in table (new infektions per week so 7th day is first day with data point)

key1 <- key[key$Date >= first & key$Date <= last-7,] #new table with all dates from first to the last minus 7 days
key2 <- key[key$Date >= first+7 & key$Date <= last,] #new table with all dates from the 7th to the last

from <- key1[,1] #save column with dates from key1 table in vector "from"
to <- key2[,1] #save column with dates from key2 table in vector "to" 
country <- key1[,2] #save column with the countrys in vector "country"
entire <- key2[,3] #save column with confirmed cases in vector "entire"
new <- key2[,3] - key1[,3] #substract column with confirmed cases of the day with column of confirmed cases 7 days in the past (table key1 and key2) 

if (all(new >= 0)){print("All values are non-negatives!")} #check if negative values -> errors in the table

exit1 <- data.frame(from, to, country, new, entire) #create new table from the created vectors

write.csv(exit1, file="../data/key_countries_aggregated_timerange.csv", row.names=FALSE) #export this table -> new data to use for science

traj_list <- list() #empty plot list 1
cont_us_list <- list() #empty plot list 2
cont_de_list <- list() #empty plot list 3

for(day in as.list(range)) { #iterate over sequence of dates
  
  exit2 <- exit1[exit1$to <= day,] #subtable with all rows containing dates less equal to iterator
  exit3 <- exit2[exit2$to == day,] #subtable contraining the rows containing the iterator date

  traj <- ggplot(exit2, aes(x=entire, y=new)) + #create ggplot with confirmed cases on x-axis and new cases on y-axis
    geom_abline(slope = 1, intercept = 0, linetype="dashed") + #create reference line for exponential growth
    geom_line(aes(colour = factor(country)), size = 0.5) + #create the graph grouped by country
    geom_point(data=exit3, aes(x=entire, y=new, colour = factor(country)), size = 2) + #create last date in graph with a bigger circle
    scale_x_log10(limits = c(1,1e8), #logarithmic x-axis from 1 to 100000000
                  breaks = scales::trans_breaks("log10", function(x) 10^x), #breaks at power of ten
                  labels = scales::trans_format("log10", scales::math_format(10^.x))) + #how the notation on the x-axis looks like
    scale_y_log10(limits = c(1,1e8), #logarithmic x-axis from 1 to 100000000
                  breaks = scales::trans_breaks("log10", function(x) 10^x), #breaks at power of ten
                  labels = scales::trans_format("log10", scales::math_format(10^.x))) + #how the notation on the x-axis looks like
    labs(colour = "Country") + #name the legend of groups as "Country"
    ylab("New Confirmed Cases (Last Week)") +  #label the y-axis
    xlab("Total Confirmed Cases") + #label the x-axis
    ggtitle(paste("Trajectory of Confirmed Cases (", day ,")")) + #create title for the plot paste helps include variables to text
    theme(plot.title = element_text(hjust=0.5)) #center the title 
 
  cont_us <- ggplot(subset(exit2,country %in% c("US")), aes(x=entire, y=new)) + #create ggplot with confirmed cases in US on x-axis and new cases on y-axis
    geom_line(aes(colour = factor(country)), size = 0.5) + #create the graph grouped by country
    geom_point(data=subset(exit3,country %in% c("US")), aes(x=entire, y=new, colour = factor(country)), size = 2) + #create last date in graph with a bigger circle
    scale_x_continuous(limits = c(0,5e6), #continouous x-axis from 0 to 5000000
                  labels = scales::comma) + #how the notation on the x-axis looks like
    scale_y_continuous(limits = c(0,5e5), #continouous x-axis from 0 to 500000
                  labels = scales::comma) + #how the notation on the y-axis looks like
    labs(colour = "Country") + #name the legend of groups as "Country"
    ylab("New Confirmed Cases (Last Week)") + #label the y-axis
    xlab("Total Confirmed Cases") + #label the x-axis
    ggtitle(paste("Confirmed Cases of United States (", day ,")")) + #create title for the plot paste helps include variables to text
    theme(plot.title = element_text(hjust=0.5)) + #center the title 
    scale_color_manual(breaks = c("US"), #use the same color for us like in the graph before
                       values=c("#00BFC4"))

  cont_de <- ggplot(subset(exit2,country %in% c("Germany")), aes(x=entire, y=new)) + #create ggplot with confirmed cases in Germany on x-axis and new cases on y-axis
    geom_line(aes(colour = factor(country)), size = 0.5) + #create the graph grouped by country
    geom_point(data=subset(exit3,country %in% c("Germany")), aes(x=entire, y=new, colour = factor(country)), size = 2) + #create last date in graph with a bigger circle
    scale_x_continuous(limits = c(0,2.5e5), #continouous x-axis from 0 to 250000
                       labels = scales::comma) + #how the notation on the x-axis looks like
    scale_y_continuous(limits = c(0,5e4), #continouous x-axis from 0 to 50000
                       labels = scales::comma) + #how the notation on the y-axis looks like
    labs(colour = "Country") + #name the legend of groups as "Country"
    ylab("New Confirmed Cases (Last Week)") + #label the y-axis
    xlab("Total Confirmed Cases") + #label the x-axis
    ggtitle(paste("Confirmed Cases of Germany (", day ,")")) + #create title for the plot paste helps include variables to text
    theme(plot.title = element_text(hjust=0.5)) #center the title 
  
  traj_list[[day]] <- traj #save first plot in list 1
  cont_us_list[[day]] <- cont_us #save secound plot in list 2
  cont_de_list[[day]] <- cont_de #save third plot in list 3
  
}

traj_pdf = structure(traj_list, class = c("gglist", "ggplot")) #restructure the first list of the plots as gglists
cont_us_pdf = structure(cont_us_list, class = c("gglist", "ggplot")) #restructure the secound list of the plots as gglist
cont_de_pdf = structure(cont_de_list, class = c("gglist", "ggplot")) #restructure the thirs list of the plots as gglist

print.gglist = function(x, ...) l_ply(x, print, ...) #use the gglist list function

ggsave(traj_pdf, file = "../plots/trajectory_of_confirmed_cases_.pdf", height = 7, width = 12) #export first list of plots as PDF
ggsave(cont_us_pdf, file = "../plots/confirmed_cases_of_united_states.pdf", height = 7, width = 12) #export secound list of plots as PDF
ggsave(cont_de_pdf, file = "../plots/confirmed_cases_of_germany.pdf", height = 7, width = 12) #export third list of plots as PDF
