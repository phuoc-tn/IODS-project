# Name: Phuoc Truong Nguyen
# Date: 30 Nov 2022
# Description: Data wrangling Rscript for Assignment 5.
# Source: https://hdr.undp.org/data-center/human-development-index#/indicies/HDI

#!/usr/bin/env Rscript

################################# Task 1. #################################
# Set working directory.
setwd("~/Desktop/GitHub/IODS-project/Data/")

# Read CSV file.
human_data <- read.csv("human.csv")

# Mutate GNI to numeric.
library(tidyverse)

human_data <- human_data %>% mutate(GNI = as.numeric(GNI))

# Check if it worked.
str(human_data$GNI)

################################# Task 2. #################################
# Define columns to keep.
columns_to_keep <-
  c(
    "Country",
    "Edu2.FM",
    "Labo.FM",
    "Edu.Exp",
    "Life.Exp",
    "GNI",
    "Mat.Mor",
    "Ado.Birth",
    "Parli.F"
  )

# Create new data frame with columns of interest.
new_human_data <- human_data %>% select(all_of(columns_to_keep))

################################# Task 3. #################################
# Remove rows with NA.
filtered_human_data <-
  new_human_data %>% filter(complete.cases(new_human_data))

################################# Task 4. #################################
# Check what countries/regions are in data frame.
unique(filtered_human_data$Country)

# Print out last (seven) of the countries/regions in the data frame and define regions to filter out.
regions <- tail(unique(human_data$Country), 7)

# Filter regions out of data frame.
new_filtered_human_data <-
  filtered_human_data %>% filter(!Country %in% regions)

################################# Task 5. #################################
# Use countries as row names.
rownames(new_filtered_human_data) <- new_filtered_human_data$Country

# Remove "Country" column from data frame.
final_human_data <- new_filtered_human_data %>% select(-Country)

# Check that final data is as expected (155 observations and 8 variables).
glimpse(final_human_data)

# Export data to CSV.
write.csv(final_human_data, "new_human.csv", row.names = T)
