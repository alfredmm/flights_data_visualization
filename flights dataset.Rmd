---
title: "Visualization for Flight Delays"
author: ""
date: "9/29/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


## Flights Dataset
Import needed Libraries
```{r}
library(knitr)
library(nycflights13)
library(tidyverse)
library(lubridate)
library(plotrix)
library(ggplot2)
```

## Get the dataset
```{r}
nycflights13::flights
View(flights)
```

## Glimpse and Viewing
```{r}
glimpse(flights,width=50)

```
## Getting Day Names from Days' Index
Adding Flight Days to Destination names
```{r}
flites_dest_names <- flights %>%
inner_join(airports, by = c("dest" = "faa")) %>%
rename(dest_airport=name)

flites_day <- flites_dest_names %>% 
  mutate(weekday = wday(time_hour))
```

## Labeling the Flight Days
```{r}
flites_day$weekday <- factor(flites_day$weekday,
labels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
"Friday", "Saturday"))
```

## Verify Days versus Number of Flight Days
```{r}
flites_per_weekday <- flites_day %>%
group_by(weekday) %>%
summarize(number_of_flights = n())
```
(Visualize with Kabble)
```{r}
flites_per_weekday <- flites_day %>%
group_by(weekday) %>%
summarize(number_of_flights = n())

kable(flites_per_weekday)
```

## Delays in Weekday per Airport
First we create a summary
```{r}
summary_dep_delay <- flites_day %>%
group_by(origin, weekday) %>%
summarize(mean = mean(dep_delay, na.rm = TRUE),
std_dev = sd(dep_delay, na.rm = TRUE),
std_err = std.error(dep_delay,na.rm=TRUE))
```

## Visualizing the delays report for the week across airports
First we create a summary
```{r echo=FALSE}
ggplot(summary_dep_delay, aes(x=weekday, y=mean, fill=origin)) +
geom_bar(position="dodge", stat="identity",color="black")+
scale_fill_manual(name="Airport",values=c("blue","grey65","maroon"))+
geom_errorbar(aes(ymax=mean+std_err,ymin=mean-std_err), width=.1, position=position_dodge(.9))+
labs(y="Mean Departure Delay (min)")

```

## Results

Day of the week has the longest average delay time:\
| **Thursday** has the longest delay across all the airports\
Do the delay times vary by airport? What about weekday? \
| **EWK- Newark Airport** shows the highest delays across all delays, followed by **JKF- Jacksonville, Florida Airport** and **LGA- LaGuardia** respectively.

