# Exit from exponential Covid-19

This project aimes to make a visualization of the distance to the dangerous exponential growth of confirmed covid-19 cases possible. In this analysis only the key-countries 
	
- China
- United States
- United Kingdom
- Italy
- France
- Germany
- Spain
- Iran

were taken into consideration to give a clear overview without to many different colors and graphs. As well as focus to and ask the question if the political actions like loosening in restirctions in the last weeks had an impact on the exponential growth in the United States and Germany.

The changes in covid-19 are so quickly and diffcult to grasp that it is difficult to say are we in a phase of exponential growth or not yet/not anymore. Besides that there is not much reporting available that deal with the question when this exponential growth starts/ends.

By changing the normal analysation with confirmed cases on the y-axis and the time on the x-axis to a trajectory on which all the countries travel as long as they have exponential growth, makes it obvious when they drop out of it. This is done by changing the x-axis to all confirmed cases on a logarithmic scale and the y-axis to the new confirmed cases e.g. in one week on a logarithmic scale to.

The main idea behind this approach originated from [Aatish Bhatia](https://aatishb.com/) ([covidtrends](https://github.com/aatishb/covidtrends)and [Henry Reich](https://www.youtube.com/user/minutephysics) and this repository aims to recreate there approach to make the resulting data and the approach itself available in R for further projects and analysis to come.

## Data Collection

The data for this study more specifically the table [countries-aggregated.csv](https://github.com/datasets/covid-19/blob/master/data/countries-aggregated.csv) containing the date, country and confirmed cases are taken from [covid-19](https://github.com/datasets/covid-19).

The repository [covid-19](https://github.com/datasets/covid-19) manage the daily aggregation of worldwide covid-19 data sourced from the repository [CSSEGISandData](https://github.com/CSSEGISandData/COVID-19), which is maintained by the Johns Hopkins University Center for Systems Science and Engineering (CSSE).

## Preparations

1. git clone https://github.com/ahenoch/covid-exit.git
2. cd covid-exit/scripts
3. Rscript covid-exit.R

If you want to use the script with the daily covid-19 data you need to clone the repository [covid-19](https://github.com/datasets/covid-19) to. 

1. git clone https://github.com/datasets/covid-19.git
2. git clone https://github.com/ahenoch/covid-exit.git
3. cd covid-exit/scripts
4. change 'total <- read.csv("../data/countries-aggregated.csv", header = T, sep = ",")' to the path of [covid-19](https://github.com/datasets/covid-19)
5. Rscript covid-exit.R

The csv tables are to be fount in the data folder and the plots in the plots folder.

## License

[covid-19](https://github.com/datasets/covid-19) published their datasets under the [Public Domain and Dedication [License](https://opendatacommons.org/licenses/pddl/1-0/).

The originating data from the Johns Hopkins University [CSSEGISandData](https://github.com/CSSEGISandData/COVID-19) are licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0).

And finally the files and datasets in the repository are licensed under the [GNU General Public License](https://github.com/ahenoch/covid-exit/blob/master/LICENSE)
