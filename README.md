Data Analysis of Music Chart History
=============================
STAT 545A - Homework #6 - Final Project  
Christian Okkels  
October 2013


### Summary

We perform a data analysis and visualization of the music chart history. 
The dataset to be investigated comes from the so-called Whitburn Project - a huge undertaking by music enthusiasts to preserve and share high-quality recordings of popular songs since the 1890s. 
The project has spawned a vast spreadsheet with data for almost 40,000 songs (as of 2013) that have been hits on the Billboard Chart since 1890. 
The dataset contains more than a hundred columns of raw data, with everything from track titles, song lengths, artists, songwriters, albums, and labels, to peak positions, number of weeks on the charts, week-by-week chart position, and so much more. 


### Report

A detailed report has been written as part of this project. It describes the dataset more thoroughly, gives a detailed explanation of the main R scripts, shows the results in plots and tables, and analyses and discusses them.
The report is published on RPubs [here](http://rpubs.com/cbokkels/stat545a-2013-hw06_okkels-chr).


### Run analysis

In order to run/replicate the analysis and reproduce the results, follow the instructions below.

* Clone the repository, or
* Download the following files into an empty directory:
  * Input data: [`charts.txt`](https://github.com/cbokkels/stat545a-2013-hw06_okkels-chr/blob/master/charts.txt)
  * Scripts: [`data_cleanPrepare.R`](https://raw.github.com/cbokkels/stat545a-2013-hw06_okkels-chr/master/data_cleanPrepare.R), [`data_aggregatePlot.R`](https://raw.github.com/cbokkels/stat545a-2013-hw06_okkels-chr/master/data_aggregatePlot.R), [`func_htmlPrint.R`](https://raw.github.com/cbokkels/stat545a-2013-hw06_okkels-chr/master/func_htmlPrint.R), and [`func_timeToSec.R`](https://raw.github.com/cbokkels/stat545a-2013-hw06_okkels-chr/master/func_timeToSec.R) 
  * Makefile R script: [`makefile.R`](https://raw.github.com/cbokkels/stat545a-2013-hw06_okkels-chr/master/makefile.R)
* Start an RStudio session and make the above directory the working directory. 
* Source/run the Makefile R script `makefile.R`.
* The `data_*.R` scripts can also be run individually and interactively. Just make sure that the cleaned data file `charts_clean.tsv` is in the working directory before running `data_aggregatePlot.R`.


### Description of files

* `charts.xls`: raw data as Excel spreadsheet.
* `charts.txt`: raw data converted to .txt file with tab separated values.
* `charts_clean.tsv`: clean data with tab separated values.
* `data_cleanPrepare.R`: R script that cleans and prepares raw data, creates `charts_clean.tsv`.
* `data_aggregatePlot.R`: R script that performs data aggregation, plotting, and writing of results to file.
* `func_htmlPrint.R`: R script containing a function to print HTML tables.
* `func_timeToSec.R`: R script containing a function to convert the time format "hh:mm:ss" into seconds.
* `makefile.R`: makefile-like R script that cleans up previously saved results and sources the two main `data_*.R` scripts.
* `report.Rmd`, `report.html`: R Markdown and HTML documents containing the report for this project.
* `plot_*.pdf`, `plot_*.png`: plots saved to file in `data_aggregatePlot.R` and `report.Rmd`.
* `table_*.txt`: data.frames saved to file as tables in `data_aggregatePlot.R`.



