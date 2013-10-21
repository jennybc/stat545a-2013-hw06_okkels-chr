## Description:
#  - Function to convert "mm:ss" times (and generally "dd hh:mm:ss" times) into seconds.
#  - Saves them as numeric.

func_timeToSec <- function(time) {
  
  t <- strsplit(as.character(time), " |:")[[1]]
  seconds <- NaN
  
  if (length(t) == 1 )
    seconds <- as.numeric(t[1])
  else if (length(t) == 2)
    seconds <- as.numeric(t[1]) * 60 + as.numeric(t[2])
  else if (length(t) == 3)
    seconds <- (as.numeric(t[1]) * 60 * 60 
                + as.numeric(t[2]) * 60 + as.numeric(t[3]))   
  else if (length(t) == 4)
    seconds <- (as.numeric(t[1]) * 24 * 60 * 60 +
                  as.numeric(t[2]) * 60 * 60  + as.numeric(t[3]) * 60 +
                  as.numeric(t[4]))
  
  return(seconds)
}

# Source: "http://stackoverflow.com/questions/1389428/dealing-with-time-periods-
#                                                          such-as-5-minutes-and-30-seconds-in-r"
