#### Preamble ####
# Purpose: Clean the gathered data saved in outputs/data/raw_data.csv
# Author: Zhongyu Huang
# Data: 1 April 2022
# Contact: zhongyu.huang@mail.utoronto.ca 
# License: MIT


#### Workspace setup ####
# Use R Projects, not setwd().
library(haven)
library(tidyverse)
library(pointblank)
# Read in the raw data. 
dhs_data <- readr::read_csv("outputs/data/raw_data.csv")


# Just keep some variables that may be of interest  
reduced_data <- 
  dhs_data %>% 
  select(BG_inf,PT_Mom,PT_Pgt,PT_bear,NumOfTeen)

# clean up empty rows
reduced_data <- reduced_data[-c(1,8,12,30,36), ]

#test and check the data
#check the sum of number of teens in each section matches the Total
follow_up <- 
  reduced_data |> 
  mutate(check_sum = (2924),
         totals_match = if_else(reduced_data[2,5]+reduced_data[3,5]+ 
                                  reduced_data[4,5]+ reduced_data[5,5]
                                +reduced_data[6,5]== check_sum, 1, 0)
  ) |> 
  filter(totals_match == 0)

# check by using pointblank
agent <-
  create_agent(tbl = reduced_data) |>
  col_is_numeric(columns = 2:5) |> 
  interrogate()

#save the output to 'outputs/data/cleaned_data.csv’
write.csv(reduced_data, "outputs/data/cleaned_data.csv")


         