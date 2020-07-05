# Data Science Work
Primarily work from the NCSSM online class, but includes some work of my own (including GUIs and functions)

In the KNN classification script, I use a dataset from the UCI machine learning repository:

 - The unknown variable is the variable being tested for
    
 - This script is more for computational purposes (this script will be used in an rmd file for analysis purposes)
    
myfunctionsaug.R is a functions file that I DID NOT create


## How to re-create.

To recreate the plots in a png or jpeg format, follow these steps:

 - Load all the dependencies.
 This is fairly simple, any library denoted at the top of the .R file as
 ```
 library(library_name)
 ```
 has to be downloaded to your computer first by typing the following into your R console
 ```
 install.packages('library_name')
 ```

 - Once the dependencies have been loaded, make sure the plot is correct, if possible, assign it to an object like so:
 
 ```
 plotName <- 
  ggplot(data = dataName,
         mapping=aes(x = x, y = y, group = group, fill = color)) +
  geom_polygon(color = color_1, size = size) +
  coord_map(projection = projection, lat0 = lat_0, lat1 = lat_1) +
  scale_fill_gradient(low = lowColor, high = highColor) +
  labs(title="Plot Title")
 ```
 This assigns a ggplot plot to the object plotName, so calling plotName like this
 ```
 plotName
 ```
 will display this in the 'plots' area of your IDE
 
 - Finally, use one of the following functions to output to whatever filetype you want:
 
 ```
 png(myPlot.png)
 plotName
 dev.off()
 
 jpeg(myPlot.jpg)
 plotName
 dev.off()
 
 bmp(myPlot.bmp)
 plotName
 dev.off()
 
 pdf(myPlot.pdf)
 plotName
 dev.off()
 ```
 Packages such as gridExtra allow you to include multiple plots in one file
 
 ```
 TEST FOR WEBSITE
 ```
 

