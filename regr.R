# Regression line plots
library(UsingR); fit <- lm(sheight~fheight, data=father.son)
# basic
plot(father.son)
abline(fit, col='red')
# ggplot
require(ggplot2)
ggplot(father.son, aes(x=fheight, y=sheight)) + geom_point() +
    geom_smooth(method=lm, col='red')
ggplot(father.son, aes(x=fheight, y=sheight)) + geom_point() +
    geom_abline(intercept=coef(fit)[1], slope=coef(fit)[2], col='red')
# several regression lines in one plot
# 1
# you have to standardize the data to show on the same scale
require(ggplot2); require(reshape2)
tmp <- melt(as.data.frame(scale(Seatbelts)),
            id.vars='DriversKilled',
            measure.vars=c('kms','PetrolPrice'))
ggplot(tmp, aes(x=value,y=DriversKilled,col=variable)) +
    geom_point() + geom_smooth(method=lm) +
    facet_wrap(~variable)
# [DRAFTS]
require(ggplot2)
ggplot(mtcars) + 
    geom_jitter(aes(disp,mpg), colour="blue") + geom_smooth(aes(disp,mpg), method=lm, se=FALSE, col='blue') +
    geom_jitter(aes(hp,mpg), colour="green") + geom_smooth(aes(hp,mpg), method=lm, se=FALSE, col='green') +
    geom_jitter(aes(qsec,mpg), colour="red") + geom_smooth(aes(qsec,mpg), method=lm, se=FALSE, col='red') +
    labs(x = "disp/hp/qsec", y = "mpg")
require(ggplot2)
require(reshape2)
mtcars2 = melt(mtcars, id.vars='mpg')
ggplot(mtcars2) +
    geom_jitter(aes(value,mpg, colour=variable)) +
    geom_smooth(aes(value,mpg, colour=variable), method=lm, se=FALSE) + # doesn't display the lines
    facet_wrap(~variable, scales="free_x") +
    labs(x = "Percentage cover (%)", y = "Number of individuals (N)")



# Plots of the residuals
# basic
library(UsingR)
plot(diamond$carat, diamond$price,  
     xlab = "Mass (carats)", 
     ylab = "Price (SIN $)", 
     bg = "lightblue", 
     col = "black", cex = 2, pch = 21,frame = FALSE)
fit <- lm(price~carat, data=diamond)
abline(fit, lwd = 2)  # adding the fit line
n <- nrow(diamond)
x <- diamond$carat
y <- diamond$price
yhat <- fit$fitted.values
for (i in 1 : n) 
    lines(c(x[i], x[i]), c(y[i], yhat[i]), col = "red" , lwd = 2)  # adding the lines for residuals





# Intervals (Confidence and prediction)
library(UsingR)
y <- diamond$price; x <- diamond$carat; n <- length(y)
# explicit derivation of the intervals
beta1 <- cor(y,x)*sd(y)/sd(x)
beta0 <- mean(y) - beta1*mean(x)
yhat <- beta0 + beta1*x
e <- yhat - y
sigma <- sqrt(sum(e^2) / (n-2))
ssx <- sum((x - mean(x))^2)
seRegr <- function(x0) {
    sigma * sqrt(1/n + (x0-mean(x))^2/ssx)
}
sePred <- function(x0) {
    sigma * sqrt(1 + 1/n + (x0-mean(x))^2/ssx)
}
qt_ <- qt(0.975,n-2)

# note: actual observed x are used
# note: it is better to use a set of equally spread x's over the range 

# basic
sx <- sort(x) # for basic:lines one has to have the points sorted first
syhat <- sort(yhat)
plot(x, y); abline(a=beta0, b=beta1, col='red')
lines(sx, syhat+qt_*seRegr(sx), col='blue')
lines(sx, syhat-qt_*seRegr(sx), col='blue')
lines(sx, syhat+qt_*sePred(sx), col='green')
lines(sx, syhat-qt_*sePred(sx), col='green')

# ggplot2
ggplot(data.frame(
    x=x, y=y, yhat=yhat, # ggplot2:geom_line sorts the points by default
    confidence.interval.upper=yhat+qt_*seRegr(x),
    confidence.interval.lower=yhat-qt_*seRegr(x),
    prediction.interval.upper=yhat+qt_*sePred(x),
    prediction.interval.lower=yhat-qt_*sePred(x)
)) + geom_point(aes(x=x,y=y)) +
    geom_abline(intercept=beta0, slope=beta1, col='red') +
    geom_line(aes(x=x,y=confidence.interval.upper),col='blue') +
    geom_line(aes(x=x,y=confidence.interval.lower),col='blue') +
    geom_line(aes(x=x,y=prediction.interval.upper),col='green') +
    geom_line(aes(x=x,y=prediction.interval.lower),col='green')

# below: using a set of equally spread x's

# ggplot2
y <- diamond$price; x <- diamond$carat; n <- length(y)
fit <- lm(y~x)
newx = data.frame(x = seq(min(x), max(x), length = 100))
# obtainig the intervals using R function:
p1 = data.frame(predict(fit, newdata= newx,interval = ("confidence")))
p2 = data.frame(predict(fit, newdata = newx,interval = ("prediction")))
# adding columns to the intervals data frames
p1$interval = "confidence"
p2$interval = "prediction"
p1$x = newx$x
p2$x = newx$x
dat = rbind(p1, p2) # merging into one data frame
names(dat)[1] = "y" # replace 'fit' with 'y'
library(ggplot2)
ggplot(dat, aes(x = x, y = y)) +
    geom_ribbon(aes(ymin = lwr, ymax = upr, fill = interval), alpha = 0.2) +
    geom_line() +
    geom_point(data = data.frame(x = x, y=y), aes(x = x, y = y), size = 2)


