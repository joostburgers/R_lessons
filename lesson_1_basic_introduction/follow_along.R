#Author: Joost Burgers
#Date: 07-02-2021
#Course: Digital Humanities

#Coding with R, the very basics.

#Think of R as a fancy calculator with a lot of tricks and shortcuts

#For example, if you type in any addition, in the console below it will give you
#do the math for you.


#For me, R added 3+4 in a flash. Pretty sweet!


## Admittedly, adding individual numbers, can be done through an actual
## calculator or even your brain. Sometimes though, you might want to reuse a
## specific number over and over again. For example, if you want to find out how
## many yards there are in a meter, you have to multiply meters*1.0936. Rather
## than typing 1.0936 every time we can simply turn it into a variable. For
## example:

yard_conversion <- 1.0936 ##copy+paste this into the console below

#You'll note that yard_conversion just appeared in the top-right "environment"
#window This is where R shows you the variables. For reasons that will become
#clear, this is very, very useful. Now let's math! Say we are taking a penalty
#in football and we're in the US, we'd have to measure in yards. We can make
#this calculation by using the conversion variable.

11*yard_conversion

#You should get 12.0296 yards. So far so good.

#We can also use the variable for more complicated formulas. Let's say you want
#to know the area of a circle in yards, but you only know the radius is 23 meters.
#We can do that like so:

pi*(23*yard_conversion)^2

#That's pretty neat. Now, let's say you work for Circles International and
#you're constantly entering this formula. It gets pretty tedious. You want to be
#able to plug in the meters and get the result. To do this we can create a
#function. A function is a little piece of code that will take an input
#(variable/argument) and give (return) and output.

#Now before you copy+paste this, I should let you know that I've been making you
#work in the console when you could just be pressing run on this script. You
#want to be able to save your work. R stores your code in "scripts." This is the
#sequence of all the code. Whenever you start a new project you should open up a
#new script and save it. You can name it whatever you want, but the best naming
#convention is all lower case with an _ for a space. Do not put a space in your
#file name. A space is a special character and can get garbled when moving to
#different data formats.



AreaYards <- function (meters){
  
  return(pi*(meters*yard_conversion)^2)
 
}




#AreaYards is the name of the function. The blue word 'function' is a
#"reserved word" that is part of the syntax of R. Essentially, it tells R you
#want to create a function, much like the + operator tells it you want to add
#things. In the parenthesis is the variable (argument) that you are going to put
#in. It can have any name, but obviously it is useful to name it something that
#gives an indication as to what it is. Between the curly brackets is the "guts"
#of the function.This is where you take the variable that was entered and
#perform an operation on it. It then returns the result of that operation.

#Now that our function is made let's run it:

AreaYards(23)
AreaYards(15)

#Sweet! Same answer

#What makes R so powerful is that it has a lot of really useful functions for
#doing data science. In all likelihood you won't be writing any of your own
#functions, but borrowing what other people have already done. Base R has a lot
#of built in functions, but these can be expanded through "packages", bundles of
#functions that a good-Samaritan has created to make your life easier. We'll
#talk about this in a few.

#For example, if you want to get the current time that's actually a pretty
#involved process, because you have to access the system time on the operating
#system. Fear not, there's function:

Sys.Date()

#Note that even though we did not pass any variables to the function it still
#has the parentheses (). This is an easy way to identify functions. Tip:
#Sys.Date() and Sys.Time() are very useful for giving your output a time stamp.

#Alternatively, you can also "nest" a function inside the parameters of another function.
#For example: the seq() function will generate a sequential list based on values.

seq(1:10) #in R a number with a colon means a range of values

AreaYards(seq(1:10))
plot(AreaYards(seq(1:10)))
#I can even pass multiple arguments in the same function.

AreaYards(seq(from = 5, to =25, by=5))

#How did I know seq() can take multiple arguments? Use the help. typing ? and
#the function name will bring up the R help file (i.e. ?seq). Sometimes the language can be
#quite cryptic, but basically it tells you there are 5 arguments you can pass
#into the fucntion. If you follow the argument order, you don't need to be
#explicit about the arguments.

AreaYards(seq(5,25,5))

#I can nest even more

max(AreaYards(seq(5,25, by=5))) #Get the maximum value
min(AreaYards(seq(5,25, by=5))) #Get the minimum value

mean(c(max(AreaYards(seq(5,25, by=5))),min(AreaYards(seq(5,25, by=5))))) 
#Make a vector of the min/max and then calculate the mean. There is no
#reason to do this this way.

#Soooooo many parenthesis. This becomes very confusing very quickly. Avoid this.
#Your code should be readable by others. This is called "literate programming,"
#and for the purposes of academia it is extremely important. It means someone
#can step into your code and navigate it, even if they are not intimately
#familiar with the language. This is one key features of using programming for
#academic research.

#We can clean all this up.

circle_areas <- AreaYards(seq(5,25, by=5))
circle_areas_max <- max(circle_areas)
circle_areas_min <- min(circle_areas)
circle_areas_min_max <- c(circle_areas_min, circle_areas_max) #c(a,b,c...) concatenates values
circle_areas_mean <- mean(circle_areas_min_max)

#This code is a bit verbose. There's a lot of steps, and most of the are for
#creating intermediate variables that serve no purpose other than the final
#calculation. This happens a lot in R. So a fellow named Hadley Wickham came
#along and with a team of coders made the "tidyverse" package. This is a package
#used to do common data manipulations in R more efficiently. It is also a
#framework (dialect) of the R language meant to make it cleaner and more
#readable.

circle_areas <- AreaYards(seq(5,25,5))
circle_areas_mean2 <-  c(min(circle_areas),
                         max(circle_areas)) %>%
                         mean()
                  
  
# You notice the strange %>% (pipe) symbol. This basically means "and then."
# Thus, this line of code says concatenate the min and max values and then give
# the mean. with dplyr (part of tidyverse) you can pipe through a bunch of
# functions without reading them into variables or nesting them. It makes for
# clearer reading especially if you are piping through quite a number of
# commands.

#Now you'll note that if you try to run it it won't work. That's because you
#have not installed or loaded the package yet. But let's start on a clean page.



