# Name: Phuoc Truong Nguyen
# Date: 8 Dec 2022
# Description: Data wrangling Rscript for Assignment 6.
# Sources: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
#          https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

#!/usr/bin/env Rscript

################################# Task 1. #################################
# Set working directory.
setwd("~/Desktop/GitHub/IODS-project/Data/")

# Read CSV files.
bprs <-
  read.csv(
    "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
    sep = " "
  )

rats <- read.csv(
  "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
  sep = "\t"
)

# Check variable names, contents, structures, and summaries.
str(bprs)
summary(bprs)

str(rats)
summary(rats)

# Convert categorical variables to factors.
library(tidyverse)

bprs <-
  bprs %>% mutate(treatment = as.factor(treatment),
                  subject = as.factor(subject))
rats <-
  rats %>% mutate(ID = as.factor(ID), Group = as.factor(Group))

# Check that conversion worked.
str(bprs)
str(rats)

# Convert data frames to long form.
bprs_long <-
  bprs %>% pivot_longer(
    cols = -c(treatment, subject),
    names_to = "week_og",
    values_to = "bprs"
  )

rats_long <-
  rats %>% pivot_longer(cols = -c(ID, Group),
                        names_to = "WD",
                        values_to = "Weight_g")

# Add variable "week" to bprs and "Time" to rats.
new_bprs_long <-
  bprs_long %>%
  mutate(week = as.numeric(substr(week_og, 5, 5))) %>%
  arrange(week)
new_rats_long <-
  rats_long %>%
  mutate(Time = as.numeric(substr(WD, 3, 4))) %>%
  arrange(Time)

# Check variable names, contents, structures, and summaries again.
str(new_bprs_long)
summary(new_bprs_long)

str(new_rats_long)
summary(new_rats_long)

#Export data for Analysis.
write.csv(new_bprs_long, "bprs.csv", row.names = F)
write.csv(new_rats_long, "rats.csv", row.names = F)
