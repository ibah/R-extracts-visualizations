# options(digits=7) # set the number of significant digits
l <- function(x, n=4) format(round(x,n), nsmall=n) # nicer printing of floats

# Dates
format(Sys.time(), "%a %b %d %X %Y %Z")
# Dates for the ORG Agenda
x <- as.Date('2017-01-01')
con <- file('dates.txt','w')
while (x < as.Date('2017-04-01')) {
    text <- (toupper(trimws(format(x, '%e/ %a'))))
    #print(text)
    writeLines(paste0(text,'\n'), con)
    x <- x + 1
}
close(con)


