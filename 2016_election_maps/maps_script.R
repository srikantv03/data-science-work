#Srikant Vasudevan
#October 12th 2019
#W7L1_SVasudevan.R
#THis script will create US maps with various demographical data

#Set working directory, source functions and load librariessetwd
("C:/Users/Srikant/Desktop/Data Science/Week 7")
library(tidyverse)
library(maps)
library(socviz)
library(gridExtra)
source("./myfunctionsaug.R")
source("./theme_map.R")
#Look at the election data
View(election)
dim(election)
str(election)
glimpse(election)
summary(election)

#There are no missing data

#Set the party Colors

partycolors <- c( "#0015BC", "#E9141D")
#Create a chart showing point margin by republicans


pointMarginRepubs <-
  ggplot(data=election,
         mapping=aes(x=r_points, y= reorder(state, r_points),
         color=party)) +
        geom_vline(xintercept = 0, color="blue") +
        geom_point(size = 2) +
        scale_color_manual(values=partycolors) + 
        scale_x_continuous(breaks=c(-90, -80, -70, -60, -50, -40, -30, -20,
                                    -10, 0, 10, 20, 30, 40, 50,60, 70, 80, 90),
                           labels=c("90\n (Clinton)", "80", "70", "60",
                                    "50", "40", "30", "20", "10",
                                    "0", "10", "20", "30", "40", "50", "60", "70",
                                    "80", "90\n (Trump)")) +
        facet_wrap(~ census, ncol=1, scales = "free_y") + 
        guides(color=FALSE) + 
        labs(title = "Point Margin \n by Republicans (SV)",
             x="Point Margin", y="") +
        theme(axis.text = element_text(size=8))
pointMarginRepubs        

#Create a chart showing point margin by democrats

pointMarginDemocrats <-
  ggplot(data=election,
         mapping=aes(x=r_points, y= reorder(state, d_points),
                     color=party)) +
  geom_vline(xintercept = 0, color="blue") +
  geom_point(size = 2) +
  scale_color_manual(values=partycolors) + 
  scale_x_continuous(breaks=c(-90, -80, -70, -60, -50, -40, -30, -20,
                              -10, 0, 10, 20, 30, 40, 50,60, 70, 80, 90),
                     labels=c("90\n (Clinton)", "80", "70", "60",
                              "50", "40", "30", "20", "10",
                              "0", "10", "20", "30", "40", "50", "60", "70",
                              "80", "90\n (Trump)")) +
  facet_wrap(~ census, ncol=1, scales = "free_y") + 
  guides(color=FALSE) + 
  labs(title = "Point Margin \n by Democrats (SV)",
       x="Point Margin", y="") +
  theme(axis.text = element_text(size=8))

pointMarginDemocrats
#Map US States Data
#Draw a simple map of the US
us_states <- map_data("state")
head(us_states)
dim(us_states)
View(us_states)
#Show the US map using geom polygon
usMaps <-
  ggplot(data=us_states,
         mapping=aes(x=long, y=lat, group=group,
                     fill=region)) +
  geom_polygon(color="white", size=.125)+
  guides(fill=FALSE)

#Draw the US map
usMaps

#Merge both the usMaps and election dataset
election$region <- tolower(election$state)
us_states_elec <- left_join(us_states, election)
summary(us_states_elec)

#Map elections by parties

usParties <-
    ggplot(data=us_states_elec,
           mapping=aes(x=long, y=lat, group=group ,fill=party)) +
  geom_polygon(color="black", size=.125) +
  guides(fill=FALSE)
usParties

#Make the graph look better
usParties2 <- 
  ggplot(data=us_states_elec,
         mapping=aes(x=long, y=lat, group=group ,fill=party)) +
  geom_polygon(color="white", size=0.1) +
  coord_map(projection="albers", lat0=30, lat1=45) +
  scale_fill_manual(values=partycolors) +
  labs(title="Election Results in 2016 (SV)", fill=NULL) +
  theme_map()
usParties2

#Make a similar graph, but this time it fills with the percentage of people in each state that voted for Trump
trump <-  ggplot(data=us_states_elec,
                 aes(x=long, y=lat, group=group ,fill=pct_trump)) +
  geom_polygon(color="white", size=0.1) +
  coord_map(projection="albers", lat0=30, lat1=45) +
  labs(title="Trump Election Results in 2016 (SV)", fill="Trump \n %") +
  theme_map()
trump
#Make a similar graph to the previous one, but this time with Clinton
clinton <-  ggplot(data=us_states_elec,
                 aes(x=long, y=lat, group=group ,fill=pct_clinton)) +
  geom_polygon(color="white", size=0.1) +
  coord_map(projection="albers", lat0=30, lat1=45) +
  labs(title="Clinton Election Results in 2016 (SV)", fill="Clinton \n %") +
  theme_map()
clinton

#Make a similar graph with the difference in percentages
diff <-  ggplot(data=us_states_elec,
                   aes(x=long, y=lat, group=group ,fill=pct_margin)) +
  geom_polygon(color="white", size=0.1) +
  coord_map(projection="albers", lat0=30, lat1=45) +
  labs(title="Election Results in 2016 (SV)", fill="Diff %") +
  theme_map()
diff

grid.arrange(usParties2, trump, clinton, diff, nrow=2)
pdf("elections_SVasudevan.pdf")
grid.arrange(usParties2, trump, clinton, diff, nrow=2)
dev.off()

pdf("pointMargins_SVasudevan.pdf")
grid.arrange(pointMarginRepubs, pointMarginDemocrats, nrow=1)
dev.off()
