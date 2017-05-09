# custom function
library(ggplot2)
ggplot(data.frame(x=c(-2,2)),aes(x=x)) +
    stat_function(fun=function(x) {x^2})
ggplot(data.frame(x=0),aes(x=x)) + # data are irrelevant, xlim sets up the range over which the function is drawn
    stat_function(fun=function(x) {x^2}) + xlim(-3,3)
ggplot(data.frame(x=0),aes(x=x)) +
    stat_function(fun=function(x) {x^2}, xlim=c(-3,3))
# the same but with some data points + vertical, horizontal and ab lines
ggplot(data.frame(x=rnorm(100), y=rnorm(100)), aes(x=x, y=y)) +
    geom_point() +
    stat_function(fun=function(x) {x^2}) +
    geom_abline(slope=2, intercept=-1) +
    geom_hline(yintercept=6) +
    geom_vline(xintercept=-1)
# basic
x <- 1:100
f <- function(x) {x^2}
plot(x, f(x), type='l')

# Correlogram
library(corrgram)
str(mtcars) # all data has to be numeric
corrgram(mtcars)
corrgram(mtcars,
         lower.panel=panel.ellipse, upper.panel=panel.pie,
         main='mtcars correlogram')

# boxplot
# factor * numerical
data(mtcars)
boxplot(mpg~cyl,data=mtcars, main="Car Milage Data",
        xlab="Number of Cylinders", ylab="Miles Per Gallon",
        col=c('lightblue','lightgreen','salmon'))
# violin plot
# factor * numerical
library(vioplot); data(mtcars)
x1 <- mtcars$mpg[mtcars$cyl==4]
x2 <- mtcars$mpg[mtcars$cyl==6]
x3 <- mtcars$mpg[mtcars$cyl==8]
vioplot(x1, x2, x3, names=c("4 cyl", "6 cyl", "8 cyl"), 
        col="gold")
title("Violin Plots of Miles Per Gallon")


# bagplot
# = 2D boxplot
library(aplpack); data(mtcars); attach(mtcars)
bagplot(wt,mpg, xlab="Car Weight", ylab="Miles Per Gallon",
        main="Bagplot Example")
detach(mtcars)



# color selected points on the plot
outlayers <- c(17,18,20,8)

# 1
# basic
col <- sapply(1:nrow(mtcars), function(x) as.numeric(x %in% outlayers) + 1)
with(mtcars, plot(wt, mpg, col=col, pch=16))

# 2
# ggplot2
library(ggplot2)
outlayer <- sapply(1:nrow(mtcars), function(x) x %in% outlayers)
ggplot(mtcars, aes(x=wt, y=mpg)) +
    geom_point(aes(col=outlayer))



# INTERACTIVE



# identify points on a scatterplot
# press ESC to quit

# 1
# put labels on the plot and return indeces
x = 1:10
y = x^2
name = letters[1:10]    
plot(x, y)
identify(x, y, labels = name, plot=TRUE)
# -> Now you have to click on the points and select finish at the end. The output will be the labels you have corresponding to the dots.

# 2
# mark the points (overplot) and return indeces
identifyPch <- function(x, y = NULL, n = length(x), pch = 19, ...)
{
    xy <- xy.coords(x, y); x <- xy$x; y <- xy$y
    sel <- rep(FALSE, length(x)); res <- integer(0)
    while(sum(sel) < n) {
        ans <- identify(x[!sel], y[!sel], n = 1, plot = FALSE, ...)
        if(!length(ans)) break
        ans <- which(!sel)[ans]
        points(x[ans], y[ans], pch = pch)
        sel[ans] <- TRUE
        res <- c(res, ans)
    }
    res
}
identifyPch(x, y)

# 3
# just return coordinates of clicks on a plot
locator(1) # number of clicks
locator(2,'p') # points are plotted
locator(2,'o') # points plotted and joined with a line (a path)
locator(2,'l') # just plotting a line
locator(4,'l') # just plotting a line

