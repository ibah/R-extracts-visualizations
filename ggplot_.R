# ggplot basics
x <- rnorm(100)
y <- x+rnorm(100)
z <- x^2+rnorm(100)
ab <- as.factor(rep(c('A','B'),50))
cde <- as.factor(c('C',rep(c('C','D','E'),33)))
df <- data.frame(x,y,z,ab,cde)
head(df)
library(ggplot2)

# R for data science by Garrett Grolemund and Hadley Wickham
# http://r4ds.had.co.nz/visualize.html
# http://r4ds.had.co.nz/eda.html

# ggplot(data = <DATA>) + 
#     <GEOM_FUNCTION>(
#         mapping = aes(<MAPPINGS>),
#         stat = <STAT>, 
#         position = <POSITION>
#     ) +
#     <COORDINATE_FUNCTION> +
#     <FACET_FUNCTION>
#
# ggplot2 will provide useful defaults for everything except the data, the mappings, and the geom function

ggplot(df, aes(x=x)) + geom_histogram()

# Do cars with big engines use more fuel than cars with small engines?
# the relationship between engine size and fuel efficieny

# Scatterplots
ggplot(data=mpg) + geom_point(mapping = aes(x = displ, y = hwy))
# -> a negative relationship
#   a group of separate points: hwy>20, displ>5
anomaly <- factor(ifelse(mpg$displ>5 & mpg$hwy>20 | mpg$hwy>40,'anomaly','normal'))
qplot(data=mpg, x=displ, y=hwy, col=anomaly)
# add the class variable
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy, col=class))
# -> the outlying points are mostly two seater cars
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy, size=class))
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy, alpha=class))
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy, shape=class))
# -> shape can only take 6 discrete values
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy), color = "blue", cex=4, shape=5)
# -> manually setting the aestetics (all points blue + point size 4 + shape 5)
# Setting the aestetics:
# - inside of the aes() function, ggplot2 will map the aesthetic to data values and build a legend. 
# - outside of the aes() function, ggplot2 will directly set the aesthetic to your input (see the prev. plot)
# checking:
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, color = "blue", cex=4)) # see what happened, don't do this

# Geoms
# the geometrical object that a plot uses to represent data
# geom_point understands the following aesthetics:
# x
# y
# alpha
# colour
# fill
# shape
# size
# stroke
ggplot(mpg) + geom_point(aes(x=displ, y=hwy)) # see overlapping points -> use jitter position
ggplot(mpg) + geom_smooth(aes(x=displ, y=hwy))
ggplot(mpg) + geom_smooth(aes(x=displ, y=hwy, linetype=drv))
# Layers:
# multiple geoms on one plot ('layers')
ggplot(mpg) + geom_point(aes(x=displ, y=hwy)) + geom_smooth(aes(x=displ, y=hwy))
ggplot(mpg, aes(x=displ, y=hwy)) + geom_point() + geom_smooth()
ggplot(mpg, aes(x=displ, y=hwy)) + geom_point(aes(col=class)) + geom_smooth()
ggplot(mpg, aes(x=displ, y=hwy, col=drv)) + geom_point() + geom_smooth(aes(linetype=drv))
# data subsets
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point() + 
    geom_smooth(data=subset(mpg, cyl == 8)) # use the paramter name, as mapping is at position 1
# point size represents repeated observations for that point
ggplot(mpg, aes(x=displ, y=hwy)) + geom_count() 

# Bar Charts
ggplot(diamonds) + geom_bar(aes(x=cut))
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut))
ggplot(diamonds) + geom_bar(aes(x=cut, fill=clarity)) # stacked bar chart

# positions
ggplot(diamonds) + geom_bar(aes(x=cut, fill=clarity), position='stack') # tha same (default)
ggplot(diamonds) + geom_bar(aes(x=cut, fill=clarity), position='identity') # very bad - all bars start at y=0
ggplot(diamonds) + geom_bar(aes(x=cut, fill=clarity), position='fill') # scaling y per x, to fill or the space top-down
ggplot(diamonds) + geom_bar(aes(x=cut, fill=clarity), position='dodge') # bars beside one another
ggplot(diamonds) + geom_bar(aes(x=cut, fill=clarity), position='jitter') # not good for bar charts
ggplot(mpg, aes(x=displ, y=hwy)) + geom_point() # overlapping points
ggplot(mpg, aes(x=displ, y=hwy)) + geom_point(position='jitter') # to disentangle overlapping points
ggplot(mpg, aes(x=displ, y=hwy)) + geom_point(position='jitter', alpha=.5, size=4)
ggplot(mpg, aes(x=displ, y=hwy)) + geom_point(position='jitter', alpha=.25, size=10)
ggplot(mpg, aes(x=displ, y=hwy)) + geom_jitter()
?position_dodge
?position_fill
?position_identity
?position_jitter
?position_stack

# Stats
# Each geom in ggplot2 is associated with a default stat that it uses to plot your data.
# stats e.g.:
# - bar charts and histograms bin your data and then plot bin counts, the number of points that fall in each bin
# - smooth lines fit a model to your data and then plot the model line
# - boxplots calculate the quartiles of your data and then plot the quartiles as a box
?geom_bar
# You can:
# 1. change the stat that a geom uses
demo <- data.frame(
    a = c("bar_1","bar_2","bar_3"),
    b = c(20, 30, 40)
)
ggplot(demo) + geom_bar(aes(x=a))
ggplot(demo) + geom_bar(aes(x=b))
ggplot(data = demo) + geom_bar(mapping = aes(x = a, y = b), stat = "identity")
ggplot(data = demo) + geom_bar(mapping = aes(x = a, fill=b), width=1, position='jitter') # like in 2. (Mondrian)
ggplot(data = demo) + geom_bar(mapping = aes(x = a, fill=..count..)) # like in 3.
# 2.  customize how a stat does its job
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut), width = 1) # passing the width value to stats
# 3. tell ggplot2 how to use the stat
ggplot(data = diamonds) + geom_count(mapping = aes(x = cut, y = clarity))
ggplot(data = diamonds) + geom_count(mapping = aes(x = cut, y = clarity, size = ..prop.., group = clarity))
    # use prop from the stat function for the size of the bubbles

# Coordinate systems
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut))
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut), width=1)
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut), width=1) + coord_polar()
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut), width=1) + coord_polar(theta='y') # theta="y" reverses the fit
# pie chart:
ggplot(diamonds) + geom_bar(aes(x=factor(1), fill=cut))
ggplot(diamonds) + geom_bar(aes(x=factor(1), fill=cut), width=1)
ggplot(diamonds) + geom_bar(aes(x=factor(1), fill=cut), width=1) + coord_polar()
ggplot(diamonds) + geom_bar(aes(x=factor(1), fill=cut), width=1) + coord_polar(theta="y")
ggplot(diamonds) + geom_bar(aes(x=1, fill=cut), width=1) + coord_polar(theta="y") # doesn't work well

# Facets
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut))
ggplot(diamonds) + geom_bar(aes(x=clarity, fill=cut))
# single discrete variable
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut)) + facet_wrap(~clarity)
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut), width=1) + coord_polar() + facet_wrap(~clarity)
# combination of variables
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut)) + facet_grid(color~clarity)
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut), width=1) + coord_polar() + facet_grid(color~clarity)
# one variable, by rows or by columns only
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut)) + facet_grid(.~clarity) # one row, many columns
ggplot(diamonds) + geom_bar(aes(x=cut, fill=cut)) + facet_grid(clarity~.) # one column, many rows

# The layered grammar of graphics
# data -> compute stat (e.g. count) -> choose geom (e.g. bar) -> map vars to aes (e.g. count -> fill)
#   -> select coord sys -> facet if needed
#   -> add more layers (each having data, geom, mappings, stat, position...)
ggplot(diamonds) + geom_bar(aes(x=cut)) # stat='count' by default
ggplot(diamonds) + geom_bar(aes(x=cut, fill=..count..))
ggplot(diamonds) + geom_bar(aes(x=cut, fill=..count..), width=1) + coord_polar()
ggplot(diamonds) + geom_bar(aes(x=cut, fill=..count..), width=1) + coord_polar() + facet_wrap(~color)

# Communication with plots

# <--------------------------------------------------------------------------------

# labels
ggplot(mpg, aes(x=displ, y=hwy)) + geom_count() +
    labs(title='something funny', x='x axis', y='y axis')

# Extensions
library(GGally)
ls(package:GGally)
ggpairs(mtcars[3:7]) # pairs
?ggfacet

#














# Exercises

# 1. Scatterplots
str(mpg)
# discrete (char): manufacturer, model, trans, drv, fl, class
ggplot(mpg) +
    geom_point(aes(displ, hwy, col=manufacturer, size=model, alpha=trans, shape=drv))
# -> legend lists all values for all discrete vars
#   screen is overflowed with the legends
#   size etc. aren't good for discrere (char) variables
# continuous (num, int): displ, year, cyl, cty, hwy
ggplot(mpg) +
    geom_point(aes(displ, hwy, col=cyl, size=year, alpha=cty, shape=cyl))
# -> error: continuaus vars. can't be mapped to shape
ggplot(mpg) +
    geom_point(aes(displ, hwy, col=cyl, size=year, alpha=cty))
# -> the legend looks nicer, more succinct (only selected values displayed there)
# The same variable in multip. aes:
ggplot(mpg) +
    geom_point(aes(displ, hwy, col=cyl, size=cyl, alpha=cyl))
# -> alpha & size merged into one legend; color as a separate legend
ggplot(mpg) +
    geom_point(aes(displ, hwy, col=manufacturer, size=manufacturer, alpha=manufacturer, shape=manufacturer))
ggplot(mpg) +
    geom_point(aes(displ, hwy, col=drv, size=drv, alpha=drv, shape=drv))
# -> alpha & size & shape & col in one legend
# Expression assigned to an aes
ggplot(mpg) +
    geom_point(aes(displ, hwy, col=displ<5))
ggplot(mpg) +
    geom_point(aes(displ, hwy, col=mpg$displ>5 & mpg$hwy>20))

# 2. Geoms
# 1
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) + 
    geom_point() + geom_smooth()
# 2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point() + geom_smooth()
ggplot(mapping = aes(x = displ, y = hwy)) + # the same as above!
    geom_point(data = mpg) + geom_smooth(data = mpg)

# 3. Bar Charts

# 4. Facets
ggplot(mpg) + geom_point(aes(x=displ, y=hwy)) + facet_wrap(~class) # -> by a discrete var, wrapped
ggplot(mpg) + geom_point(aes(x=displ, y=hwy)) + facet_grid(drv~.) # -> in one column
ggplot(mpg) + geom_point(aes(x=displ, y=hwy)) + facet_grid(.~cyl) # -> in one row

