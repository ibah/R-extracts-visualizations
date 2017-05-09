# Plot many lines in one plot

test_data <-
    data.frame(
        var0 = 100 + c(0, cumsum(runif(49, -20, 20))),
        var1 = 150 + c(0, cumsum(runif(49, -10, 10))),
        date = seq(as.Date("2002-01-01"), by="1 month", length.out=100)
    )

# ggplot2
library(ggplot2)

# manualy (for a few variables)
ggplot(test_data, aes(date)) + 
    geom_line(aes(y = var0, colour = "var0")) + 
    geom_line(aes(y = var1, colour = "var1"))

# general approach
# 1, melt
library(reshape2)
test_data_long <- melt(test_data, id="date")  # convert to long format
ggplot(data=test_data_long, aes(x=date, y=value, colour=variable)) +
    geom_line()
# 2, gather
library(tidyr)
test_data_gathered <- gather(test_data, 'Key', 'Value', -date)
ggplot(data=test_data_gathered, aes(x=date, y=Value, colour=Key)) +
    geom_line()
