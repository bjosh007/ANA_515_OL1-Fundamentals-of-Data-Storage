#1 - checking working directory
getwd()

library(tidyverse)

stormevents <- read.csv("StormEvents_details-ftp_v1.0_d1992_c20210803.csv", header = TRUE, sep = ",")
view(stormevents)
head(stormevents,6)
myvars <- c("BEGIN_DATE_TIME","END_DATE_TIME","EPISODE_ID","EVENT_ID","STATE","STATE_FIPS","CZ_NAME","CZ_TYPE","CZ_FIPS","EVENT_TYPE","SOURCE","BEGIN_LAT","BEGIN_LON","END_LAT","END_LON")
newdata <- stormevents[myvars]
view(newdata)

#3
library(lubridate)
library(dplyr)
newdata <- newdata%>%
  mutate(BEGIN_DATE_TIME = dmy_hms(BEGIN_DATE_TIME), END_DATE_TIME = dmy_hms(END_DATE_TIME))
view(newdata)

#4
library(stringr)
newdata$STATE=str_to_title(newdata$STATE)
newdata$CZ_NAME=str_to_title(newdata$CZ_NAME)         

#5
newdata=subset(newdata, CZ_TYPE = "C")

#6
str_pad(newdata$STATE_FIPS, width=3,side ="left", pad ="0")
str_pad(newdata$CZ_FIPS, width=3,side ="left", pad ="0")
unite(newdata,"FIPS",c(STATE_FIPS,CZ_FIPS),sep = "",remove = FALSE)
view(newdata)

#7
newdata=rename_all(newdata, tolower)
view(newdata)

#8
us_state_info=data.frame(state=state.name,area=state.area,region=state.region)
view(us_state_info)

#9
Newset = data.frame(table(newdata$state)
Newset = rename(Newset,c("state" = "Var1"))
View(Newset)
merged = merge(x=Newset, y=us_state_info,by.x = "state",by.y = "state")
view(merged)

#10
library(ggplot2)
plot = ggplot(merged,aes(x = area, y = Freq)) + geom_point(aes(color=region))+labs( x = "Land area (square miles)", y = "# of Storms in 1992")
plot
