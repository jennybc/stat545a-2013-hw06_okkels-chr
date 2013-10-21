### STAT 545A - Homework 6  ###
### Christian Birch Okkels  ###
###############################

### Description:
#   Data aggregation and plotting script:
#   - read cleaned, prepared data.
#   - perform data aggregation and plotting.
#   - write tables and plots to file.


## Load libraries:
library(lattice)
#library(ggplot2) # not used.
library(plyr)
library(xtable)

## Load functions:
source("func_timeToSec.R")
source("func_htmlPrint.R")


## Load cleaned data:
charts <- read.delim("charts_clean.tsv")
#str(charts)


## Song length distribution:
densityplot(~Time.num, charts, plot.points = FALSE, ref = TRUE,
            main = "Song length distribution",
            xlab = "Song length (seconds)", ylab = "Density")

histogram(~Time.num, charts, nint = 50, col = "blue",
          main = "Song length distribution", xlab = "Song length (seconds)")
## ----- END of song length distribution.


## Song length vs. year:
startYear <- min(charts$Year) # starting year (used for plotting x-range).
endYear <- max(charts$Year)   # final year (used for plotting x-range).
  # xyplot:
songLengthVsYear_xyPlot <- xyplot(Time.num ~ Year, charts, 
       main = "Song length vs. year", xlab = "Year", ylab = "Song length (seconds)", grid = TRUE,
       scales = list(y = list(at = seq(0, 600, 30)),
                     x = list(at = seq(startYear, endYear, 5))),
       type = c("p", "a"), col.line = "darkorange", lwd = 3,  # draw orange line through averages.
       alpha = 0.5) # combat overplotting via alpha.
  # print to screen, then write to file:
print(songLengthVsYear_xyPlot)
postscript("plot_songLengthVsYear_xyPlot.ps")
print(songLengthVsYear_xyPlot)
dev.off()
  # xyplot with smoothScatter:
songLengthVsYear_xyPlot2 <- xyplot(Time.num ~ Year, charts, 
       main = "Song length vs. year", xlab = "Year", ylab = "Song length (seconds)", grid = TRUE,
       scales = list(y = list(at = seq(0, 600, 30)),
                     x = list(at = seq(startYear, endYear, 5))),
       panel = panel.smoothScatter) # combat overplotting via smoothScatter.
  # print to screen, then write to file:
print(songLengthVsYear_xyPlot2)
pdf("plot_songLengthVsYear_xyPlot2.pdf")
print(songLengthVsYear_xyPlot2)
dev.off()
  # stripplot:
songLengthVsYear_stripplot <- stripplot(Time.num ~ factor(Year), charts, grid = TRUE, alpha = 0.5,
          main = "Song length vs. year", xlab = "Year", ylab = "Song length (seconds)",
          scales = list(y = list(at = seq(0, 600, 30),      # "at" controls tick positions.
                                 rot = c(0,0), cex = 0.8),  # "rot" is rotation, "cex" font size.
                        x = list(rot = c(45,0), cex = 0.6)))
  # print to screen, then write to file:
print(songLengthVsYear_stripplot)
pdf("plot_songLengthVsYear_stripplot.pdf")
print(songLengthVsYear_stripplot)
dev.off()
## ----- END of song length vs. year.


## Song length vs. decade:
  # experiment with cut() to get decades:
Decade <- cut(charts$Year, 6, 
              labels = c("1950s", "1960s", "1970s", "1980s", "1990s", "2000s"))
  # stripplot with smoothScatter:
songLengthVsDecade_stripplot <- stripplot(Time.num ~ Decade, charts, grid = TRUE, 
                                          main = "Song length vs. decade", 
                                          xlab = "Decade", ylab = "Song length (seconds)",
                                          jitter.data = TRUE, panel = panel.smoothScatter,
                                          scales = list(y = list(at = seq(0, 600, 30), 
                                                                 rot = c(0,0), cex = 0.8),
                                                        x = list(rot = c(0,0), cex = 0.8)))
  # print to screen, then write to file:
print(songLengthVsDecade_stripplot)
pdf("plot_songLengthVsDecade_stripplot.pdf")
print(songLengthVsDecade_stripplot)
dev.off()
  # stripplot with alpha:
songLengthVsDecade_stripplot2 <- stripplot(Time.num ~ Decade, charts, grid = TRUE, 
                                           main = "Song length vs. decade", 
                                           xlab = "Decade", ylab = "Song length (seconds)",
                                           jitter.data = TRUE, alpha = 0.4,
                                           scales = list(y = list(at = seq(0, 600, 30), 
                                                                  rot = c(0,0), cex = 0.8),
                                                         x = list(rot = c(0,0), cex = 0.8)))
  # print to screen, then write to file:
print(songLengthVsDecade_stripplot2)
pdf("plot_songLengthVsDecade_stripplot2.pdf")
print(songLengthVsDecade_stripplot2)
dev.off()
## ----- END of song length vs. decade.


## Min., max., average song length / track time for ALL years:
maxTimeAllYears <- max(charts$Time.num, na.rm = TRUE) # na.rm = TRUE removes NA entries.
minTimeAllYears <- min(charts$Time.num, na.rm = TRUE)
avgTimeAllYears <- mean(charts$Time.num, na.rm = TRUE)

sprintf("Average song length for years %d-%d = %4.2f seconds.", 
        min(charts$Year), max(charts$Year), avgTimeAllYears)

# which.max(charts$Time.num)  # gets the index of the longest song.
# which.min(charts$Time.num)  # gets the index of the shortest song.
# charts[which.max(charts$Time.num)]  # gets all columns for longest song.
# charts[which.min(charts$Time.num)]  # gets all columns for shortest song.
# charts$Track[which.max(charts$Time.num)]  # this should get the track/song title.
# charts$Track[which.min(charts$Time.num)]  # this should get the track/song title.
# charts[which.min(charts$Time.num), c("Year", "Track", "Artist", "Time.num", "Time")] # more info.
# charts[which.max(charts$Time.num), c("Year", "Track", "Artist", "Time.num", "Time")] # more info.
## ----- END of min., max., average song length for all years.


## Shortest & longest songs each year (and for all years) - and info about them:
minSongLengthInfoEachYear <- ddply(charts, ~ Year, function(x) {
  theMin <- which.min(x$Time.num)
  shortestSongInfo <- x[theMin, c("Year", "Track", "Artist", "Time.num", "Time")]
  shortestSongInfo <- rename(shortestSongInfo, c("Time.num" = "TimeInSeconds"))
})
maxSongLengthInfoEachYear <- ddply(charts, ~ Year, function(x) {
  theMax <- which.max(x$Time.num)
  longestSongInfo <- x[theMax, c("Year", "Track", "Artist", "Time.num", "Time")]
  longestSongInfo <- rename(longestSongInfo, c("Time.num" = "TimeInSeconds"))
})
write.table(minSongLengthInfoEachYear, "table_minSongLengthInfoEachYear.txt", 
            quote = FALSE, sep = "\t", row.names = FALSE)   # write to file.
write.table(maxSongLengthInfoEachYear, "table_maxSongLengthInfoEachYear.txt", 
            quote = FALSE, sep = "\t", row.names = FALSE)   # write to file.
htmlPrint(minSongLengthInfoEachYear)    # print HTML table.
htmlPrint(maxSongLengthInfoEachYear)    # print HTML table.

  # get info for shortest and longest songs for ALL years:
minSongLengthInfoEachYear[which.min(minSongLengthInfoEachYear$TimeInSeconds),
                          c("Year", "Track", "Artist", "TimeInSeconds", "Time")]
maxSongLengthInfoEachYear[which.max(maxSongLengthInfoEachYear$TimeInSeconds),
                          c("Year", "Track", "Artist", "TimeInSeconds", "Time")]
  # another way to obtain the same:
#charts[which.min(charts$Time.num), c("Year", "Track", "Artist", "Time.num", "Time")]
#charts[which.max(charts$Time.num), c("Year", "Track", "Artist", "Time.num", "Time")]
## ----- END of shortest/longest songs (and info) each year.


## Average, min., and max. song length each year:
songLengthStatsEachYear <- ddply(charts, ~ Year, summarize, minTime = min(Time.num, na.rm = TRUE),
                                 maxTime = max(Time.num, na.rm = TRUE), 
                                 avgTime = mean(Time.num, na.rm = TRUE), 
                                 medianTime = median(Time.num, na.rm = TRUE), 
                                 sdTime = sd(Time.num, na.rm = TRUE), 
                                 madTime = mad(Time.num, na.rm = TRUE))
write.table(songLengthStatsEachYear, "table_songLengthStatsEachYear.txt", 
            quote = FALSE, sep = "\t", row.names = FALSE)   # write to file.
htmlPrint(songLengthStatsEachYear)  # print HTML table.

  # do the above in a smarter way:
songLengthStatsEachYear2 <- ddply(charts, ~ Year, function(x) {
  cLevels <- c("min", "max", "avg")
  data.frame(stat = factor(cLevels, levels = cLevels),
             songLength = c(range(x$Time.num, na.rm = TRUE), mean(x$Time.num, na.rm = TRUE))
             )
})
  # write table to file:
write.table(songLengthStatsEachYear2, "table_songLengthStatsEachYear2.txt", 
            quote = FALSE, sep = "\t", row.names = FALSE)
  # print HTML table:
htmlPrint(songLengthStatsEachYear2)
  # plot:
minMaxAvgSongLengthVsYear <- xyplot(songLength ~ Year, songLengthStatsEachYear2,
                                    main = "min, max, and average song length vs. year",
                                    ylab = "Song length (seconds)",
                                    group = stat, type = "b", grid = "h", as.table = TRUE,
                                    auto.key = list(columns = 3))
print(minMaxAvgSongLengthVsYear)
  # save plot to file:
pdf("plot_minMaxAvgSongLengthVsYear.pdf")
print(minMaxAvgSongLengthVsYear)
dev.off()
## ----- END of avg., min., max. song length each year.


## Number of songs per year:
nSongsEachYear <- ddply(subset(charts, Year > 1955), ~ Year, summarize, nSongs = length(Prefix))
  # above, we skip year 1955 and older since they lack many data points.
  # the variable Prefix is unique for each song, which is optimal for this case.

  # plot:
nSongsVsYear <- xyplot(nSongs ~ Year, nSongsEachYear, 
                       main = "No. of songs on the charts vs. year", ylab = "No. of songs",
                       type = "b", grid = "h")
print(nSongsVsYear)
  # write plot to file:
pdf("plot_nSongsVsYear.pdf")
print(nSongsVsYear)
dev.off()

## ----- END of no. of songs per year.


## Proportion of songs for each year with length >= avg. song length (over all years):
threshold <- mean(charts$Time.num, na.rm = TRUE)
nSongsLongerThanAvgEachYear <- ddply(subset(charts, Year > 1955), ~ Year, function(x) {
  count <- sum(x$Time.num >= threshold, na.rm = TRUE)
  total <- nrow(x)
  prop <- count / total
  data.frame(Count = count, Total = total, Proportion = prop)
  #return(sprintf("%1.2f (%d/%d)", prop, count, total))
})
  # write table to file:
write.table(nSongsLongerThanAvgEachYear, "table_nSongsLongerThanAvgEachYear.txt", 
            quote = FALSE, sep = "\t", row.names = FALSE)
  # print HTML table:
htmlPrint(nSongsLongerThanAvgEachYear)
  # plot:
propSongsLongerThanAvgVsYear <- xyplot(Proportion ~ Year, nSongsLongerThanAvgEachYear,
       main = paste("Proportion of songs with length >= ", threshold, "(= avg. over all years)"),
       ylab = "Proportion of songs", type = "b", grid = "h")
print(propSongsLongerThanAvgVsYear)
  # write plot to file:
pdf("plot_propSongsLongerThanAvgVsYear.pdf")
print(propSongsLongerThanAvgVsYear)
dev.off()
## ----- END proportion of songs with length >= avg. song length.


## Longest charting songs:

# Comments: here, we see which songs have charted the longest in top 100, top 40, and top 10.

# overall (top 100):
charts[which.max(charts$nWeeksChart), c("Track", "Artist", "Time", "Date.Entered",
                                        "High", "Date.Peaked", "nWeeksChart")]
# in top 40:
charts[which.max(charts$nWeeksChartTop40), c("Track", "Artist", "Time", "Date.Entered",
                                             "High", "Date.Peaked", "nWeeksChartTop40")]
# in top 10:
charts[which.max(charts$nWeeksChartTop10), c("Track", "Artist", "Time", "Date.Entered",
                                             "High", "Date.Peaked", "nWeeksChartTop10")]
# song that charted longest at its peak/highest position:
charts[which.max(charts$nWeeksChartPeak), c("Track", "Artist", "Time", "Date.Entered",
                                            "High", "Date.Peaked", "nWeeksChartPeak")]

# above songs are from 1995 to now. Try earlier years:
tmp <- subset(charts, Year < 1990)
tmp[which.max(tmp$nWeeksChart), c("Track", "Artist", "Time", "Date.Entered", "High", 
                                  "Date.Peaked", "nWeeksChart")]
tmp[which.max(tmp$nWeeksChartTop40), c("Track", "Artist", "Time", "Date.Entered", "High", 
                                       "Date.Peaked", "nWeeksChartTop40")]
tmp[which.max(tmp$nWeeksChartTop10), c("Track", "Artist", "Time", "Date.Entered", "High", 
                                       "Date.Peaked", "nWeeksChartTop10")]
tmp[which.max(tmp$nWeeksChartPeak), c("Track", "Artist", "Time", "Date.Entered", "High", 
                                      "Date.Peaked", "nWeeksChartPeak")]

  # are songs charting longer now than earlier?
nWeeksInTop100vsYear <- xyplot(nWeeksChart ~ Year, subset(charts, Year > 1955), grid = "h", 
       main = "No. of weeks a song has charted in Top 100 vs. Year", ylab = "No. of weeks",
       type = c("p", "a"), col.line = "darkorange", lwd = 3, alpha = 0.5)
nWeeksInTop100vsYear2 <- stripplot(nWeeksChart ~ factor(Year), subset(charts, Year > 1955), 
          main = "No. of weeks a song has charted in Top 100 vs. Year", ylab = "No. of weeks",
          type = c("p", "a"), col.line = "darkorange", lwd = 3, alpha = 0.5, grid = "h",
          scales = list(x = list(rot = c(45,0), cex = 0.7)))
print(nWeeksInTop100vsYear)
print(nWeeksInTop100vsYear2)
  # write plots to file:
pdf("plot_nWeeksInTop100vsYear.pdf")
print(nWeeksInTop100vsYear)
dev.off()
pdf("plot_nWeeksInTop100vsYear2.pdf")
print(nWeeksInTop100vsYear2)
dev.off()
# Comments to plot: a few songs in newer time are charting very long! but average is decreasing.

## ---- END of longest charting songs.


## Chart position, weeks on chart, etc. vs. song length:

  # Comment: Does song length influence success on the charts? Are longer/shorter songs better?

# xyplot(High ~ Time.num, charts, alpha = 0.5)
# xyplot(High ~ Time.num | cut(Year, 6), charts, alpha = 0.5)
# xyplot(nWeeksChart ~ Time.num, charts, alpha = 0.1)
# xyplot(ScorePoints ~ Time.num, charts)

  # longest charting songs (in Top 100, 40, 10) and their lengths for each year:
longestChartingSongsEachYear <- ddply(charts, ~ Year, function(x) {
  max_nWeeksChart <- max(x$nWeeksChart)
  theMax_nWeeksChart <- which.max(x$nWeeksChart)
  max_nWeeksChartTop40 <- max(x$nWeeksChartTop40)
  theMax_nWeeksChartTop40 <- which.max(x$nWeeksChartTop40)
  max_nWeeksChartTop10 <- max(x$nWeeksChartTop10)
  theMax_nWeeksChartTop10 <- which.max(x$nWeeksChartTop10)
  cLevels <- c("weeksInTop100", "weeksInTop40", "weeksInTop10")
  data.frame(successMeasure = factor(cLevels, levels = cLevels),
             nWeeks = c(max_nWeeksChart, max_nWeeksChartTop40, max_nWeeksChartTop10),
             Track = c(as.character(x$Track[theMax_nWeeksChart]), 
                       as.character(x$Track[theMax_nWeeksChartTop40]),
                       as.character(x$Track[theMax_nWeeksChartTop10])),
             Artist = c(as.character(x$Artist[theMax_nWeeksChart]), 
                        as.character(x$Artist[theMax_nWeeksChartTop40]),
                        as.character(x$Artist[theMax_nWeeksChartTop10])),
             songLength = c(x$Time.num[theMax_nWeeksChart], x$Time.num[theMax_nWeeksChartTop40],
                            x$Time.num[theMax_nWeeksChartTop10])
  )
})
  # write table to file:
write.table(longestChartingSongsEachYear, "table_longestChartingSongsEachYear.txt", 
            quote = FALSE, sep = "\t", row.names = FALSE)
  # print HTML table:
htmlPrint(longestChartingSongsEachYear)
  # plot:
nWeeksOnChartsVsSongLength <- xyplot(nWeeks ~ songLength, longestChartingSongsEachYear, 
                                     group = successMeasure,
       main = "Longest charting songs (3 different measures) for each year vs. song length",
       xlab = "Song length (seconds)", ylab = "No. of weeks",
       grid = "h", auto.key = list(columns = 3))
print(nWeeksOnChartsVsSongLength)
  # save plot to file:
pdf("plot_nWeeksOnChartsVsSongLength.pdf")
print(nWeeksOnChartsVsSongLength)
dev.off()

  # average song length based on longest charting songs,
  # - i.e. "best" song length for success:
bestSongLengthForSucess <- mean(longestChartingSongsEachYear$songLength)
sprintf("Best song length for staying on charts = %4.2f seconds.", bestSongLengthForSucess)

## ----- END of chart position, weeks on chart, etc. vs. song length.


## Number and proportion of songs charting longer than 10 weeks in Top 100 vs. year:
benchmark <- 10
nSongsChartLongerEachYear <- ddply(subset(charts, Year > 1955), ~ Year, function(x) {
  count <- sum(x$nWeeksChart >= benchmark, na.rm = TRUE)
  total <- nrow(x)
  prop <- count / total
  data.frame(Count = count, Total = total, Proportion = prop)
})
  # write table to file:
write.table(nSongsChartLongerEachYear, "table_nSongsChartLongerEachYear.txt", 
            quote = FALSE, sep = "\t", row.names = FALSE)
  # print HTML table:
htmlPrint(nSongsChartLongerEachYear)
  # plot:
propSongsChartLongerVsYear <- xyplot(Proportion ~ Year, nSongsChartLongerEachYear,
                                     main = paste("Proportion of songs charting in Top 100 
                                                  longer than", benchmark, "weeks vs. Year"),
                                     ylab = "Proportion", type = "b", grid = "h")
print(propSongsChartLongerVsYear)
  # write plot to file:
pdf("plot_propSongsChartLongerVsYear.pdf")
print(propSongsChartLongerVsYear)
dev.off()
## ----- END of no. and proportion of songs charting longer than 10 weeks in Top 100 vs. year.


## "Best songs" in terms of max. ScorePoints:
  # all-time:
charts[which.max(charts$ScorePoints), c("Year", "Track", "Artist", "Time", "Date.Entered", 
                                        "nWeeksChart", "nWeeksChartTop40", "nWeeksChartTop10", 
                                        "nWeeksChartPeak", "High", "ScorePoints")]
  # each year:
maxScorePointsEachYear <- ddply(charts, ~ Year, function(x) {
  theMax <- which.max(x$ScorePoints)
  maxScorePointsSongInfo <- x[theMax, c("Year", "Track", "Artist", "Time", "Date.Entered", 
                                        "nWeeksChart", "nWeeksChartTop40", "nWeeksChartTop10", 
                                        "nWeeksChartPeak", "High", "ScorePoints")]
})
  # write table to file:
write.table(maxScorePointsEachYear, "table_maxScorePointsEachYear.txt", 
            quote = FALSE, sep = "\t", row.names = FALSE)
  # print HTML table:
htmlPrint(maxScorePointsEachYear)
## ----- END of "best songs" in terms of max. ScorePoints.




# Test with Code Externalization:
## ---- my-label ----
1+1
2+2


