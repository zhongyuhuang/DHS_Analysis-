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
  select(-raw_data,-data)

# clean up empty rows
reduced_data <- reduced_data[-c(4, 22), ]

#test and check the data
#check that "25-49" stores the true average
follow_up <- 
  reduced_data |> 
  mutate(check_sum = (`25-29`+`30-34`+`35-39`+`40-44`+`45-49`)/5,
         totals_match = if_else(`25-49` == check_sum, 1, 0)
  ) |> 
  filter(totals_match == 0)

# check by using pointblank
agent <-
  create_agent(tbl = reduced_data) |>
  col_is_numeric(columns = 3:8) |> 
  interrogate()

#save the output to 'outputs/data/cleaned_data.csv’
write.csv(reduced_data, "outputs/data/cleaned_data.csv")


         