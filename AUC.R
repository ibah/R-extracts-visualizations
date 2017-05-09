library(ggplot2)

# data for the plot
draws <- rnorm(100)^2
dens <- density(draws)
q75 <- quantile(draws, .75)
q95 <- quantile(draws, .95)

# base: abline
plot(dens)
abline(v=q75)
abline(v=q95)

# base: polygon
plot(dens)
x1 <- min(which(dens$x >= q75))
x2 <- max(which(dens$x <  q95))
with(dens, polygon(x=c(x[c(x1,x1:x2,x2)]), y=c(0,y[x1:x2],0), col="gray"))

# ggplot2: polygon
#d <- as.data.frame(dens[c('x','y')])
#p <- ggplot(d, aes(x=x, y=y)) + geom_line()
#shade <- subset(d, x>=q75 & x<q95)
#shade <- rbind(c(q75,0), shade, c(q95,0)) # this gives boundaries that are not exactly vertical
#p + geom_polygon(data=shade, mapping=aes(x=x, y=y))
# exactly vertical
dd <- with(dens,data.frame(x,y))
x1 <- min(which(dd$x >= q75))
x2 <- max(which(dd$x <  q95))
shade <- rbind(c(d$x[x1],0), subset(d, x>=q75 & x<q95), c(d$x[x2],0))
qplot(x, y, data=dd, geom='line') +
    geom_polygon(data=shade, mapping=aes(x=x, y=y))

# ggplot2: ribbon
dd <- with(dens,data.frame(x,y))
qplot(x,y,data=dd,geom="line")+
    geom_ribbon(data=subset(dd,x>q75 & x<q95),aes(ymax=y),ymin=0,
                fill="red",colour=NA,alpha=0.5)



####### trash ##########

# other examples
# basic: polygon
xv<-seq(0,4,0.01)
yv<-dnorm(xv,2,0.5) 
plot(xv,yv,type="l")
c(xv[xv<=1.5],1.5) # x points, the last point is (1.5, 0), where 0 is actually pnrom(0,2,0.5)
c(yv[xv<=1.5],yv[xv==0]) # y points
polygon(c(xv[xv<=1.5],1.5),c(yv[xv<=1.5],yv[xv==0]),col="grey")
# ggplot2: polygon
x<-seq(0.0,0.1699,0.0001)   
ytop<-dnorm(0.12,0.08,0.02)
MyDF<-data.frame(x=x,y=dnorm(x,0.08,0.02))
p<-qplot(x=MyDF$x,y=MyDF$y,geom="line")
p+geom_segment(aes(x=0.12,y=0,xend=0.12,yend=ytop))
#First subst the data and add the coordinates to make it shade to y = 0
shade <- rbind(c(0.12,0), subset(MyDF, x > 0.12), c(MyDF[nrow(MyDF), "X"], 0))
#Then use this new data.frame with geom_polygon
p + geom_segment(aes(x=0.12,y=0,xend=0.12,yend=ytop)) +
    geom_polygon(data = shade, aes(x, y))
# ribbon
#  same data, just renaming columns for clarity later on
#  also, use data tables
library(data.table)
set.seed(1)
value <- c(rnorm(50, mean = 1), rnorm(50, mean = 3))
site  <- c(rep("site1", 50), rep("site2", 50))
dt    <- data.table(site,value)
#  generate kdf
gg <- dt[,list(x=density(value)$x, y=density(value)$y),by="site"]
#  calculate quantiles
q1 <- quantile(dt[site=="site1",value],0.01)
q2 <- quantile(dt[site=="site2",value],0.75)
# generate the plot
ggplot(dt) + stat_density(aes(x=value,color=site),geom="line",position="dodge")+
    geom_ribbon(data=subset(gg,site=="site1" & x>q1),
                aes(x=x,ymax=y),ymin=0,fill="red", alpha=0.5)+
    geom_ribbon(data=subset(gg,site=="site2" & x<q2),
                aes(x=x,ymax=y),ymin=0,fill="blue", alpha=0.5)