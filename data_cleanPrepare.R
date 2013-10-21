### STAT 545A - Homework 6  ###
### Christian Birch Okkels  ###
###############################

### Description:
#   Data cleaning and preparation script:
#   - read raw data from .txt file and store in data.frame.
#   - keep only most important columns/variables.
#   - delete old observations/rows with missing data.
#   - give some columns/variables more meaningful names.
#   - copy Time variable and convert from Factor to numeric.
#   - save cleaned and prepared data in new data file.


## Load libraries:
library(lattice)
#library(ggplot2) # not used.
library(plyr)
library(xtable)

## Load functions from separate scripts:
source("func_timeToSec.R")
source("func_htmlPrint.R")


## Load raw data:
charts_orig = read.delim("charts.txt")
#str(charts_orig)  # simple sanity check.


# ## Remove redundant columns (save new data.frame):
# charts <- subset(charts_orig, select = -c(Source, Verified, B..Side, Time.Source, explicit,
#                                           Time..Album., SYMBL, ReIssue, Stereo..55.68.,
#                                           Pic.Sleeve, Comments))
# str(charts)


## Save important columns in new data.frame:
charts <- subset(charts_orig, select = c(Year, Yearly.Rank, Prefix, CH, X40, X10, PK, High, 
                                         Artist, Featured, Album, Track, Time, Genre, 
                                         Temp.1, Date.Entered, Date.Peaked))
#str(charts)


## Rename some columns to more meaningful names:
charts <- rename(charts, c("CH" = "nWeeksChart", "X40" = "nWeeksChartTop40", 
                           "X10" = "nWeeksChartTop10", "PK" = "nWeeksChartPeak", 
                           "Temp.1" = "ScorePoints"))
#str(charts)


## Remove rows - keep only data for years 1950-2013 (very little data for older songs):
charts <- subset(charts, Year > 1949)


## Create new Time column with numeric elements and add it to data.frame:
charts$Time.num <- sapply(charts$Time, func_timeToSec)
  #timeNum <- sapply(charts$Time, func_timeToSec)  # create numeric vector.
  #charts$Time.num <- timeNum  # add vector as column to data.frame.
#head(charts$Time)      # check that these times in mm:ss ...
#head(charts$Time.num)  # ... are equal to these times in seconds (also try for tail()).


# Find all rows with empty/blank element in Time column and replace with NA:
is.na(charts$Time) <- which(charts$Time == "")
charts <- subset(charts, !is.na(charts$Time))

# Remove all observations with blanks or "n/a"'s in nWeeksChart column.
charts <- subset(charts, !nWeeksChart == "")
charts <- subset(charts, !nWeeksChart == "n/a")
charts$nWeeksChart <- factor(charts$nWeeksChart)  # update factor levels.

# Convert nWeeksChart from Factor to Numeric:
charts$nWeeksChart <- as.numeric(levels(charts$nWeeksChart))[as.integer(charts$nWeeksChart)]


# Old attempt at adding a new column:
  # Rearrange charts data.frame w.r.t. Prefix in descending order:
  #charts <- arrange(charts, desc(Prefix))  # descending order.
  #charts <- arrange(charts, Prefix)
  
  # This somewhat does the job - but the order is different than the original.
  # I order by the Prefix, so I need to order the original data.frame by Prefix as well.
  #time_num2 <- tapply(charts$Time, charts$Prefix, func_timeToSec, simplify = TRUE)
  #time_num2_factor <- as.factor(time_num2)  # create a factor.
  
  #charts$Time_num <- time_num2_factor   # add column to data.frame.
  
  #charts <- arrange(charts, desc(Year), Prefix) # this actually gets back the original order.
# --- End of old attempt.


## Write cleaned data to file:
write.table(charts, "charts_clean.tsv", quote = FALSE, sep = "\t", row.names = FALSE)

