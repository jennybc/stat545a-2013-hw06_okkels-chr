### STAT 545A - Homework 6  ###
### Christian Birch Okkels  ###
###############################

### Description:
#   Makefile script:
#   - clean out previous work (saved data.frames, plots, etc.),
#   - source/run data cleaning, aggregation, and plotting scripts.


## Clean out any previous work:
outputs <- c("charts_clean.tsv",                      # from data_cleanPrepare.R
             "table_maxSongLengthInfoEachYear.txt",   # from data_aggregatePlot.R
             "table_minSongLengthInfoEachYear.txt",
             "table_songLengthStatsEachYear.txt",
             "table_songLengthStatsEachYear2.txt",
             "table_nSongsLongerThanAvgEachYear.txt",
             "table_nSongsChartLongerEachYear.txt",
             "table_maxScorePointsEachYear.txt",
             "table_longestChartingSongsEachYear.txt",
             list.files(pattern = "*.pdf$"),    # all .pdf files (plots)
             list.files(pattern = "*.png$"))    # all .png files (plots)
file.remove(outputs)


## Run scripts:
source("data_cleanPrepare.R")
source("data_aggregatePlot.R")

