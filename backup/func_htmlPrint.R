
## Description:
#  - Function to make HTML tables.

htmlPrint <- function(x, ...,
                      digits = 0, include.rownames = FALSE) {
  print(xtable(x, digits = digits, ...), type = 'html',
        include.rownames = include.rownames)
}





