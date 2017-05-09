# qplot basics
x <- rnorm(100)
y <- x+rnorm(100)
z <- x^2+rnorm(100)
ab <- as.factor(rep(c('A','B'),50))
cde <- as.factor(c('C',rep(c('C','D','E'),33)))
df <- data.frame(x,y,z,ab,cde)
head(df)
library(ggplot2)
# data
qplot(x,y)
qplot(x,y,data=df)
qplot(x,data=df) # histogram
qplot(y=y,data=df) # data points by row
# grouping
qplot(x,y,data=df,color=z)
qplot(x,y,data=df,color=ab)
qplot(x,y,data=df,shape=ab)
qplot(x,y,data=df,size=z)
qplot(x,y,data=df,size=ab) # bad practice
qplot(x,y,data=df,alpha=z)
qplot(x,y,data=df,alpha=ab)
qplot(x,y,data=df,fill=z) # bad, see below
qplot(x,y,data=df,fill=ab) # bad, see below
qplot(x,data=df,color=ab)
qplot(x,data=df,fill=ab)
qplot(ab,x,data=df,geom=c('boxplot','jitter'), color=ab)
qplot(ab,x,data=df,geom=c('boxplot','jitter'), color=ab, fill=cde)

# geoms
qplot(x,y,geom='point')
qplot(ab,y,geom='point') # bad, see jitter
qplot(ab,cde,geom='point') # bad, see jitter
qplot(x,y,geom='smooth')
qplot(x,y,geom='boxplot') # bad practice
qplot(ab,y,geom='boxplot')
qplot(ab,cde,geom='boxplot')
qplot(x,y,geom='line')
qplot(x,geom='histogram')
qplot(x,geom='density')
qplot(x,geom='bar') # bad practice
qplot(cde,geom='bar')
qplot(x,y,geom='jitter') # the same as point
qplot(ab,y,geom='jitter')
qplot(ab,cde,geom='jitter')
qplot(x,y,geom='path')
qplot(x,geom='dotplot')
# examples
qplot(x,y,data=df,color=cde,shape=ab)
qplot(x,z,data=df,geom='smooth', fill=ab)
qplot(x,y,data=df,color=z)
qplot(ab,cde,data=df,color=cde,shape=ab,geom='jitter')
qplot(x,geom='dotplot',color=ab)
qplot(x,geom='dotplot',fill=ab)
qplot(x,geom='dotplot',color=ab,fill=ab)
# smooth
qplot(x,y,geom='smooth', method='loess') # default
qplot(x,y,geom='smooth', method='lm')
qplot(x,y,geom='smooth', method='gam')
require(MASS); qplot(x,y,geom='smooth', method='rlm')
qplot(x,z,geom='smooth')
qplot(x,z,geom='smooth', method='lm')
qplot(x,z,geom='smooth', method='lm', formula=y~poly(x,2))
qplot(x,z,geom=c('point','smooth'))#, method='lm', formula=y~poly(x,2)) # Error: Unknown parameters: method, formula
# facets
qplot(x,y,data=df,facets=.~ab) # columns
qplot(x,y,data=df,facets=ab~.) # rows
qplot(x,y,data=df,facets=ab~cde)
# margins
qplot(x,y,data=df,facets=ab~cde,margins=T)
# examples
qplot(x,y,data=df,facets=ab~cde,size=z,color=cde,shape=ab)
qplot(x,y,data=df,facets=ab~cde,size=z,color=cde,shape=ab, margins=T)
qplot(x,y,data=df,facets=ab~cde,geom=c('point','smooth'))
qplot(x,y,data=df,facets=ab~cde,geom=c('point','smooth'), margins=T)
qplot(x,y,data=df,facets=ab~cde,geom=c('point','smooth'),color=cde,size=z)
qplot(x,y,data=df,facets=ab~cde,geom=c('point','smooth'),color=cde,size=z,margins=T)
# log, asp
qplot(x,y,data=df)
qplot(x,y,data=df,log='y')
qplot(x,y,data=df,asp=1)
qplot(x,y,data=df,asp=2)
# annotating, limiting
qplot(x,y,data=df,main='The Main Title',ylab='ylab',xlab='xlab')
qplot(x,y,data=df,main='The Main Title',ylab='ylab',xlab='xlab', xlim=c(-4,4), ylim=c(-4,4))

################################################################################

# qplot help
# Use data from data.frame
qplot(mpg, wt, data = mtcars)
qplot(mpg, wt, data = mtcars, colour = cyl)
qplot(mpg, wt, data = mtcars, size = cyl)
qplot(mpg, wt, data = mtcars, facets = vs ~ am)

qplot(1:10, rnorm(10), colour = runif(10))
qplot(1:10, letters[1:10])
mod <- lm(mpg ~ wt, data=mtcars)
qplot(resid(mod), fitted(mod))

f <- function() {
    a <- 1:10
    b <- a ^ 2
    qplot(a, b)
}
f()

# To set aesthetics, wrap in I()
qplot(mpg, wt, data = mtcars, colour = I("red"))

# qplot will attempt to guess what geom you want depending on the input
# both x and y supplied = scatterplot
qplot(mpg, wt, data = mtcars)
# just x supplied = histogram
qplot(mpg, data = mtcars)
# just y supplied = scatterplot, with x = seq_along(y)
qplot(y = mpg, data = mtcars)

# Use different geoms
qplot(mpg, wt, data = mtcars, geom = "path")
qplot(factor(cyl), wt, data = mtcars, geom = c("boxplot", "jitter"))
qplot(mpg, data = mtcars, geom = "dotplot")

################################################################################

# quick R
# ggplot2 examples
library(ggplot2) 
# create factors with value labels 
mtcars$gear <- factor(mtcars$gear,levels=c(3,4,5),
                      labels=c("3gears","4gears","5gears")) 
mtcars$am <- factor(mtcars$am,levels=c(0,1),
                    labels=c("Automatic","Manual")) 
mtcars$cyl <- factor(mtcars$cyl,levels=c(4,6,8),
                     labels=c("4cyl","6cyl","8cyl")) 
# Kernel density plots for mpg
# grouped by number of gears (indicated by color)
qplot(mpg, data=mtcars, geom="density", fill=gear, alpha=I(.5), 
      main="Distribution of Gas Milage", xlab="Miles Per Gallon", 
      ylab="Density")
# Scatterplot of mpg vs. hp for each combination of gears and cylinders
# in each facet, transmittion type is represented by shape and color
qplot(hp, mpg, data=mtcars, shape=am, color=am, 
      facets=gear~cyl, size=I(3),
      xlab="Horsepower", ylab="Miles per Gallon") 
# Separate regressions of mpg on weight for each number of cylinders
qplot(wt, mpg, data=mtcars, geom='smooth', # geom=c("point", "smooth"), generates an error:
      method="lm", formula=y~x, color=cyl, # Error: Unknown parameters: method, formula
      main="Regression of MPG on Weight", 
      xlab="Weight", ylab="Miles per Gallon")
# Boxplots of mpg by number of gears 
# observations (points) are overlayed and jittered
qplot(gear, mpg, data=mtcars, geom=c("boxplot", "jitter"), 
      fill=gear, main="Mileage by Gear Number",
      xlab="", ylab="Miles per Gallon")
# Customization
p <- qplot(hp, mpg, data=mtcars, shape=am, color=am, 
           facets=gear~cyl, main="Scatterplots of MPG vs. Horsepower",
           xlab="Horsepower", ylab="Miles per Gallon")
p
# White background and black grid lines
p + theme_bw()
library('ggthemes')
p + theme_few()
# Large brown bold italics labels
# and legend placed at top of plot
p + theme(axis.title=element_text(face="bold.italic", 
                                  size="12", color="brown"), legend.position="top")
